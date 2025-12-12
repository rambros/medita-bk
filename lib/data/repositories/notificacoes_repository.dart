/// Repository simplificado de notificações
/// UMA collection, UMA query, sem complexidade
///
/// Collection: notifications (única)
/// Query: arrayContainsAny com userId e "TODOS"
library;

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:medita_bk/domain/models/notificacao.dart';
import 'package:medita_bk/domain/models/user_notification_state.dart';
import 'package:medita_bk/data/services/auth/firebase_auth/auth_util.dart';

/// Repository para gerenciar notificações (sistema simplificado)
class NotificacoesRepository {
  final FirebaseFirestore _firestore;

  static const String _notificationsCollection = 'notifications';

  NotificacoesRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // === QUERIES ===

  /// Busca notificações do usuário
  /// UMA query simples com arrayContainsAny!
  Future<List<Notificacao>> getNotificacoes({
    int limite = 20,
    bool apenasNaoLidas = false,
  }) async {
    final userId = currentUserUid;
    if (userId.isEmpty) {
      debugPrint('NotificacoesRepository: Usuário não autenticado');
      return [];
    }

    try {
      debugPrint('🔔 Buscando notificações para userId: $userId');

      // UMA query simples!
      final snapshot = await _firestore
          .collection(_notificationsCollection)
          .where('destinatarios', arrayContainsAny: [userId, 'TODOS'])
          .orderBy('dataCriacao', descending: true)
          .limit(limite)
          .get();

      debugPrint('🔔 Encontradas ${snapshot.docs.length} notificações');
      
      // DEBUG: Log detalhado de cada notificação
      for (final doc in snapshot.docs) {
        final data = doc.data();
        debugPrint('📄 Notificação: ${doc.id}');
        debugPrint('  - tipo: ${data['tipo']}');
        debugPrint('  - titulo: ${data['titulo']}');
        debugPrint('  - destinatarios: ${data['destinatarios']}');
        debugPrint('  - dataCriacao: ${data['dataCriacao']}');
      }

      final notificacoes = <Notificacao>[];

      for (final doc in snapshot.docs) {
        // Busca estado do usuário
        final userStateDoc = await doc.reference
            .collection('user_states')
            .doc(userId)
            .get();

        final userState = userStateDoc.exists
            ? UserNotificationState.fromMap(userStateDoc.data()!, userId)
            : null;

        debugPrint('🔍 Processando ${doc.id}: lido=${userState?.lido}, ocultado=${userState?.ocultado}');

        // Pula se ocultado
        if (userState?.ocultado ?? false) {
          debugPrint('⏭️ Pulando ${doc.id} - ocultado');
          continue;
        }

        // Pula se lido (quando filtrando não lidas)
        if (apenasNaoLidas && (userState?.lido ?? false)) {
          debugPrint('⏭️ Pulando ${doc.id} - lido (filtro ativo)');
          continue;
        }

        final notificacao = Notificacao.fromFirestore(doc, userState);
        debugPrint('✅ Adicionando notificação: ${notificacao.tipo.label}');
        notificacoes.add(notificacao);
      }

      debugPrint('🔔 Total após filtros: ${notificacoes.length} notificações');
      debugPrint('📋 Tipos: ${notificacoes.map((n) => n.tipo.label).join(", ")}');
      return notificacoes;
    } catch (e) {
      debugPrint('❌ Erro ao buscar notificações: $e');
      return [];
    }
  }

  /// Stream de notificações
  /// UM stream simples!
  Stream<List<Notificacao>> streamNotificacoes({
    int limite = 20,
  }) async* {
    final userId = currentUserUid;
    if (userId.isEmpty) {
      debugPrint('NotificacoesRepository Stream: Usuário não autenticado');
      yield [];
      return;
    }

    debugPrint('🔔 Stream iniciado para userId: $userId');

    try {
      await for (final snapshot in _firestore
          .collection(_notificationsCollection)
          .where('destinatarios', arrayContainsAny: [userId, 'TODOS'])
          .orderBy('dataCriacao', descending: true)
          .limit(limite)
          .snapshots()) {

        debugPrint('🔔 Stream: ${snapshot.docs.length} notificações recebidas');

        final notificacoes = <Notificacao>[];

        for (final doc in snapshot.docs) {
          final data = doc.data();
          debugPrint('📄 Stream Doc: ${doc.id} tipo=${data['tipo']}');
          
          final userStateDoc = await doc.reference
              .collection('user_states')
              .doc(userId)
              .get();

          final userState = userStateDoc.exists
              ? UserNotificationState.fromMap(userStateDoc.data()!, userId)
              : null;

          debugPrint('  - userState: lido=${userState?.lido}, ocultado=${userState?.ocultado}');

          // Pula se ocultado
          if (userState?.ocultado ?? false) {
            debugPrint('  - ⏭️ Pulando (ocultado)');
            continue;
          }

          final notif = Notificacao.fromFirestore(doc, userState);
          debugPrint('  - ✅ Adicionando: ${notif.tipo.label}');
          notificacoes.add(notif);
        }

        debugPrint('🔔 Stream: Emitindo ${notificacoes.length} notificações');
        debugPrint('📋 Stream Tipos: ${notificacoes.map((n) => n.tipo.label).join(", ")}');
        yield notificacoes;
      }
    } catch (e) {
      debugPrint('❌ Erro no stream de notificações: $e');
      yield [];
    }
  }

