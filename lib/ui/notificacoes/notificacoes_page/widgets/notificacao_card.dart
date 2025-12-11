import 'package:flutter/material.dart';

import 'package:medita_bk/domain/models/unified_notification.dart';
import 'package:medita_bk/ui/core/theme/app_theme.dart';

/// Card para exibir uma notificação UNIFICADA
/// Funciona com notificações de ambas as collections
class NotificacaoCard extends StatelessWidget {
  const NotificacaoCard({
    super.key,
    required this.notificacao,
    required this.onTap,
    this.onDismiss,
    this.onMarkAsRead,
    this.onDelete,
  });

  final UnifiedNotification notificacao;
  final VoidCallback onTap;
  final VoidCallback? onDismiss;
  final VoidCallback? onMarkAsRead;
  final VoidCallback? onDelete;

  void _showOptions(BuildContext context) {
    final appTheme = AppTheme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: appTheme.primaryBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: appTheme.lineColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Título da notificação
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                notificacao.titulo,
                style: appTheme.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: appTheme.primaryText,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                notificacao.conteudo,
                style: appTheme.bodySmall.copyWith(
                  color: appTheme.secondaryText,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 24),

            // Opções
            // Ver detalhes (sempre disponível)
            ListTile(
              leading: Icon(
                Icons.visibility_outlined,
                color: appTheme.primary,
              ),
              title: Text(
                'Ver detalhes',
                style: appTheme.bodyMedium.copyWith(
                  color: appTheme.primaryText,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                onTap();
              },
            ),

            // Marcar como lida (só para não lidas)
            if (!notificacao.lido && onMarkAsRead != null)
              ListTile(
                leading: Icon(
                  Icons.done,
                  color: appTheme.success,
                ),
                title: Text(
                  'Marcar como lida',
                  style: appTheme.bodyMedium.copyWith(
                    color: appTheme.primaryText,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onMarkAsRead?.call();
                },
              ),

            // Deletar (disponível para todas)
            if (onDelete != null)
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: appTheme.error,
                ),
                title: Text(
                  'Excluir notificação',
                  style: appTheme.bodyMedium.copyWith(
                    color: appTheme.error,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onDelete?.call();
                },
              ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    final card = InkWell(
      onTap: onTap,
      onLongPress: () => _showOptions(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notificacao.lido
              ? appTheme.primaryBackground
              : appTheme.primary.withOpacity(0.05),
          border: Border(
            bottom: BorderSide(
              color: appTheme.lineColor.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ícone do tipo de notificação
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: notificacao.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                notificacao.icon,
                color: notificacao.color,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),

            // Conteúdo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notificacao.titulo,
                          style: appTheme.bodyMedium.copyWith(
                            fontWeight: notificacao.lido
                                ? FontWeight.normal
                                : FontWeight.bold,
                            color: appTheme.primaryText,
                          ),
                        ),
                      ),
                      // Indicador de não lida
                      if (!notificacao.lido)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: appTheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Conteúdo
                  Text(
                    notificacao.conteudo,
                    style: appTheme.bodySmall.copyWith(
                      color: appTheme.secondaryText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Tempo desde + Badge de origem
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: appTheme.secondaryText,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        notificacao.tempoDesde,
                        style: appTheme.bodySmall.copyWith(
                          color: appTheme.secondaryText,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Badge mostrando origem
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: notificacao.source == NotificationSource.ead
                              ? Colors.purple.withOpacity(0.1)
                              : Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: notificacao.source == NotificationSource.ead
                                ? Colors.purple.withOpacity(0.3)
                                : Colors.blue.withOpacity(0.3),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          notificacao.sourceLabel,
                          style: appTheme.bodySmall.copyWith(
                            color: notificacao.source == NotificationSource.ead
                                ? Colors.purple
                                : Colors.blue,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Botão de mais opções
            IconButton(
              icon: Icon(
                Icons.more_vert,
                color: appTheme.secondaryText,
                size: 20,
              ),
              onPressed: () => _showOptions(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );

    // Se pode remover, adiciona Dismissible
    if (onDismiss != null) {
      return Dismissible(
        key: Key(notificacao.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16),
          color: appTheme.error,
          child: const Icon(
            Icons.delete_outline,
            color: Colors.white,
          ),
        ),
        onDismissed: (_) => onDismiss?.call(),
        child: card,
      );
    }

    return card;
  }
}

