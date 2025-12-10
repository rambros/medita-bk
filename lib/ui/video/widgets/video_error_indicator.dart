import 'package:flutter/material.dart';
import 'package:medita_b_k/ui/core/flutter_flow/flutter_flow_theme.dart';

class VideoErrorIndicator extends StatelessWidget {
  final VoidCallback onRetry;
  final String? message;

  const VideoErrorIndicator({
    super.key,
    required this.onRetry,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48.0,
            color: FlutterFlowTheme.of(context).error,
          ),
          const SizedBox(height: 16.0),
          Text(
            message ?? 'Erro ao carregar vídeos',
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                  letterSpacing: 0.0,
                  useGoogleFonts: !FlutterFlowTheme.of(context).titleMediumIsCustom,
                ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Verifique sua conexão e tente novamente',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                  letterSpacing: 0.0,
                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar Novamente'),
            style: ElevatedButton.styleFrom(
              backgroundColor: FlutterFlowTheme.of(context).primary,
              foregroundColor: FlutterFlowTheme.of(context).info,
            ),
          ),
        ],
      ),
    );
  }
}

class VideoNewPageErrorIndicator extends StatelessWidget {
  final VoidCallback onRetry;

  const VideoNewPageErrorIndicator({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh),
        label: const Text('Tentar Novamente'),
      ),
    );
  }
}
