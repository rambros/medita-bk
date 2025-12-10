import 'package:flutter/material.dart';

import 'package:medita_b_k/data/services/auth/firebase_auth/auth_util.dart';
import 'package:medita_b_k/data/repositories/notificacoes_repository.dart';
import 'package:medita_b_k/data/services/unified_notifications_service.dart';

/// Widget de debug para verificar informações de notificações
/// Útil para diagnosticar problemas
/// Mostra informações de AMBAS as collections
class NotificacoesDebugInfo extends StatelessWidget {
  const NotificacoesDebugInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = NotificacoesRepository();
    final unifiedService = UnifiedNotificationsService();
    final userId = currentUserUid;

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
            Text('Autenticado: ${userId.isNotEmpty ? "✅ Sim" : "❌ Não"}'),
            
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            
            // Collection: notificacoes_ead
            const Text(
              '📊 Collection: notificacoes_ead (Novo Sistema)',
              style: TextStyle(fontWeight: FontWeight.bold),
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
            
            // Collection: notifications (OLD)
            const Text(
              '📊 Collection: notifications (Sistema Antigo)',
              style: TextStyle(fontWeight: FontWeight.bold),
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
                    'Se "notifications" tem itens mas "notificacoes_ead" está vazio, o módulo admin está salvando na collection errada!',
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
}

