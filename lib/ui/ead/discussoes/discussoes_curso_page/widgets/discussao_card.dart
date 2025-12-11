import 'package:flutter/material.dart';

import 'package:medita_bk/domain/models/ead/index.dart';
import 'package:medita_bk/ui/core/theme/app_theme.dart';

/// Card de discussão para a lista
class DiscussaoCard extends StatelessWidget {
  final DiscussaoModel discussao;
  final String usuarioId;
  final VoidCallback onTap;

  const DiscussaoCard({
    super.key,
    required this.discussao,
    required this.usuarioId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMinhaDiscussao = discussao.isMinhaDiscussao(usuarioId);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: discussao.isDestaque ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: discussao.isDestaque
            ? BorderSide(color: Colors.amber.shade400, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badges superiores
              _buildBadges(context),

              const SizedBox(height: 8),

              // Título
              Text(
                discussao.titulo,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 6),

              // Prévia do conteúdo
              Text(
                discussao.conteudo,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Tags (se houver)
              if (discussao.tags.isNotEmpty) ...[
                _buildTags(context),
                const SizedBox(height: 12),
              ],

              // Footer com info do autor e estatísticas
              _buildFooter(context, isMinhaDiscussao),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadges(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        // Status
        _StatusBadge(status: discussao.status),

        // Pinado
        if (discussao.isPinned)
          _IconBadge(
            icon: Icons.push_pin,
            color: appTheme.primary,
            tooltip: 'Fixada',
          ),

        // Destaque
        if (discussao.isDestaque)
          _IconBadge(
            icon: Icons.star,
            color: Colors.amber,
            tooltip: 'Destaque',
          ),

        // Privada
        if (discussao.isPrivada)
          _IconBadge(
            icon: Icons.lock,
            color: Colors.grey,
            tooltip: 'Privada',
          ),
      ],
    );
  }

  Widget _buildTags(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: discussao.tags.take(3).map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            tag,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter(BuildContext context, bool isMinhaDiscussao) {
    final appTheme = AppTheme.of(context);

    return Row(
      children: [
        // Avatar do autor
        CircleAvatar(
          radius: 14,
          backgroundColor: discussao.autorTipo.color.withOpacity(0.2),
          backgroundImage: discussao.autorFoto != null
              ? NetworkImage(discussao.autorFoto!)
              : null,
          child: discussao.autorFoto == null
              ? Icon(
                  discussao.autorTipo.icon,
                  size: 16,
                  color: discussao.autorTipo.color,
                )
              : null,
        ),

        const SizedBox(width: 8),

        // Nome do autor
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      isMinhaDiscussao ? 'Você' : discussao.autorNome,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (discussao.autorTipo == TipoAutor.professor) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.verified,
                      size: 14,
                      color: appTheme.primary,
                    ),
                  ],
                ],
              ),
              Text(
                discussao.tempoDesde,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),

        // Estatísticas
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Respostas
            _StatItem(
              icon: Icons.chat_bubble_outline,
              value: discussao.totalRespostas.toString(),
              color: discussao.temRespostas ? appTheme.primary : Colors.grey,
            ),
          ],
        ),
      ],
    );
  }
}

/// Badge de status
class _StatusBadge extends StatelessWidget {
  final StatusDiscussao status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: status.color.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status.icon,
            size: 14,
            color: status.color,
          ),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 11,
              color: status.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge com ícone
class _IconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;

  const _IconBadge({
    required this.icon,
    required this.color,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 14,
          color: color,
        ),
      ),
    );
  }
}

/// Item de estatística
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
