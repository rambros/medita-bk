import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:medita_bk/domain/models/ead/index.dart';
import 'package:medita_bk/ui/core/theme/app_theme.dart';

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

  bool get isInscrito => inscricao != null && (inscricao!.isAtivo || inscricao!.isConcluido);
  double get progresso => inscricao?.percentualConcluido ?? 0;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

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
                    style: appTheme.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: appTheme.primaryText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Descrição curta
                  if (curso.descricaoCurta.isNotEmpty)
                    Text(
                      curso.descricaoCurta,
                      style: appTheme.bodySmall.copyWith(
                        color: appTheme.secondaryText,
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
    final appTheme = AppTheme.of(context);

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
                color: appTheme.accent4,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(appTheme.primary),
                  ),
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
                    Icon(Icons.schedule, size: 14, color: appTheme.info),
                    const SizedBox(width: 4),
                    Text(
                      curso.duracaoEstimada!,
                      style: TextStyle(
                        color: appTheme.info,
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
    final appTheme = AppTheme.of(context);
    return Container(
      color: appTheme.primary.withOpacity(0.1),
      child: Center(
        child: Text(
          curso.iniciais,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: appTheme.primary.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final appTheme = AppTheme.of(context);
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
          Icon(status.icon, size: 14, color: appTheme.info),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              color: appTheme.info,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: curso.tags.take(3).map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: appTheme.accent1,
            borderRadius: BorderRadius.circular(12),
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
    );
  }

  Widget _buildInfo(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Row(
      children: [
        // Autor
        if (curso.autor != null) ...[
          CircleAvatar(
            radius: 12,
            backgroundColor: appTheme.primary.withOpacity(0.1),
            backgroundImage:
                curso.autor?.imagemUrl != null ? CachedNetworkImageProvider(curso.autor!.imagemUrl!) : null,
            child: curso.autor?.imagemUrl == null
                ? Text(
                    curso.autor!.iniciais,
                    style: TextStyle(
                      fontSize: 10,
                      color: appTheme.primary,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              curso.nomeAutor,
              style: appTheme.bodySmall,
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
          color: appTheme.secondaryText,
        ),
        const SizedBox(width: 4),
        Text(
          '${curso.totalAulas} aulas',
          style: appTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildProgresso(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progresso',
              style: appTheme.bodySmall,
            ),
            Text(
              '${progresso.toStringAsFixed(0)}%',
              style: appTheme.bodySmall.copyWith(
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
            backgroundColor: appTheme.accent4,
            valueColor: AlwaysStoppedAnimation<Color>(appTheme.primary),
          ),
        ),
      ],
    );
  }
}
