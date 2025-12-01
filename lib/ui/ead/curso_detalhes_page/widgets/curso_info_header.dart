import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../domain/models/ead/index.dart';

/// Header com informações do curso
class CursoInfoHeader extends StatelessWidget {
  const CursoInfoHeader({
    super.key,
    required this.curso,
    this.inscricao,
  });

  final CursoModel curso;
  final InscricaoCursoModel? inscricao;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Imagem de capa
        _buildImagemCapa(context),

        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tags
              if (curso.tags.isNotEmpty) ...[
                _buildTags(context),
                const SizedBox(height: 12),
              ],

              // Título
              Text(
                curso.titulo,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // Descrição curta
              if (curso.descricaoCurta.isNotEmpty)
                Text(
                  curso.descricaoCurta,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),

              const SizedBox(height: 16),

              // Métricas
              _buildMetricas(context),

              // Autor
              if (curso.autor != null) ...[
                const SizedBox(height: 16),
                _buildAutor(context),
              ],

              // Progresso (se inscrito)
              if (inscricao != null && inscricao!.isAtivo) ...[
                const SizedBox(height: 16),
                _buildProgresso(context),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImagemCapa(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (curso.hasImagem)
            CachedNetworkImage(
              imageUrl: curso.imagemCapa!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => _buildPlaceholder(context),
            )
          else
            _buildPlaceholder(context),

          // Botão de play (se tiver vídeo preview)
          if (curso.hasVideoPreview)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: Center(
        child: Icon(
          Icons.school,
          size: 64,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: curso.tags.map((tag) {
        return Chip(
          label: Text(tag),
          labelStyle: const TextStyle(fontSize: 12),
          padding: EdgeInsets.zero,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      }).toList(),
    );
  }

  Widget _buildMetricas(BuildContext context) {
    return Row(
      children: [
        _MetricaItem(
          icon: Icons.play_lesson_outlined,
          label: '${curso.totalAulas} aulas',
        ),
        const SizedBox(width: 24),
        _MetricaItem(
          icon: Icons.article_outlined,
          label: '${curso.totalTopicos} tópicos',
        ),
        if (curso.duracaoEstimada != null) ...[
          const SizedBox(width: 24),
          _MetricaItem(
            icon: Icons.schedule,
            label: curso.duracaoEstimada!,
          ),
        ],
      ],
    );
  }

  Widget _buildAutor(BuildContext context) {
    final autor = curso.autor!;
    final theme = Theme.of(context);

    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
          backgroundImage: autor.imagemUrl != null ? CachedNetworkImageProvider(autor.imagemUrl!) : null,
          child: autor.imagemUrl == null
              ? Text(
                  autor.iniciais,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Instrutor',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
              ),
            ),
            Text(
              autor.nome,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgresso(BuildContext context) {
    final progresso = inscricao!.percentualConcluido;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    inscricao!.status.icon,
                    size: 20,
                    color: inscricao!.status.color,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    inscricao!.status.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: inscricao!.status.color,
                    ),
                  ),
                ],
              ),
              Text(
                '${progresso.toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progresso / 100,
              minHeight: 8,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricaItem extends StatelessWidget {
  const _MetricaItem({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 18,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
