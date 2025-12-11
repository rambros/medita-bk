import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:medita_bk/data/services/auth/firebase_auth/auth_util.dart';
import 'package:medita_bk/data/repositories/notificacoes_repository.dart';
import 'package:medita_bk/data/services/unified_notifications_service.dart';

/// Widget de debug para verificar informações de notificações
/// Útil para diagnosticar problemas
/// Mostra informações de TODAS as collections:
/// - in_app_notifications
/// - global_push_notifications
class NotificacoesDebugInfo extends StatelessWidget {
  const NotificacoesDebugInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = NotificacoesRepository();
    final unifiedService = UnifiedNotificationsService();
    final userId = currentUserUid;
    final userEmail = currentUserEmail;

    return Card(
      margin: const EdgeInsets.all(16),
      color: Colors.amber[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bug_report, color: Colors.orange),
                const SizedBox(width: 8),
                const Text(
                  'DEBUG INFO',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            
            // User Info
            Text('User ID: $userId', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Email: $userEmail', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Autenticado: ${userId.isNotEmpty ? "✅ Sim" : "❌ Não"}'),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            
            // Collection: in_app_notifications
            const Text(
              '📊 Collection: in_app_notifications',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              '(Notificações In-App - Tickets/Discussões)',
              style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            FutureBuilder(
              future: repository.getNotificacoes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('⏳ Carregando...');
                }
                
                if (snapshot.hasError) {
                  return Text(
                    '❌ Erro: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  );
                }

                final notificacoes = snapshot.data ?? [];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total: ${notificacoes.length} notificações'),
                    if (notificacoes.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text('✅ Última: "${notificacoes.first.titulo}"'),
                      Text('   Data: ${notificacoes.first.dataCriacao}'),
                    ] else
                      const Text('⚠️ Nenhuma notificação encontrada'),
                  ],
                );
              },
            ),
            
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // Collection: ead_push_notifications
            const Text(
              '📊 Collection: ead_push_notifications',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              '(Push Notifications EAD)',
              style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            FutureBuilder(
              future: _getEadPushNotificationsDetails(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('⏳ Carregando...');
                }

                if (snapshot.hasError) {
                  return Text(
                    '❌ Erro: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  );
                }

                final data = snapshot.data ?? {};
                final countByDestinatarioId = data['byDestinatarioId'] ?? 0;
                final countByDestinatarioTipo = data['byDestinatarioTipo'] ?? 0;
                final countByDestinatariosIds = data['byDestinatariosIds'] ?? 0;
                final countByDestinatariosEmails = data['byDestinatariosEmails'] ?? 0;
                final totalDocs = data['total'] ?? 0;
                final sampleDoc = data['sample'] as Map<String, dynamic>?;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total de documentos: $totalDocs'),
                    Text('Por destinatarioId=$userId: $countByDestinatarioId'),
                    Text('Por destinatarioTipo=Todos: $countByDestinatarioTipo'),
                    Text('Por destinatariosIds (grupo): $countByDestinatariosIds'),
                    Text('Por destinatariosEmails (grupo): $countByDestinatariosEmails'),
                    if (sampleDoc != null) ...[
                      const SizedBox(height: 4),
                      const Text('📄 Exemplo de documento:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                      Text('  destinatarioId: ${sampleDoc['destinatarioId'] ?? 'null'}', style: const TextStyle(fontSize: 10)),
                      Text('  destinatarioTipo: ${sampleDoc['destinatarioTipo'] ?? 'null'}', style: const TextStyle(fontSize: 10)),
                      Text('  titulo: ${sampleDoc['titulo'] ?? 'null'}', style: const TextStyle(fontSize: 10)),
                      if (sampleDoc['destinatariosIds'] != null)
                        Text('  destinatariosIds: ${(sampleDoc['destinatariosIds'] as List?)?.length ?? 0} items', style: const TextStyle(fontSize: 10)),
                      if (sampleDoc['destinatariosEmails'] != null)
                        Text('  destinatariosEmails: ${(sampleDoc['destinatariosEmails'] as List?)?.length ?? 0} items', style: const TextStyle(fontSize: 10)),
                    ],
                    if (totalDocs == 0)
                      const Text('⚠️ Nenhum documento na collection'),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // Collection: global_push_notifications
            const Text(
              '📊 Collection: global_push_notifications',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              '(Push Notifications Globais)',
              style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            FutureBuilder(
              future: unifiedService.countNotifications(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('⏳ Carregando...');
                }

                if (snapshot.hasError) {
                  return Text(
                    '❌ Erro: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  );
                }

                final counts = snapshot.data ?? {};
                final oldCount = counts['notifications'] ?? 0;
                final total = counts['total'] ?? 0;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total: $oldCount notificações'),
                    if (oldCount == 0)
                      const Text('⚠️ Nenhuma notificação encontrada'),
                    const SizedBox(height: 8),
                    Text(
                      '📊 TOTAL GERAL: $total notificações',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
            ),
            
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            
            // Contador
            const Text(
              '🔢 Contador de Não Lidas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            FutureBuilder(
              future: repository.getContador(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final contador = snapshot.data!;
                  return Text('Total não lidas: ${contador.totalNaoLidas}');
                }
                return const Text('⏳ Carregando...');
              },
            ),
            
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '💡 DICA',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Se "global_push_notifications" tem itens mas "in_app_notifications" está vazio, o módulo admin está salvando na collection errada!',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Busca detalhes da collection ead_push_notifications para debug
  Future<Map<String, dynamic>> _getEadPushNotificationsDetails(String userId) async {
    if (userId.isEmpty) {
      return {
        'total': 0,
        'byDestinatarioId': 0,
        'byDestinatarioTipo': 0,
        'byDestinatariosIds': 0,
        'byDestinatariosEmails': 0,
        'sample': null,
      };
    }

    try {
      final db = FirebaseFirestore.instance;

      // Buscar email do usuário
      String? userEmail;
      try {
        final userDoc = await db.collection('users').doc(userId).get();
        if (userDoc.exists) {
          userEmail = userDoc.data()?['email'] as String?;
        }
      } catch (e) {
        debugPrint('Erro ao buscar email: $e');
      }

      // 1. Contar total de documentos na collection
      final totalSnapshot = await db
          .collection('ead_push_notifications')
          .count()
          .get();
      final total = totalSnapshot.count ?? 0;

      // 2. Contar por destinatarioId
      final byIdSnapshot = await db
          .collection('ead_push_notifications')
          .where('destinatarioId', isEqualTo: userId)
          .count()
          .get();
      final byId = byIdSnapshot.count ?? 0;

      // 3. Contar por destinatarioTipo = 'Todos'
      final byTipoSnapshot = await db
          .collection('ead_push_notifications')
          .where('destinatarioTipo', isEqualTo: 'Todos')
          .count()
          .get();
      final byTipo = byTipoSnapshot.count ?? 0;

      // 4. Contar por destinatariosIds array (grupos por UID)
      int byIdsArray = 0;
      try {
        final byIdsArraySnapshot = await db
            .collection('ead_push_notifications')
            .where('destinatariosIds', arrayContains: userId)
            .count()
            .get();
        byIdsArray = byIdsArraySnapshot.count ?? 0;
      } catch (e) {
        debugPrint('Query destinatariosIds não disponível: $e');
      }

      // 5. Contar por destinatariosEmails array (grupos por email)
      int byEmailsArray = 0;
      if (userEmail != null && userEmail.isNotEmpty) {
        try {
          final byEmailsArraySnapshot = await db
              .collection('ead_push_notifications')
              .where('destinatariosEmails', arrayContains: userEmail)
              .count()
              .get();
          byEmailsArray = byEmailsArraySnapshot.count ?? 0;
        } catch (e) {
          debugPrint('Query destinatariosEmails não disponível: $e');
        }
      }

      // 6. Buscar um documento de exemplo (limite 1)
      Map<String, dynamic>? sampleDoc;
      final sampleSnapshot = await db
          .collection('ead_push_notifications')
          .limit(1)
          .get();

      if (sampleSnapshot.docs.isNotEmpty) {
        sampleDoc = sampleSnapshot.docs.first.data();
      }

      return {
        'total': total,
        'byDestinatarioId': byId,
        'byDestinatarioTipo': byTipo,
        'byDestinatariosIds': byIdsArray,
        'byDestinatariosEmails': byEmailsArray,
        'sample': sampleDoc,
      };
    } catch (e) {
      debugPrint('Erro ao buscar detalhes ead_push_notifications: $e');
      return {
        'total': 0,
        'byDestinatarioId': 0,
        'byDestinatarioTipo': 0,
        'byDestinatariosIds': 0,
        'byDestinatariosEmails': 0,
        'sample': null,
        'error': e.toString(),
      };
    }
  }
}

