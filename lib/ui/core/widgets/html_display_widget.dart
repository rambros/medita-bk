// Automatic FlutterFlow imports
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:medita_bk/ui/core/widgets/external_link_webview_page.dart';

class HtmlDisplayWidget extends StatefulWidget {
  const HtmlDisplayWidget({
    super.key,
    this.width,
    this.height,
    this.description,
  });

  final double? width;
  final double? height;
  final String? description;

  @override
  _HtmlWidgetState createState() => _HtmlWidgetState();
}

class _HtmlWidgetState extends State<HtmlDisplayWidget> {
  /// Verifica se o URL é do domínio do próprio app (para deep linking)
  bool _isAppDomain(Uri uri) {
    return uri.host.contains('meditabk.com') || uri.scheme == 'meditabk';
  }

  Future<bool> launchLink(String url) async {
    try {
      final uri = Uri.parse(url);
      
      // Para links externos (não do app), usa estratégias específicas
      final isExternal = !_isAppDomain(uri);
      
      if (!kIsWeb && Platform.isIOS && isExternal) {
        // iOS + Link Externo: Cria um iframe HTML para evitar completamente
        // a interceptação do Flutter Deep Linking
        if (!mounted) return false;
        
        // Cria HTML com iframe embutido
        final iframeHtml = '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    html, body { height: 100%; overflow: hidden; }
    iframe { 
      width: 100%; 
      height: 100%; 
      border: none;
      display: block;
    }
  </style>
</head>
<body>
  <iframe src="$url" sandbox="allow-same-origin allow-scripts allow-forms allow-popups allow-top-navigation" allowfullscreen></iframe>
</body>
</html>
''';
        
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExternalLinkWebViewPage(
              url: iframeHtml,
              title: 'Formulário',
              isHtml: true,
            ),
          ),
        );
        return true;
      }
      
      // Comportamento padrão para Android, Web ou links internos do app
      if (await canLaunchUrl(uri)) {
        return await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      widget.description!,
      onTapUrl: (url) async => launchLink(url),
    );
  }
}
