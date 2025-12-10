import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:medita_b_k/domain/models/ead/index.dart';
import 'package:medita_b_k/ui/core/theme/app_theme.dart';

/// Header com informações do curso
class CursoInfoHeader extends StatelessWidget {
  const CursoInfoHeader({
    super.key,
    required this.curso,
    this.inscricao,
    this.totalTopicosCalculado,
  });

  final CursoModel curso;
  final InscricaoCursoModel? inscricao;

  /// Total de tópicos calculado dinamicamente das aulas carregadas
  /// Se não for fornecido, usa o valor do modelo do curso
  final int? totalTopicosCalculado;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

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
                style: appTheme.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: appTheme.primaryText,
                ),
              ),

              const SizedBox(height: 8),

              // Descrição curta
              if (curso.descricaoCurta.isNotEmpty)
                Text(
                  curso.descricaoCurta,
                  style: appTheme.bodyMedium.copyWith(
                    color: appTheme.secondaryText,
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
    final appTheme = AppTheme.of(context);

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
                color: appTheme.accent4,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(appTheme.primary),
                  ),
                ),
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
                child: Icon(
                  Icons.play_arrow,
                  size: 48,
                  color: appTheme.info,
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
        child: Icon(
          Icons.school,
          size: 64,
          color: appTheme.primary.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildTags(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: curso.tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: appTheme.accent1,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            tag,
            style: TextStyle(
              fontSize: 12,
              color: appTheme.primaryText,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMetricas(BuildContext context) {
    final appTheme = AppTheme.of(context);
    // Usa o total calculado das aulas carregadas, ou fallback para o valor do modelo
    final totalTopicos = totalTopicosCalculado ?? curso.totalTopicos;

    return Row(
      children: [
        _MetricaItem(
          icon: Icons.play_lesson_outlined,
          label: '${curso.totalAulas} aulas',
          iconColor: appTheme.primary,
          textColor: appTheme.primaryText,
        ),
        const SizedBox(width: 24),
        _MetricaItem(
          icon: Icons.article_outlined,
          label: '$totalTopicos tópicos',
          iconColor: appTheme.primary,
          textColor: appTheme.primaryText,
        ),
        if (curso.duracaoEstimada != null) ...[
          const SizedBox(width: 24),
          _MetricaItem(
            icon: Icons.schedule,
            label: curso.duracaoEstimada!,
            iconColor: appTheme.primary,
            textColor: appTheme.primaryText,
          ),
        ],
      ],
    );
  }

  Widget _buildAutor(BuildContext context) {
    final autor = curso.autor!;
    final appTheme = AppTheme.of(context);

    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: appTheme.primary.withOpacity(0.1),
          backgroundImage: autor.imagemUrl != null ? CachedNetworkImageProvider(autor.imagemUrl!) : null,
          child: autor.imagemUrl == null
              ? Text(
                  autor.iniciais,
                  style: TextStyle(
                    color: appTheme.primary,
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
              style: appTheme.bodySmall.copyWith(
                color: appTheme.secondaryText,
              ),
            ),
            Text(
              autor.nome,
              style: appTheme.titleSmall.copyWith(
                fontWeight: FontWeight.w500,
                color: appTheme.primaryText,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgresso(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final progresso = inscricao!.percentualConcluido;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appTheme.primary.withOpacity(0.1),
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
                    color: appTheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    inscricao!.status.label,
                    style: appTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: appTheme.primary,
                    ),
                  ),
                ],
              ),
              Text(
                '${progresso.toStringAsFixed(0)}%',
                style: appTheme.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: appTheme.primaryText,
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
              backgroundColor: appTheme.accent4,
              valueColor: AlwaysStoppedAnimation<Color>(appTheme.primary),
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
    required this.iconColor,
    required this.textColor,
  });

  final IconData icon;
  final String label;
  final Color iconColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 18,
          color: iconColor,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: appTheme.bodyMedium.copyWith(
            color: textColor,
          ),
        ),
      ],
    );
  }
}
