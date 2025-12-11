import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:medita_bk/domain/models/ead/notificacao_ead_model.dart';
import 'package:medita_bk/data/models/firebase/notification_model.dart';

/// Service unificado que busca notificações de ambas as collections
/// Collection "notifications" (sistema antigo - broadcast)
/// Collection "notificacoes_ead" (sistema novo - EAD/tickets/discussões)
class UnifiedNotificationsService {
  final FirebaseFirestore _firestore;

  UnifiedNotificationsService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Busca notificações de AMBAS as collections
  Future<List<dynamic>> getAllNotificationsForUser(
    String userId, {
    int limite = 50,
  }) async {
    final allNotifications = <dynamic>[];

    try {
      // 1. Buscar da collection "notificacoes_ead" (novo sistema)
      final notificacoesEad = await _firestore
          .collection('notificacoes_ead')
          .where('destinatarioId', isEqualTo: userId)
          .orderBy('dataCriacao', descending: true)
          .limit(limite)
          .get();

      for (final doc in notificacoesEad.docs) {
        allNotifications.add(
          NotificacaoEadModel.fromMap(doc.data(), doc.id),
        );
      }

      debugPrint(
        'UnifiedNotifications: ${notificacoesEad.docs.length} da collection notificacoes_ead',
      );
    } catch (e) {
      debugPrint('Erro ao buscar notificacoes_ead: $e');
    }

    try {
      // 2. Buscar da collection "notifications" (sistema antigo)
      // Verificar se o usuário está na lista de destinatários
      final userRef = _firestore.collection('users').doc(userId);
      
      final notificationsOld = await _firestore
          .collection('notifications')
          .where('recipientsRef', arrayContains: userRef)
          .orderBy('dataEnvio', descending: true)
          .limit(limite)
          .get();

      for (final doc in notificationsOld.docs) {
        allNotifications.add(
          NotificationModel.fromFirestore(doc),
        );
      }

      debugPrint(
        'UnifiedNotifications: ${notificationsOld.docs.length} da collection notifications',
      );
    } catch (e) {
      debugPrint('Erro ao buscar notifications: $e');
    }

    // Ordenar todas por data (mais recente primeiro)
    allNotifications.sort((a, b) {
      final dateA = _getNotificationDate(a);
      final dateB = _getNotificationDate(b);
      return dateB.compareTo(dateA);
    });

    debugPrint(
      'UnifiedNotifications: Total de ${allNotifications.length} notificações',
    );

    return allNotifications;
  }

  /// Extrai a data de uma notificação (funciona com ambos os tipos)
  DateTime _getNotificationDate(dynamic notification) {
    if (notification is NotificacaoEadModel) {
      return notification.dataCriacao;
    } else if (notification is NotificationModel) {
      return notification.sendDate ?? DateTime.now();
    }
    return DateTime.now();
  }

  /// Verifica se existe alguma notificação em qualquer collection
  Future<bool> hasAnyNotifications(String userId) async {
    try {
      // Verificar notificacoes_ead
      final eadSnapshot = await _firestore
          .collection('notificacoes_ead')
          .where('destinatarioId', isEqualTo: userId)
          .limit(1)
          .get();

      if (eadSnapshot.docs.isNotEmpty) return true;

      // Verificar notifications
      final userRef = _firestore.collection('users').doc(userId);
      final oldSnapshot = await _firestore
          .collection('notifications')
          .where('recipientsRef', arrayContains: userRef)
          .limit(1)
          .get();

      return oldSnapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint('Erro ao verificar notificações: $e');
      return false;
    }
  }

  /// Conta notificações em ambas as collections
  Future<Map<String, int>> countNotifications(String userId) async {
    int eadCount = 0;
    int oldCount = 0;

    try {
      final eadSnapshot = await _firestore
          .collection('notificacoes_ead')
          .where('destinatarioId', isEqualTo: userId)
          .count()
          .get();
      eadCount = eadSnapshot.count ?? 0;
    } catch (e) {
      debugPrint('Erro ao contar notificacoes_ead: $e');
    }

    try {
      final userRef = _firestore.collection('users').doc(userId);
      final oldSnapshot = await _firestore
          .collection('notifications')
          .where('recipientsRef', arrayContains: userRef)
          .count()
          .get();
      oldCount = oldSnapshot.count ?? 0;
    } catch (e) {
      debugPrint('Erro ao contar notifications: $e');
    }

    return {
      'notificacoes_ead': eadCount,
      'notifications': oldCount,
      'total': eadCount + oldCount,
    };
  }
}

