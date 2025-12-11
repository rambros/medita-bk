import 'package:flutter/material.dart';

import 'package:medita_bk/ui/core/theme/app_theme.dart';

/// Widget para exibir quando não há notificações
class NotificacoesEmptyState extends StatelessWidget {
  const NotificacoesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícone
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: appTheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none,
                size: 60,
                color: appTheme.primary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),

            // Título
            Text(
              'Nenhuma notificação',
              style: appTheme.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: appTheme.primaryText,
              ),
            ),
            const SizedBox(height: 8),

            // Descrição
            Text(
              'Você não tem notificações no momento.\nQuando houver novidades, você verá aqui.',
              textAlign: TextAlign.center,
              style: appTheme.bodyMedium.copyWith(
                color: appTheme.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

