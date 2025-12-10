import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:medita_b_k/domain/models/ead/notificacao_ead_model.dart';
import 'package:medita_b_k/domain/models/unified_notification.dart';
import 'package:medita_b_k/domain/models/user_notification_state.dart';
import 'package:medita_b_k/data/models/firebase/notification_model.dart';
import 'package:medita_b_k/data/services/notificacao_ead_service.dart';
import 'package:medita_b_k/data/services/auth/firebase_auth/auth_util.dart';

/// Repository para gerenciar notificações UNIFICADAS
/// Busca de AMBAS as collections: notificacoes_ead + notifications
/// Fonte de verdade para todas as operações relacionadas a notificações
class NotificacoesRepository {
  final NotificacaoEadService _notificacaoService;
  final FirebaseFirestore _firestore;

  NotificacoesRepository({
    NotificacaoEadService? notificacaoService,
    FirebaseFirestore? firestore,
  }) : _notificacaoService = notificacaoService ?? NotificacaoEadService(),
       _firestore = firestore ?? FirebaseFirestore.instance;

  // === Queries UNIFICADAS (Ambas collections) ===

  /// Busca notificações UNIFICADAS de ambas as collections
  Future<List<UnifiedNotification>> getNotificacoesUnificadas({
    int limite = 50,
    bool apenasNaoLidas = false,
  }) async {
    final userId = currentUserUid;
    if (userId.isEmpty) {
      debugPrint('NotificacoesRepository: Usuário não autenticado');
      return [];
    }

    final allNotifications = <UnifiedNotification>[];

    try {
      // 1. Buscar notificações EAD (notificacoes_ead)
      final eadNotifications = await _notificacaoService.getNotificacoesByUsuario(
        userId,
        limite: limite,
        apenasNaoLidas: apenasNaoLidas,
      );
      
      allNotifications.addAll(
        eadNotifications.map((n) => UnifiedNotification.fromEad(n)),
      );
      
      debugPrint('NotificacoesRepository: ${eadNotifications.length} da collection notificacoes_ead');
    } catch (e) {
      debugPrint('NotificacoesRepository: Erro ao buscar notificacoes_ead - $e');
    }

    try {
      // 2. Buscar notificações antigas (notifications)
      final userRef = _firestore.collection('users').doc(userId);

      final legacySnapshot = await _firestore
          .collection('notifications')
          .where('recipientsRef', arrayContains: userRef)
          .orderBy('dataEnvio', descending: true)
          .limit(limite)
          .get();

      for (final doc in legacySnapshot.docs) {
        // Buscar estado do usuário
        final userStateDoc = await doc.reference
            .collection('user_states')
            .doc(userId)
            .get();

        final userState = userStateDoc.exists
            ? UserNotificationState.fromMap(userStateDoc.data()!, userId)
            : UserNotificationState(userId: userId);

        // Pula notificações ocultadas
        if (userState.ocultado) continue;

        // Se está filtrando apenas não lidas, pula as lidas
        if (apenasNaoLidas && userState.lido) continue;

        final notification = NotificationModel.fromFirestore(doc);
        // Passa o estado de leitura para o UnifiedNotification
        allNotifications.add(
          UnifiedNotification.fromLegacy(notification, lido: userState.lido),
        );
      }

      debugPrint('NotificacoesRepository: ${legacySnapshot.docs.length} da collection notifications');
    } catch (e) {
      debugPrint('NotificacoesRepository: Erro ao buscar notifications - $e');
    }

    // Ordenar todas por data (mais recente primeiro)
    allNotifications.sort((a, b) => b.dataCriacao.compareTo(a.dataCriacao));
    
    debugPrint('NotificacoesRepository: Total de ${allNotifications.length} notificações unificadas');
    
    return allNotifications;
  }

