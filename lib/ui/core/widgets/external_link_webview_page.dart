import 'package:flutter/material.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_web_view.dart';
import 'package:medita_bk/ui/core/theme/app_theme.dart';

/// Página simples para exibir links externos em WebView
/// Usada para evitar interceptação do Firebase Dynamic Links no iOS
class ExternalLinkWebViewPage extends StatelessWidget {
  const ExternalLinkWebViewPage({
    super.key,
    required this.url,
    this.title,
    this.isHtml = false,
  });

  final String url;
  final String? title;
  final bool isHtml; // Se true, trata url como HTML inline

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.primary,
        foregroundColor: appTheme.info,
        title: Text(
          title ?? 'Carregando...',
          style: TextStyle(color: appTheme.info),
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: appTheme.info),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FlutterFlowWebView(
        content: url,
        bypass: false,
        html: isHtml, // Usa HTML inline quando true
        verticalScroll: true,
        horizontalScroll: true,
      ),
    );
  }
}
