import 'package:flutter/material.dart';

import '../../../../domain/models/ead/index.dart';
import '../../../core/widgets/you_tube_player_widget.dart';
import '../../../core/widgets/audio_player_widget.dart';
import '../../../core/widgets/html_display_widget.dart';

/// Widget que renderiza o conteudo do topico baseado no tipo
class TopicoContentWidget extends StatelessWidget {
  const TopicoContentWidget({
    super.key,
    required this.topico,
    this.cursoTitulo,
    this.cursoImagem,
  });

  final TopicoModel topico;
  final String? cursoTitulo;
  final String? cursoImagem;

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Capa do audio
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                ],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Icone de audio
                Icon(
                  Icons.headphones,
                  size: 80,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                // Titulo
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Text(
                    topico.titulo,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Player de audio
        Padding(
          padding: const EdgeInsets.all(16),
          child: AudioPlayerWidget(
            audioUrl: url,
            audioTitle: topico.titulo,
            audioArt: cursoImagem ?? '',
          ),
        ),
        _buildDescricao(context),
      ],
    );
  }

  Widget _buildTextoContent(BuildContext context) {
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
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.article,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  topico.titulo,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Este topico contem um quiz',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Teste seus conhecimentos respondendo as perguntas',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Navegar para quiz
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Iniciar Quiz'),
              style: ElevatedButton.styleFrom(
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

  Widget _buildDescricao(BuildContext context) {
    if (topico.descricao == null || topico.descricao!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sobre este topico',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            topico.descricao!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildConteudoIndisponivel(BuildContext context, String mensagem) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