  /// Stream de notificações UNIFICADAS
  Stream<List<UnifiedNotification>> streamNotificacoesUnificadas({
    int limite = 50,
  }) {
    final userId = currentUserUid;
    if (userId.isEmpty) {
      return Stream.value([]);
    }

    // Combinar streams de ambas as collections
    final eadStream = _notificacaoService
        .streamNotificacoesByUsuario(userId, limite: limite)
        .map((list) => list.map((n) => UnifiedNotification.fromEad(n)).toList());

    final userRef = _firestore.collection('users').doc(userId);
    final legacyStream = _firestore
        .collection('notifications')
        .where('recipientsRef', arrayContains: userRef)
        .orderBy('dataEnvio', descending: true)
        .limit(limite)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UnifiedNotification.fromLegacy(
                  NotificationModel.fromFirestore(doc),
                ))
            .toList());

    // Combinar ambos os streams
    return eadStream.asyncMap((eadList) async {
      final legacyList = await legacyStream.first;
      final combined = [...eadList, ...legacyList];
      combined.sort((a, b) => b.dataCriacao.compareTo(a.dataCriacao));
      return combined;
    });
  }

  /// [DEPRECATED] Busca apenas notificações EAD (use getNotificacoesUnificadas)
  Future<List<NotificacaoEadModel>> getNotificacoes({
    int limite = 50,
    bool apenasNaoLidas = false,
  }) async {
    final userId = currentUserUid;
    if (userId.isEmpty) {
      return [];
    }

    try {
      return await _notificacaoService.getNotificacoesByUsuario(
        userId,
        limite: limite,
        apenasNaoLidas: apenasNaoLidas,
      );
    } catch (e) {
      debugPrint('NotificacoesRepository.getNotificacoes: Erro - $e');
      return [];
    }
  }

  /// Busca contador de notificações não lidas
  Future<ContadorNotificacoesEad> getContador() async {
    final userId = currentUserUid;
    if (userId.isEmpty) {
      return const ContadorNotificacoesEad();
    }

    try {
      return await _notificacaoService.getContadores(userId);
    } catch (e) {
      debugPrint('NotificacoesRepository.getContador: Erro - $e');
      return const ContadorNotificacoesEad();
    }
  }

  /// Stream do contador de notificações
  Stream<ContadorNotificacoesEad> streamContador() {
    final userId = currentUserUid;
    if (userId.isEmpty) {
      return Stream.value(const ContadorNotificacoesEad());
    }

    return _notificacaoService.streamContadores(userId);
  }

  // === Mutations ===

  /// Marca uma notificação como lida (ambas collections)
  Future<bool> marcarComoLida(String notificacaoId) async {
    final userId = currentUserUid;
    if (userId.isEmpty) return false;

    try {
      // Tenta marcar na collection notificacoes_ead primeiro
      final eadSuccess = await _notificacaoService.marcarComoLida(notificacaoId, userId);
      if (eadSuccess) return true;

      // Se não encontrou em notificacoes_ead, tenta em notifications (legacy)
      return await _marcarComoLidaLegacy(notificacaoId, userId);
    } catch (e) {
      debugPrint('NotificacoesRepository.marcarComoLida: Erro - $e');
      return false;
    }
  }

  /// Marca notificação legacy (notifications) como lida
  Future<bool> _marcarComoLidaLegacy(String notificacaoId, String userId) async {
    try {
      final notificationRef = _firestore.collection('notifications').doc(notificacaoId);
      final doc = await notificationRef.get();

      if (!doc.exists) return false;

      // Busca estado atual
      final userStateDoc = await notificationRef
          .collection('user_states')
          .doc(userId)
          .get();

      final currentState = userStateDoc.exists
          ? UserNotificationState.fromMap(userStateDoc.data()!, userId)
          : UserNotificationState(userId: userId);

      // Só atualiza se ainda não foi lida
      if (!currentState.lido) {
        final newState = currentState.marcarComoLida();
        await notificationRef
            .collection('user_states')
            .doc(userId)
            .set(newState.toMap(), SetOptions(merge: true));
      }

      return true;
    } catch (e) {
      debugPrint('NotificacoesRepository._marcarComoLidaLegacy: Erro - $e');
      return false;
    }
  }

  /// Marca todas as notificações como lidas
  Future<bool> marcarTodasComoLidas() async {
    final userId = currentUserUid;
    if (userId.isEmpty) return false;

    try {
      return await _notificacaoService.marcarTodasComoLidas(userId);
    } catch (e) {
      debugPrint('NotificacoesRepository.marcarTodasComoLidas: Erro - $e');
      return false;
    }
  }

  /// Remove (oculta) uma notificação para o usuário atual
  /// A notificação não é deletada do Firestore, apenas marcada como ocultada
  Future<bool> removerNotificacao(String notificacaoId) async {
    final userId = currentUserUid;
    if (userId.isEmpty) return false;

    try {
      // Tenta ocultar na collection notificacoes_ead primeiro
      final eadSuccess = await _notificacaoService.ocultarNotificacao(notificacaoId, userId);
      if (eadSuccess) return true;

      // Se não encontrou em notificacoes_ead, tenta em notifications (legacy)
      return await _ocultarNotificacaoLegacy(notificacaoId, userId);
    } catch (e) {
      debugPrint('NotificacoesRepository.removerNotificacao: Erro - $e');
      return false;
    }
  }

  /// Oculta notificação legacy (notifications)
  Future<bool> _ocultarNotificacaoLegacy(String notificacaoId, String userId) async {
    try {
      final notificationRef = _firestore.collection('notifications').doc(notificacaoId);
      final doc = await notificationRef.get();

      if (!doc.exists) return false;

      final state = UserNotificationState(userId: userId).marcarComoOcultada();
      await notificationRef
          .collection('user_states')
          .doc(userId)
          .set(state.toMap(), SetOptions(merge: true));

      return true;
    } catch (e) {
      debugPrint('NotificacoesRepository._ocultarNotificacaoLegacy: Erro - $e');
      return false;
    }
  }

  // === Helpers ===

  /// Retorna total de notificações não lidas
  Future<int> getTotalNaoLidas() async {
    final contador = await getContador();
    return contador.totalNaoLidas;
  }

  /// Conta notificações não lidas de AMBAS as collections
  Future<int> contarNaoLidasUnificadas() async {
    final userId = currentUserUid;
    if (userId.isEmpty) return 0;

    int totalNaoLidas = 0;

    try {
      // Contar não lidas da collection notificacoes_ead
      final eadNaoLidas = await _notificacaoService.contarNaoLidas(userId);
      totalNaoLidas += eadNaoLidas;
      debugPrint('NotificacoesRepository: $eadNaoLidas não lidas em notificacoes_ead');
    } catch (e) {
      debugPrint('NotificacoesRepository: Erro ao contar notificacoes_ead - $e');
    }

    try {
      // Contar todas da collection notifications (não tem campo "lido")
      final userRef = _firestore.collection('users').doc(userId);
      final legacySnapshot = await _firestore
          .collection('notifications')
          .where('recipientsRef', arrayContains: userRef)
          .count()
          .get();
      
      final legacyCount = legacySnapshot.count ?? 0;
      totalNaoLidas += legacyCount;
      debugPrint('NotificacoesRepository: $legacyCount notificações em notifications');
    } catch (e) {
      debugPrint('NotificacoesRepository: Erro ao contar notifications - $e');
    }

    debugPrint('NotificacoesRepository: Total de $totalNaoLidas notificações não lidas');
    return totalNaoLidas;
  }

  /// [DEPRECATED] Conta apenas notificações EAD (use contarNaoLidasUnificadas)
  Future<int> contarNaoLidas() async {
    final userId = currentUserUid;
    if (userId.isEmpty) return 0;

    try {
      return await _notificacaoService.contarNaoLidas(userId);
    } catch (e) {
      debugPrint('NotificacoesRepository.contarNaoLidas: Erro - $e');
      return 0;
    }
  }
}

