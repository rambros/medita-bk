import 'package:flutter/material.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';

/// Widget para selecionar música do alarme
///
/// Exibe a música atualmente selecionada e abre o picker ao ser clicado.
class TcMusicSelector extends StatelessWidget {
  final String selectedMusicTitle;
  final VoidCallback onSelectMusic;

  const TcMusicSelector({
    super.key,
    required this.selectedMusicTitle,
    required this.onSelectMusic,
  });

  @override
  Widget build(BuildContext context) {
    final hasMusic = selectedMusicTitle != 'Nenhuma música selecionada';

    return InkWell(
      onTap: () {
        debugPrint('TcMusicSelector: Widget clicado');
        onSelectMusic();
      },
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: hasMusic
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate,
            width: hasMusic ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            // Ícone
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: hasMusic
                    ? FlutterFlowTheme.of(context).primary.withOpacity(0.1)
                    : FlutterFlowTheme.of(context).alternate,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(
                hasMusic ? Icons.music_note : Icons.music_note_outlined,
                color: hasMusic
                    ? FlutterFlowTheme.of(context).primary
                    : FlutterFlowTheme.of(context).secondaryText,
                size: 28.0,
              ),
            ),
            const SizedBox(width: 16.0),

            // Texto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Música para Meditar',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodySmallFamily,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodySmallIsCustom,
                        ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    selectedMusicTitle,
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyLargeFamily,
                          color: hasMusic
                              ? FlutterFlowTheme.of(context).primaryText
                              : FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                          fontWeight:
                              hasMusic ? FontWeight.w600 : FontWeight.normal,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Seta
            Icon(
              Icons.chevron_right,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ],
        ),
      ),
    );
  }
}
