import 'package:flutter/material.dart';

import 'package:medita_bk/domain/models/ead/index.dart';
import 'package:medita_bk/ui/core/theme/app_theme.dart';

/// Header com informacoes do topico atual
class TopicoHeaderWidget extends StatelessWidget {
  const TopicoHeaderWidget({
    super.key,
    required this.tituloAula,
    required this.tituloTopico,
    required this.tipo,
    this.isCompleto = false,
    this.textoProgresso,
    this.onBack,
    this.onDiscussoes,
  });

  final String tituloAula;
  final String tituloTopico;
  final TipoConteudoTopico tipo;
  final bool isCompleto;
  final String? textoProgresso;
  final VoidCallback? onBack;
  final VoidCallback? onDiscussoes;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appTheme.secondaryBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Linha superior: voltar | título | espaço | discussões | progresso
            Row(
              children: [
                if (onBack != null)
                  IconButton(
                    onPressed: onBack,
                    icon: Icon(
                      Icons.arrow_back,
                      color: appTheme.primary,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                if (onBack != null) const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tituloAula,
                    style: appTheme.bodySmall.copyWith(
                      color: appTheme.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onDiscussoes != null) ...[
                  IconButton(
                    onPressed: onDiscussoes,
                    icon: Icon(
                      Icons.forum_outlined,
                      color: appTheme.primary,
                    ),
                    tooltip: 'Discussões',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                ],
                if (textoProgresso != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: appTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      textoProgresso!,
                      style: appTheme.bodyMedium.copyWith(
                        color: appTheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // Titulo do topico
            Row(
              children: [
                // Icone do tipo
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: appTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isCompleto ? Icons.check_circle : tipo.icon,
                    size: 20,
                    color: appTheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tituloTopico,
                        style: appTheme.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: appTheme.primaryText,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: appTheme.accent4,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tipo.label,
                              style: appTheme.bodySmall.copyWith(
                                fontSize: 10,
                                color: appTheme.secondaryText,
                              ),
                            ),
                          ),
                          if (isCompleto) ...[
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 14,
                                  color: appTheme.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Concluido',
                                  style: appTheme.bodySmall.copyWith(
                                    color: appTheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
