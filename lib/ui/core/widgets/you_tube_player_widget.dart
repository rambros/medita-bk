// Automatic FlutterFlow imports
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YouTubePlayerWidget extends StatefulWidget {
  const YouTubePlayerWidget({
    super.key,
    this.width,
    this.height,
    required this.videoUrl,
    this.autoPlay = false,
    this.showControls = true,
  });

  final double? width;
  final double? height;
  final String videoUrl;
  final bool? autoPlay;
  final bool? showControls;

  @override
  State<YouTubePlayerWidget> createState() => _YouTubePlayerWidgetState();
}

class _YouTubePlayerWidgetState extends State<YouTubePlayerWidget> {
  late final WebViewController _controller;
  String? _videoId;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    // Extract video ID from URL
    _videoId = _extractVideoId(widget.videoUrl);

    if (_videoId == null || _videoId!.isEmpty) {
      setState(() {
        _errorMessage = 'URL de vídeo inválida';
      });
      return;
    }

    // Create HTML with YouTube iframe
    final html = _createYouTubeHtml(_videoId!);

    // Initialize WebView controller
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (error) {
            debugPrint('WebView error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            // Permite navegação para YouTube
            if (request.url.contains('youtube.com') ||
                request.url.contains('youtube-nocookie.com') ||
                request.url.contains('googlevideo.com')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadHtmlString(html, baseUrl: 'https://www.youtube-nocookie.com');
  }

  /// Cria o HTML com iframe do YouTube
  String _createYouTubeHtml(String videoId) {
    final autoplayParam = widget.autoPlay == true ? '1' : '0';
    final controlsParam = widget.showControls == true ? '1' : '0';

    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta http-equiv="Content-Security-Policy" content="default-src * 'unsafe-inline' 'unsafe-eval'; script-src * 'unsafe-inline' 'unsafe-eval'; connect-src * 'unsafe-inline'; img-src * data: blob: 'unsafe-inline'; frame-src *; style-src * 'unsafe-inline';">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        html, body {
            height: 100%;
            width: 100%;
            background-color: #000;
            overflow: hidden;
        }
        #player-container {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }
        iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border: 0;
        }
    </style>
</head>
<body>
    <div id="player-container">
        <iframe
            src="https://www.youtube-nocookie.com/embed/$videoId?autoplay=$autoplayParam&mute=$autoplayParam&controls=$controlsParam&playsinline=1&rel=0&modestbranding=1&iv_load_policy=3&fs=1&enablejsapi=1&origin=https://www.youtube-nocookie.com&widget_referrer=https://www.youtube-nocookie.com"
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share; fullscreen"
            allowfullscreen
            webkitallowfullscreen
            mozallowfullscreen
            frameborder="0"
            style="pointer-events: auto;">
        </iframe>
    </div>
</body>
</html>
''';
  }

  /// Extrai o ID do vídeo da URL do YouTube
  String? _extractVideoId(String url) {
    // Suporta formatos:
    // - https://www.youtube.com/watch?v=VIDEO_ID
    // - https://youtu.be/VIDEO_ID
    // - https://www.youtube.com/embed/VIDEO_ID

    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    // Formato: youtube.com/watch?v=VIDEO_ID
    if (uri.host.contains('youtube.com') && uri.pathSegments.contains('watch')) {
      return uri.queryParameters['v'];
    }

    // Formato: youtu.be/VIDEO_ID
    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
    }

    // Formato: youtube.com/embed/VIDEO_ID
    if (uri.host.contains('youtube.com') && uri.pathSegments.contains('embed')) {
      final embedIndex = uri.pathSegments.indexOf('embed');
      if (embedIndex + 1 < uri.pathSegments.length) {
        return uri.pathSegments[embedIndex + 1];
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.black,
        child: Center(
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    if (_videoId == null) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: WebViewWidget(controller: _controller),
    );
  }
}
