import 'package:flutter/material.dart';

import 'package:medita_bk/data/services/auth/firebase_auth/auth_util.dart';
import 'package:medita_bk/data/repositories/notificacoes_repository.dart';

/// Widget de debug para verificar informações de notificações
/// Útil para diagnosticar problemas
/// Mostra informações da collection: notifications
class NotificacoesDebugInfo extends StatelessWidget {
  const NotificacoesDebugInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = NotificacoesRepository();
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
            Text('User ID: $userId',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Email: $userEmail',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Autenticado: ${userId.isNotEmpty ? "✅ Sim" : "❌ Não"}'),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // Collection: notifications (nova)
            const Text(
              '📊 Collection: notifications',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              '(Sistema Unificado de Notificações)',
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
                final naoLidas = notificacoes.where((n) => !n.lido).length;
                final lidas = notificacoes.where((n) => n.lido).length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total: ${notificacoes.length} notificações'),
                    Text('  • Não lidas: $naoLidas'),
                    Text('  • Lidas: $lidas'),
                    if (notificacoes.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text('✅ Última: "${notificacoes.first.titulo}"'),
                      Text('   Tipo: ${notificacoes.first.tipo.label}'),
                      Text('   Categoria: ${notificacoes.first.tipo.categoria}'),
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

            // Contador
            const Text(
              '🔢 Contador de Não Lidas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            FutureBuilder(
              future: repository.contarNaoLidas(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final contador = snapshot.data!;
                  return Text('Total não lidas: $contador');
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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 INFORMAÇÃO',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Sistema simplificado usando apenas a collection "notifications".\n'
                    'Tipos de notificação: tickets, discussões, cursos e sistema.\n'
                    'Destinatários: userId ou "TODOS".',
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
