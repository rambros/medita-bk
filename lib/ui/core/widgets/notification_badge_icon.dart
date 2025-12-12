import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:medita_bk/data/repositories/notificacoes_repository.dart';

/// Widget que exibe um ícone de notificações com badge contador
/// Mostra o número de notificações não lidas
class NotificationBadgeIcon extends StatelessWidget {
  const NotificationBadgeIcon({
    super.key,
    required this.onPressed,
    this.iconSize = 24.0,
    this.iconColor,
    this.badgeColor,
  });

  final VoidCallback onPressed;
  final double iconSize;
  final Color? iconColor;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    // Cria o repository uma única vez
    final repository = Provider.of<NotificacoesRepository>(
      context,
      listen: false,
    );

    return StreamBuilder<int>(
      // Stream otimizado que retorna diretamente o contador de não lidas
      stream: repository.streamContadorNaoLidas(),
      builder: (context, snapshot) {
        final totalNaoLidas = snapshot.data ?? 0;
        final hasNotifications = totalNaoLidas > 0;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Ícone de notificações com área clicável aumentada
            IconButton(
              onPressed: onPressed,
              icon: Icon(
                Icons.notifications_none,
                size: iconSize,
                color: iconColor,
              ),
              // Aumenta a área clicável
              padding: const EdgeInsets.all(12),
              constraints: const BoxConstraints(
                minWidth: 48,
                minHeight: 48,
              ),
              splashRadius: 24,
              tooltip: 'Notificações',
            ),

            // Badge com contador
            if (hasNotifications)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: badgeColor ?? Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: 1.5,
                    ),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    totalNaoLidas > 99 ? '99+' : '$totalNaoLidas',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

