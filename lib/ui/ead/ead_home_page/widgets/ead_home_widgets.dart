import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../domain/models/ead/index.dart';
import '../../../core/theme/app_theme.dart';

/// Card de destaque para curso
class CursoDestaqueCard extends StatelessWidget {
  const CursoDestaqueCard({
    super.key,
    required this.curso,
    this.onTap,
  });

  final CursoModel curso;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 280,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagem
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (curso.hasImagem)
                      CachedNetworkImage(
                        imageUrl: curso.imagemCapa!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => _buildPlaceholder(context),
                        errorWidget: (context, url, error) =>
                            _buildPlaceholder(context),
                      )
                    else
                      _buildPlaceholder(context),

                    // Gradiente
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Duracao
                    if (curso.duracaoEstimada != null)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 12,
                                color: appTheme.info,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                curso.duracaoEstimada!,
                                style: TextStyle(
                                  color: appTheme.info,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Conteudo
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tags
                    if (curso.tags.isNotEmpty) ...[
                      Wrap(
                        spacing: 4,
                        children: curso.tags.take(2).map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: appTheme.accent1,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 10,
                                color: appTheme.primaryText,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Titulo
                    Text(
                      curso.titulo,
                      style: appTheme.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: appTheme.primaryText,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Info
                    Row(
                      children: [
                        Icon(
                          Icons.play_lesson_outlined,
                          size: 14,
                          color: appTheme.secondaryText,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${curso.totalAulas} aulas',
                          style: appTheme.bodySmall,
                        ),
                        const Spacer(),
                        if (curso.autor != null)
                          Text(
                            curso.nomeAutor,
                            style: appTheme.bodySmall.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      color: appTheme.primary.withOpacity(0.1),
      child: Center(
        child: Icon(
          Icons.school,
          size: 48,
          color: appTheme.primary.withOpacity(0.5),
        ),
      ),
    );
  }
}

/// Card compacto para curso em andamento
class CursoEmAndamentoCard extends StatelessWidget {
  const CursoEmAndamentoCard({
    super.key,
    required this.inscricao,
    this.onTap,
    this.onContinuar,
  });

  final InscricaoCursoModel inscricao;
  final VoidCallback? onTap;
  final VoidCallback? onContinuar;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final progresso = inscricao.percentualConcluido;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Imagem
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 80,
                  height: 60,
                  child: inscricao.cursoImagem != null
                      ? CachedNetworkImage(
                          imageUrl: inscricao.cursoImagem!,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: appTheme.primary.withOpacity(0.1),
                          child: Icon(
                            Icons.school,
                            color: appTheme.primary.withOpacity(0.5),
                          ),
                        ),
                ),
              ),

              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inscricao.cursoTitulo,
                      style: appTheme.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: appTheme.primaryText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progresso / 100,
                              minHeight: 6,
                              backgroundColor: appTheme.accent4,
                              valueColor: AlwaysStoppedAnimation<Color>(appTheme.primary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${progresso.toStringAsFixed(0)}%',
                          style: appTheme.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Botao continuar
              IconButton(
                onPressed: onContinuar ?? onTap,
                icon: const Icon(Icons.play_circle_filled),
                color: appTheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Secao com titulo e acao
class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    super.key,
    required this.titulo,
    this.onVerTodos,
  });

  final String titulo;
  final VoidCallback? onVerTodos;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: appTheme.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: appTheme.primaryText,
            ),
          ),
          if (onVerTodos != null)
            TextButton(
              onPressed: onVerTodos,
              style: TextButton.styleFrom(foregroundColor: appTheme.primary),
              child: const Text('Ver todos'),
            ),
        ],
      ),
    );
  }
}

/// Banner de boas vindas
class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({
    super.key,
    this.nomeUsuario,
    this.cursosEmAndamento = 0,
    this.cursosConcluidos = 0,
  });

  final String? nomeUsuario;
  final int cursosEmAndamento;
  final int cursosConcluidos;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            appTheme.primary,
            appTheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school, color: appTheme.info, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nomeUsuario != null ? 'Ola, $nomeUsuario!' : 'Ola!',
                      style: appTheme.titleLarge.copyWith(
                        color: appTheme.info,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Continue aprendendo',
                      style: appTheme.bodyMedium.copyWith(
                        color: appTheme.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (cursosEmAndamento > 0 || cursosConcluidos > 0) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                _StatChip(
                  icon: Icons.play_circle_outline,
                  label: '$cursosEmAndamento em andamento',
                ),
                const SizedBox(width: 12),
                _StatChip(
                  icon: Icons.check_circle_outline,
                  label: '$cursosConcluidos concluidos',
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: appTheme.info.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: appTheme.info),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: appTheme.info,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
