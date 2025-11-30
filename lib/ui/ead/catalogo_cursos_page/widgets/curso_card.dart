import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../domain/models/ead/index.dart';

/// Card para exibição de um curso na lista
class CursoCard extends StatelessWidget {
  const CursoCard({
    super.key,
    required this.curso,
    this.inscricao,
    this.onTap,
  });

  final CursoModel curso;
  final InscricaoCursoModel? inscricao;
  final VoidCallback? onTap;

  bool get isInscrito => inscricao != null && inscricao!.isAtivo;
  double get progresso => inscricao?.percentualConcluido ?? 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do curso
            _buildImagem(context),

            // Conteúdo
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags
                  if (curso.tags.isNotEmpty) ...[
                    _buildTags(context),
                    const SizedBox(height: 8),
                  ],

                  // Título
                  Text(
                    curso.titulo,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Descrição curta
                  if (curso.descricaoCurta.isNotEmpty)
                    Text(
                      curso.descricaoCurta,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                  const SizedBox(height: 12),

                  // Info do curso
                  _buildInfo(context),

                  // Barra de progresso (se inscrito)
                  if (isInscrito) ...[
                    const SizedBox(height: 12),
                    _buildProgresso(context),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagem(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Imagem
          if (curso.hasImagem)
            CachedNetworkImage(
              imageUrl: curso.imagemCapa!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) => _buildPlaceholder(context),
            )
          else
            _buildPlaceholder(context),

          // Badge de status (inscrito/concluído)
          if (isInscrito)
            Positioned(
              top: 8,
              right: 8,
              child: _buildStatusBadge(context),
            ),

          // Duração estimada
          if (curso.duracaoEstimada != null)
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.schedule, size: 14, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      curso.duracaoEstimada!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
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
        child: Text(
          curso.iniciais,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final status = inscricao!.status;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: curso.tags.take(3).map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            tag,
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInfo(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // Autor
        if (curso.autor != null) ...[
          CircleAvatar(
            radius: 12,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            backgroundImage: curso.autor?.imagemUrl != null
                ? CachedNetworkImageProvider(curso.autor!.imagemUrl!)
                : null,
            child: curso.autor?.imagemUrl == null
                ? Text(
                    curso.autor!.iniciais,
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.colorScheme.primary,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              curso.nomeAutor,
              style: theme.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],

        // Aulas
        const Spacer(),
        Icon(
          Icons.play_lesson_outlined,
          size: 16,
          color: theme.textTheme.bodySmall?.color,
        ),
        const SizedBox(width: 4),
        Text(
          '${curso.totalAulas} aulas',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildProgresso(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progresso',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '${progresso.toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progresso / 100,
            minHeight: 6,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        ),
      ],
    );
  }
}
