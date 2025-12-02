import 'package:flutter/material.dart';

import '../../../../domain/models/ead/index.dart';
import '../../../core/theme/app_theme.dart';

/// Widget que exibe o currículo do curso (aulas e tópicos)
class CurriculoSection extends StatelessWidget {
  const CurriculoSection({
    super.key,
    required this.aulas,
    required this.aulasExpandidas,
    required this.onToggleAula,
    required this.onTopicoTap,
    this.isTopicoCompleto,
    this.isAulaCompleta,
    this.isInscrito = false,
  });

  final List<AulaModel> aulas;
  final Set<String> aulasExpandidas;
  final Function(String aulaId) onToggleAula;
  final Function(AulaModel aula, TopicoModel topico) onTopicoTap;
  final bool Function(String topicoId)? isTopicoCompleto;
  final bool Function(String aulaId)? isAulaCompleta;
  final bool isInscrito;

  @override
  Widget build(BuildContext context) {
    if (aulas.isEmpty) {
      return _buildEmpty(context);
    }

    final appTheme = AppTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Conteúdo do Curso',
                style: appTheme.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: appTheme.primaryText,
                ),
              ),
              Text(
                '${aulas.length} ${aulas.length == 1 ? 'aula' : 'aulas'}',
                style: appTheme.bodySmall.copyWith(
                  color: appTheme.secondaryText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Lista de aulas
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: aulas.length,
          itemBuilder: (context, index) {
            final aula = aulas[index];
            final isExpandida = aulasExpandidas.contains(aula.id);
            final aulaCompleta = isAulaCompleta?.call(aula.id) ?? false;

            return _AulaTile(
              aula: aula,
              index: index + 1,
              isExpandida: isExpandida,
              isCompleta: aulaCompleta,
              isInscrito: isInscrito,
              onToggle: () => onToggleAula(aula.id),
              onTopicoTap: (topico) => onTopicoTap(aula, topico),
              isTopicoCompleto: isTopicoCompleto,
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.folder_open,
              size: 48,
              color: appTheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Conteúdo em breve',
              style: appTheme.titleMedium.copyWith(
                color: appTheme.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'O conteúdo deste curso ainda está sendo preparado.',
              textAlign: TextAlign.center,
              style: appTheme.bodySmall.copyWith(
                color: appTheme.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tile de uma aula
class _AulaTile extends StatelessWidget {
  const _AulaTile({
    required this.aula,
    required this.index,
    required this.isExpandida,
    required this.isCompleta,
    required this.isInscrito,
    required this.onToggle,
    required this.onTopicoTap,
    this.isTopicoCompleto,
  });

  final AulaModel aula;
  final int index;
  final bool isExpandida;
  final bool isCompleta;
  final bool isInscrito;
  final VoidCallback onToggle;
  final Function(TopicoModel topico) onTopicoTap;
  final bool Function(String topicoId)? isTopicoCompleto;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          // Header da aula
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Indicador de status
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isCompleta
                          ? appTheme.primary
                          : appTheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isCompleta
                          ? Icon(Icons.check, size: 18, color: appTheme.info)
                          : Text(
                              '$index',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: appTheme.primary,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Título e info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          aula.titulo,
                          style: appTheme.titleSmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: appTheme.primaryText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.article_outlined,
                              size: 14,
                              color: appTheme.secondaryText,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${aula.numeroTopicos} ${aula.numeroTopicos == 1 ? 'tópico' : 'tópicos'}',
                              style: appTheme.bodySmall.copyWith(
                                color: appTheme.secondaryText,
                              ),
                            ),
                            if (aula.duracaoEstimada != null) ...[
                              const SizedBox(width: 12),
                              Icon(
                                Icons.schedule,
                                size: 14,
                                color: appTheme.secondaryText,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                aula.duracaoEstimada!,
                                style: appTheme.bodySmall.copyWith(
                                  color: appTheme.secondaryText,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Ícone de expandir
                  AnimatedRotation(
                    turns: isExpandida ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: appTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Lista de tópicos (quando expandida)
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildTopicos(context),
            crossFadeState:
                isExpandida ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicos(BuildContext context) {
    final appTheme = AppTheme.of(context);

    if (aula.topicos.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Nenhum tópico disponível',
          style: appTheme.bodySmall.copyWith(
            color: appTheme.secondaryText,
          ),
        ),
      );
    }

    return Column(
      children: [
        const Divider(height: 1),
        ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: aula.topicos.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final topico = aula.topicos[index];
            final completo = isTopicoCompleto?.call(topico.id) ?? false;

            return _TopicoTile(
              topico: topico,
              index: index + 1,
              isCompleto: completo,
              isInscrito: isInscrito,
              onTap: () => onTopicoTap(topico),
            );
          },
        ),
      ],
    );
  }
}

/// Tile de um tópico
class _TopicoTile extends StatelessWidget {
  const _TopicoTile({
    required this.topico,
    required this.index,
    required this.isCompleto,
    required this.isInscrito,
    required this.onTap,
  });

  final TopicoModel topico;
  final int index;
  final bool isCompleto;
  final bool isInscrito;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final canAccess = isInscrito;

    return InkWell(
      onTap: canAccess ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: isCompleto ? appTheme.primary.withOpacity(0.05) : null,
        child: Row(
          children: [
            // Ícone do tipo de conteúdo
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isCompleto
                    ? appTheme.primary
                    : appTheme.accent4,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isCompleto ? Icons.check : topico.tipo.icon,
                size: 20,
                color: isCompleto ? appTheme.info : appTheme.primary,
              ),
            ),

            const SizedBox(width: 12),

            // Título e duração
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topico.titulo,
                    style: appTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: canAccess
                          ? (isCompleto ? appTheme.secondaryText : appTheme.primaryText)
                          : appTheme.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (isCompleto) ...[
                        Icon(
                          Icons.check_circle,
                          size: 12,
                          color: appTheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Concluído',
                          style: appTheme.bodySmall.copyWith(
                            color: appTheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (topico.duracaoFormatada.isNotEmpty) ...[
                          Text(
                            ' • ',
                            style: appTheme.bodySmall.copyWith(
                              color: appTheme.secondaryText.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ],
                      if (topico.duracaoFormatada.isNotEmpty)
                        Text(
                          topico.duracaoFormatada,
                          style: appTheme.bodySmall.copyWith(
                            color: appTheme.secondaryText.withOpacity(0.6),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Badge do tipo
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isCompleto
                    ? appTheme.primary.withOpacity(0.1)
                    : appTheme.accent4,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                topico.tipo.label,
                style: appTheme.bodySmall.copyWith(
                  fontSize: 10,
                  color: isCompleto ? appTheme.primary : appTheme.secondaryText,
                ),
              ),
            ),

            // Ícone de lock (se não inscrito)
            if (!canAccess) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.lock_outline,
                size: 18,
                color: appTheme.secondaryText,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
