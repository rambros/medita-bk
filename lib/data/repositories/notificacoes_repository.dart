import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:medita_bk/domain/models/ead/notificacao_ead_model.dart';
import 'package:medita_bk/domain/models/unified_notification.dart';
import 'package:medita_bk/domain/models/user_notification_state.dart';
import 'package:medita_bk/data/models/firebase/notification_model.dart';
import 'package:medita_bk/data/services/notificacao_ead_service.dart';
import 'package:medita_bk/data/services/auth/firebase_auth/auth_util.dart';

/// Repository para gerenciar notificações UNIFICADAS
/// Busca de TRÊS collections:
/// 1. in_app_notifications - Notificações in-app (tickets/discussões)
/// 2. ead_push_notifications - Push notifications EAD
/// 3. global_push_notifications - Push notifications globais
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
      // 1. Buscar notificações In-App (in_app_notifications)
      final inAppNotifications = await _notificacaoService.getNotificacoesByUsuario(
        userId,
        limite: limite,
        apenasNaoLidas: apenasNaoLidas,
      );

      allNotifications.addAll(
        inAppNotifications.map((n) => UnifiedNotification.fromEad(n)),
      );

      debugPrint('NotificacoesRepository: ${inAppNotifications.length} da collection in_app_notifications');
    } catch (e) {
      debugPrint('NotificacoesRepository: Erro ao buscar in_app_notifications - $e');
    }

    try {
      // 2. Buscar notificações EAD Push (ead_push_notifications)
      // Buscar email do usuário para queries por array
      String? userEmail;
      try {
        final userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          userEmail = userDoc.data()?['email'] as String?;
        }
      } catch (e) {
        debugPrint('Erro ao buscar email do usuário para EAD: $e');
      }

      // Query 1: Por destinatarioId (notificação individual)
      final eadPushSnapshotById = await _firestore
          .collection('ead_push_notifications')
          .where('destinatarioId', isEqualTo: userId)
          .orderBy('dataCriacao', descending: true)
          .limit(limite)
          .get();

      // Query 2: Por destinatarioTipo = 'Todos' (notificação para todos)
      final eadPushSnapshotTodos = await _firestore
          .collection('ead_push_notifications')
          .where('destinatarioTipo', isEqualTo: 'Todos')
          .orderBy('dataCriacao', descending: true)
          .limit(limite)
          .get();

      // Query 3: Por destinatariosIds array (notificação de grupo por UID)
      QuerySnapshot<Map<String, dynamic>>? eadPushSnapshotByIdsArray;
      try {
        eadPushSnapshotByIdsArray = await _firestore
            .collection('ead_push_notifications')
            .where('destinatariosIds', arrayContains: userId)
            .orderBy('dataCriacao', descending: true)
            .limit(limite)
            .get();
      } catch (e) {
        debugPrint('Query destinatariosIds não disponível ou falhou: $e');
      }

      // Query 4: Por destinatariosEmails array (notificação de grupo por email)
      QuerySnapshot<Map<String, dynamic>>? eadPushSnapshotByEmailsArray;
      if (userEmail != null && userEmail.isNotEmpty) {
        try {
          eadPushSnapshotByEmailsArray = await _firestore
              .collection('ead_push_notifications')
              .where('destinatariosEmails', arrayContains: userEmail)
              .orderBy('dataCriacao', descending: true)
              .limit(limite)
              .get();
        } catch (e) {
          debugPrint('Query destinatariosEmails não disponível ou falhou: $e');
        }
      }

      // Combinar e remover duplicatas
      final allEadDocs = <String, QueryDocumentSnapshot<Map<String, dynamic>>>{};

      for (final doc in eadPushSnapshotById.docs) {
        allEadDocs[doc.id] = doc;
      }

      for (final doc in eadPushSnapshotTodos.docs) {
        allEadDocs[doc.id] = doc;
      }

      if (eadPushSnapshotByIdsArray != null) {
        for (final doc in eadPushSnapshotByIdsArray.docs) {
          allEadDocs[doc.id] = doc;
        }
      }

      if (eadPushSnapshotByEmailsArray != null) {
        for (final doc in eadPushSnapshotByEmailsArray.docs) {
          allEadDocs[doc.id] = doc;
        }
      }

      // Processar notificações EAD Push com user_states
      for (final doc in allEadDocs.values) {
        final userStateDoc = await doc.reference
            .collection('user_states')
            .doc(userId)
            .get();

        final userState = userStateDoc.exists
            ? UserNotificationState.fromMap(userStateDoc.data()!, userId)
            : UserNotificationState(userId: userId);

        // Pular notificações ocultadas
        if (userState.ocultado) continue;

        // Se filtro de não lidas, pular lidas
        if (apenasNaoLidas && userState.lido) continue;

        // Converter documento para UnifiedNotification
        final data = doc.data();
        final notification = NotificacaoEadModel(
          id: doc.id,
          titulo: data['titulo'] ?? '',
          conteudo: data['mensagem'] ?? data['corpo'] ?? data['conteudo'] ?? '',
          tipo: data['tipo'] ?? 'notificacao_geral',
          destinatarioId: data['destinatarioId'] ?? '',
          dataCriacao: (data['dataCriacao'] as Timestamp?)?.toDate() ?? DateTime.now(),
          lido: userState.lido,
          dados: data['dados'] as Map<String, dynamic>? ?? {},
        );

        allNotifications.add(UnifiedNotification.fromEad(notification));
      }

      debugPrint('NotificacoesRepository: ${allEadDocs.length} notificações únicas da collection ead_push_notifications (${eadPushSnapshotById.docs.length} por ID, ${eadPushSnapshotTodos.docs.length} para todos, ${eadPushSnapshotByIdsArray?.docs.length ?? 0} por array IDs, ${eadPushSnapshotByEmailsArray?.docs.length ?? 0} por array emails)');
    } catch (e) {
      debugPrint('NotificacoesRepository: Erro ao buscar ead_push_notifications - $e');
    }

    try {
      // 3. Buscar notificações push globais (global_push_notifications)
      final userRef = _firestore.collection('users').doc(userId);

      // Buscar email do usuário para queries por email
      String? userEmail;
      try {
        final userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          userEmail = userDoc.data()?['email'] as String?;
        }
      } catch (e) {
        debugPrint('Erro ao buscar email do usuário: $e');
      }

      // Query 1: Notificações por recipientsRef (array de DocumentReference)
      final globalSnapshotRef = await _firestore
          .collection('global_push_notifications')
          .where('recipientsRef', arrayContains: userRef)
          .orderBy('dataEnvio', descending: true)
          .limit(limite)
          .get();

      // Query 2: Notificações "Todos" (typeRecipients == 'Todos')
      final globalSnapshotTodos = await _firestore
          .collection('global_push_notifications')
          .where('typeRecipients', isEqualTo: 'Todos')
          .orderBy('dataEnvio', descending: true)
          .limit(limite)
          .get();

      // Query 3: Notificações por email (se o usuário tiver email)
      QuerySnapshot<Map<String, dynamic>>? globalSnapshotEmail;
      if (userEmail != null && userEmail.isNotEmpty) {
        globalSnapshotEmail = await _firestore
            .collection('global_push_notifications')
            .where('recipientEmail', isEqualTo: userEmail)
            .orderBy('dataEnvio', descending: true)
            .limit(limite)
            .get();
      }

      // Combinar todas as notificações e remover duplicatas
      final allDocs = <String, QueryDocumentSnapshot<Map<String, dynamic>>>{};

      for (final doc in globalSnapshotRef.docs) {
        allDocs[doc.id] = doc;
      }

      for (final doc in globalSnapshotTodos.docs) {
        allDocs[doc.id] = doc;
      }

      if (globalSnapshotEmail != null) {
        for (final doc in globalSnapshotEmail.docs) {
          allDocs[doc.id] = doc;
        }
      }

      // Processar todas as notificações únicas
      for (final doc in allDocs.values) {
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

      debugPrint('NotificacoesRepository: ${allDocs.length} notificações únicas da collection global_push_notifications (${globalSnapshotRef.docs.length} por ref, ${globalSnapshotTodos.docs.length} para todos, ${globalSnapshotEmail?.docs.length ?? 0} por email)');
    } catch (e) {
      debugPrint('NotificacoesRepository: Erro ao buscar global_push_notifications - $e');
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
    final globalStream = _firestore
        .collection('global_push_notifications')
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
      final globalList = await globalStream.first;
      final combined = [...eadList, ...globalList];
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

  /// Marca uma notificação como lida (TODAS as collections)
  /// Collections: in_app_notifications, ead_push_notifications, global_push_notifications
  Future<bool> marcarComoLida(String notificacaoId) async {
    final userId = currentUserUid;
    if (userId.isEmpty) return false;

    try {
      // 1. Tenta marcar na collection in_app_notifications
      final inAppSuccess = await _notificacaoService.marcarComoLida(notificacaoId, userId);
      if (inAppSuccess) return true;

      // 2. Tenta marcar na collection ead_push_notifications
      final eadSuccess = await _marcarComoLidaEad(notificacaoId, userId);
      if (eadSuccess) return true;

      // 3. Tenta marcar na collection global_push_notifications
      return await _marcarComoLidaGlobal(notificacaoId, userId);
    } catch (e) {
      debugPrint('NotificacoesRepository.marcarComoLida: Erro - $e');
      return false;
    }
  }

  /// Marca notificação EAD (ead_push_notifications) como lida
  Future<bool> _marcarComoLidaEad(String notificacaoId, String userId) async {
    try {
      final notificationRef = _firestore.collection('ead_push_notifications').doc(notificacaoId);
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
      debugPrint('NotificacoesRepository._marcarComoLidaEad: Erro - $e');
      return false;
    }
  }

  /// Marca notificação global (global_push_notifications) como lida
  Future<bool> _marcarComoLidaGlobal(String notificacaoId, String userId) async {
    try {
      final notificationRef = _firestore.collection('global_push_notifications').doc(notificacaoId);
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
      debugPrint('NotificacoesRepository._marcarComoLidaGlobal: Erro - $e');
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
  /// Collections: in_app_notifications, ead_push_notifications, global_push_notifications
  Future<bool> removerNotificacao(String notificacaoId) async {
    final userId = currentUserUid;
    if (userId.isEmpty) return false;

    try {
      // 1. Tenta ocultar na collection in_app_notifications
      final inAppSuccess = await _notificacaoService.ocultarNotificacao(notificacaoId, userId);
      if (inAppSuccess) return true;

      // 2. Tenta ocultar na collection ead_push_notifications
      final eadSuccess = await _ocultarNotificacaoEad(notificacaoId, userId);
      if (eadSuccess) return true;

      // 3. Tenta ocultar na collection global_push_notifications
      return await _ocultarNotificacaoGlobal(notificacaoId, userId);
    } catch (e) {
      debugPrint('NotificacoesRepository.removerNotificacao: Erro - $e');
      return false;
    }
  }

  /// Oculta notificação EAD (ead_push_notifications)
  Future<bool> _ocultarNotificacaoEad(String notificacaoId, String userId) async {
    try {
      final notificationRef = _firestore.collection('ead_push_notifications').doc(notificacaoId);
      final doc = await notificationRef.get();

      if (!doc.exists) return false;

      final state = UserNotificationState(userId: userId).marcarComoOcultada();
      await notificationRef
          .collection('user_states')
          .doc(userId)
          .set(state.toMap(), SetOptions(merge: true));

      return true;
    } catch (e) {
      debugPrint('NotificacoesRepository._ocultarNotificacaoEad: Erro - $e');
      return false;
    }
  }

  /// Oculta notificação global (global_push_notifications)
  Future<bool> _ocultarNotificacaoGlobal(String notificacaoId, String userId) async {
    try {
      final notificationRef = _firestore.collection('global_push_notifications').doc(notificacaoId);
      final doc = await notificationRef.get();

      if (!doc.exists) return false;

      final state = UserNotificationState(userId: userId).marcarComoOcultada();
      await notificationRef
          .collection('user_states')
          .doc(userId)
          .set(state.toMap(), SetOptions(merge: true));

      return true;
    } catch (e) {
      debugPrint('NotificacoesRepository._ocultarNotificacaoGlobal: Erro - $e');
      return false;
    }
  }

  // === Helpers ===

  /// Retorna total de notificações não lidas
  Future<int> getTotalNaoLidas() async {
    final contador = await getContador();
    return contador.totalNaoLidas;
  }

  /// Conta notificações não lidas de TODAS as collections
  /// Collections: in_app_notifications, ead_push_notifications, global_push_notifications
  Future<int> contarNaoLidasUnificadas() async {
    final userId = currentUserUid;
    if (userId.isEmpty) return 0;

    int totalNaoLidas = 0;

    try {
      // 1. Contar não lidas da collection in_app_notifications
      final inAppNaoLidas = await _notificacaoService.contarNaoLidas(userId);
      totalNaoLidas += inAppNaoLidas;
      debugPrint('NotificacoesRepository: $inAppNaoLidas não lidas em in_app_notifications');
    } catch (e) {
      debugPrint('NotificacoesRepository: Erro ao contar in_app_notifications - $e');
    }

    try {
      // 2. Contar notificações não lidas da collection ead_push_notifications
      final eadSnapshot = await _firestore
          .collection('ead_push_notifications')
          .where('destinatarioId', isEqualTo: userId)
          .get();

      // Contar apenas as não lidas (verificando user_states)
      int eadNaoLidas = 0;
      for (final doc in eadSnapshot.docs) {
        final userStateDoc = await doc.reference
            .collection('user_states')
            .doc(userId)
            .get();

        final userState = userStateDoc.exists
            ? UserNotificationState.fromMap(userStateDoc.data()!, userId)
            : UserNotificationState(userId: userId);

        // Só conta se não foi lida e não está ocultada
        if (!userState.lido && !userState.ocultado) {
          eadNaoLidas++;
        }
      }

      totalNaoLidas += eadNaoLidas;
      debugPrint('NotificacoesRepository: $eadNaoLidas não lidas em ead_push_notifications');
    } catch (e) {
      debugPrint('NotificacoesRepository: Erro ao contar ead_push_notifications - $e');
    }

    try {
      // 3. Contar notificações não lidas da collection global_push_notifications
      final userRef = _firestore.collection('users').doc(userId);

      // Buscar todas as notificações globais para o usuário
      final globalSnapshot = await _firestore
          .collection('global_push_notifications')
          .where('recipientsRef', arrayContains: userRef)
          .get();

      // Contar apenas as não lidas (verificando user_states)
      int globalNaoLidas = 0;
      for (final doc in globalSnapshot.docs) {
        final userStateDoc = await doc.reference
            .collection('user_states')
            .doc(userId)
            .get();

        final userState = userStateDoc.exists
            ? UserNotificationState.fromMap(userStateDoc.data()!, userId)
            : UserNotificationState(userId: userId);

        // Só conta se não foi lida e não está ocultada
        if (!userState.lido && !userState.ocultado) {
          globalNaoLidas++;
        }
      }

      totalNaoLidas += globalNaoLidas;
      debugPrint('NotificacoesRepository: $globalNaoLidas não lidas em global_push_notifications');
    } catch (e) {
      debugPrint('NotificacoesRepository: Erro ao contar global_push_notifications - $e');
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

