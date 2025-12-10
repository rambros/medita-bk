import 'package:flutter/material.dart';

import 'package:medita_b_k/domain/models/ead/index.dart';
import 'package:medita_b_k/ui/core/theme/app_theme.dart';
import 'package:medita_b_k/ui/core/widgets/you_tube_player_widget.dart';
import 'package:medita_b_k/ui/core/widgets/audio_player_widget.dart';
import 'package:medita_b_k/ui/core/widgets/html_display_widget.dart';
import 'package:medita_b_k/ui/core/widgets/pdf_viewer_widget.dart';

/// Widget que renderiza o conteudo do topico baseado no tipo
class TopicoContentWidget extends StatelessWidget {
  const TopicoContentWidget({
    super.key,
    required this.topico,
    this.cursoTitulo,
    this.cursoImagem,
    this.onIniciarQuiz,
  });

  final TopicoModel topico;
  final String? cursoTitulo;
  final String? cursoImagem;
  final VoidCallback? onIniciarQuiz;

  @override
  Widget build(BuildContext context) {
    switch (topico.tipo) {
      case TipoConteudoTopico.video:
        return _buildVideoPlayer(context);
      case TipoConteudoTopico.audio:
        return _buildAudioPlayer(context);
      case TipoConteudoTopico.texto:
        return _buildTextoContent(context);
      case TipoConteudoTopico.quiz:
        return _buildQuizPlaceholder(context);
      case TipoConteudoTopico.pdf:
        return _buildPdfViewer(context);
    }
  }

  Widget _buildVideoPlayer(BuildContext context) {
    final url = topico.url;
    if (url == null || url.isEmpty) {
      return _buildConteudoIndisponivel(context, 'Video nao disponivel');
    }

    // Verifica se e YouTube
    if (topico.isYouTubeVideo) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: YouTubePlayerWidget(
              videoUrl: url,
              autoPlay: false,
              showControls: true,
            ),
          ),
          _buildDescricao(context),
        ],
      );
    }

    // Video direto (nao YouTube) - placeholder por enquanto
    return _buildConteudoIndisponivel(
      context,
      'Formato de video nao suportado',
    );
  }

  Widget _buildAudioPlayer(BuildContext context) {
    final url = topico.url;
    if (url == null || url.isEmpty) {
      return _buildConteudoIndisponivel(context, 'Audio nao disponivel');
    }

    // Layout minimalista: player centralizado com titulo integrado
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Player de audio com titulo integrado
        AudioPlayerWidget(
          audioUrl: url,
          audioTitle: topico.titulo,
          audioArt: cursoImagem ?? '',
          showTitle: true,
        ),
        _buildDescricao(context),
      ],
    );
  }

  Widget _buildTextoContent(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final html = topico.htmlContent;
    if (html == null || html.isEmpty) {
      return _buildConteudoIndisponivel(context, 'Conteudo nao disponivel');
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header com icone
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: appTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.article,
                  color: appTheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  topico.titulo,
                  style: appTheme.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: appTheme.primaryText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Conteudo HTML
          HtmlDisplayWidget(description: html),
        ],
      ),
    );
  }

  Widget _buildQuizPlaceholder(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz,
              size: 80,
              color: appTheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Este tópico contem uma avaliação',
              style: appTheme.titleLarge.copyWith(
                color: appTheme.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Teste seus conhecimentos respondendo as perguntas',
              textAlign: TextAlign.center,
              style: appTheme.bodyMedium.copyWith(
                color: appTheme.secondaryText,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onIniciarQuiz,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Iniciar Avaliação'),
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.primary,
                foregroundColor: appTheme.info,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfViewer(BuildContext context) {
    final url = topico.url;
    if (url == null || url.isEmpty) {
      return _buildConteudoIndisponivel(context, 'PDF não disponível');
    }

    return PdfViewerWidget(
      pdfUrl: url,
      title: topico.titulo,
      showDownloadButton: true,
    );
  }

  Widget _buildDescricao(BuildContext context) {
    final appTheme = AppTheme.of(context);

    if (topico.descricao == null || topico.descricao!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        topico.descricao!,
        style: appTheme.bodyMedium.copyWith(
          color: appTheme.secondaryText,
        ),
      ),
    );
  }

  Widget _buildConteudoIndisponivel(BuildContext context, String mensagem) {
    final appTheme = AppTheme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: appTheme.error.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: appTheme.titleMedium.copyWith(
                color: appTheme.primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