  // === MUTATIONS ===

  /// Marca uma notificação como lida
  Future<bool> marcarComoLida(String notificacaoId) async {
    final userId = currentUserUid;
    if (userId.isEmpty) return false;

    try {
      debugPrint('📖 Marcando notificação $notificacaoId como lida');

      final notifRef = _firestore
          .collection(_notificationsCollection)
          .doc(notificacaoId);

      // Verifica se notificação existe
      final doc = await notifRef.get();
      if (!doc.exists) {
        debugPrint('❌ Notificação $notificacaoId não existe');
        return false;
      }

      // Atualiza user_state
      await notifRef.collection('user_states').doc(userId).set({
        'lido': true,
        'dataLeitura': FieldValue.serverTimestamp(),
        'ocultado': false, // Preserva ou cria campo
      }, SetOptions(merge: true));

      // Dummy update para trigger de stream
      await notifRef.update({
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Notificação marcada como lida');
      return true;
    } catch (e) {
      debugPrint('❌ Erro ao marcar como lida: $e');
      return false;
    }
  }

  /// Marca todas as notificações como lidas
  Future<bool> marcarTodasComoLidas() async {
    final userId = currentUserUid;
    if (userId.isEmpty) return false;

    try {
      debugPrint('📖 Marcando todas as notificações como lidas');

      final snapshot = await _firestore
          .collection(_notificationsCollection)
          .where('destinatarios', arrayContainsAny: [userId, 'TODOS'])
          .get();

      final batch = _firestore.batch();
      int count = 0;

      for (final doc in snapshot.docs) {
        // Atualiza user_state
        final userStateRef = doc.reference
            .collection('user_states')
            .doc(userId);

        batch.set(userStateRef, {
          'lido': true,
          'dataLeitura': FieldValue.serverTimestamp(),
          'ocultado': false,
        }, SetOptions(merge: true));

        // Dummy update
        batch.update(doc.reference, {
          'lastUpdated': FieldValue.serverTimestamp(),
        });

        count++;

        // Firestore batch limit é 500
        if (count % 500 == 0) {
          await batch.commit();
        }
      }

      if (count % 500 != 0) {
        await batch.commit();
      }

      debugPrint('✅ $count notificações marcadas como lidas');
      return true;
    } catch (e) {
      debugPrint('❌ Erro ao marcar todas como lidas: $e');
      return false;
    }
  }

  /// Remove (oculta) uma notificação
  Future<bool> removerNotificacao(String notificacaoId) async {
    final userId = currentUserUid;
    if (userId.isEmpty) return false;

    try {
      debugPrint('🗑️ Ocultando notificação $notificacaoId');

      final notifRef = _firestore
          .collection(_notificationsCollection)
          .doc(notificacaoId);

      // Verifica se existe
      final doc = await notifRef.get();
      if (!doc.exists) {
        debugPrint('❌ Notificação $notificacaoId não existe');
        return false;
      }

      // Busca estado atual para preservar campo 'lido'
      final userStateDoc = await notifRef
          .collection('user_states')
          .doc(userId)
          .get();

      final currentState = userStateDoc.exists
          ? UserNotificationState.fromMap(userStateDoc.data()!, userId)
          : UserNotificationState(userId: userId);

      // Marca como ocultado preservando 'lido'
      final newState = currentState.marcarComoOcultada();
      await notifRef.collection('user_states').doc(userId).set(
        newState.toMap(),
        SetOptions(merge: true),
      );

      // Dummy update
      await notifRef.update({
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Notificação ocultada');
      return true;
    } catch (e) {
      debugPrint('❌ Erro ao ocultar: $e');
      return false;
    }
  }

  // === CONTADORES ===

  /// Conta notificações não lidas
  Future<int> contarNaoLidas() async {
    final userId = currentUserUid;
    if (userId.isEmpty) return 0;

    try {
      final snapshot = await _firestore
          .collection(_notificationsCollection)
          .where('destinatarios', arrayContainsAny: [userId, 'TODOS'])
          .get();

      int count = 0;

      for (final doc in snapshot.docs) {
        final userStateDoc = await doc.reference
            .collection('user_states')
            .doc(userId)
            .get();

        final userState = userStateDoc.exists
            ? UserNotificationState.fromMap(userStateDoc.data()!, userId)
            : null;

        // Conta se não lido e não ocultado
        if (!(userState?.lido ?? false) && !(userState?.ocultado ?? false)) {
          count++;
        }
      }

      return count;
    } catch (e) {
      debugPrint('❌ Erro ao contar não lidas: $e');
      return 0;
    }
  }

  /// Stream do contador de não lidas
  Stream<int> streamContadorNaoLidas() async* {
    await for (final notificacoes in streamNotificacoes()) {
      final count = notificacoes.where((n) => !n.lido).length;
      yield count;
    }
  }
}
