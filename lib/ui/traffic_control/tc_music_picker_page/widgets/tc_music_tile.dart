import 'package:flutter/material.dart';
import 'package:medita_bk/domain/models/traffic_control/tc_music_entity.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';

/// Tile de música com preview
///
/// Exibe informações da música e botão de play/pause para preview.
class TcMusicTile extends StatelessWidget {
  final TcMusicEntity music;
  final bool isSelected;
  final bool isPlaying;
  final bool isLoading;
  final double progress;
  final VoidCallback onTap;
  final VoidCallback onPlayPause;

  const TcMusicTile({
    super.key,
    required this.music,
    required this.isSelected,
    required this.isPlaying,
    required this.isLoading,
    required this.progress,
    required this.onTap,
    required this.onPlayPause,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isSelected
              ? FlutterFlowTheme.of(context).primary.withOpacity(0.1)
              : FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Thumbnail ou ícone
                _buildThumbnail(context),
                const SizedBox(width: 12.0),

                // Informações
                Expanded(
                  child: _buildInfo(context),
                ),

                // Botão play/pause
                _buildPlayButton(context),

                // Indicador de seleção
                if (isSelected) ...[
                  const SizedBox(width: 8.0),
                  Icon(
                    Icons.check_circle,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 24.0,
                  ),
                ],
              ],
            ),

            // Barra de progresso do preview
            if (isPlaying || progress > 0) ...[
              const SizedBox(height: 8.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor:
                      FlutterFlowTheme.of(context).alternate,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                  minHeight: 4.0,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    if (music.thumbnailUrl != null && music.thumbnailUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          music.thumbnailUrl!,
          width: 56.0,
          height: 56.0,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultIcon(context);
          },
        ),
      );
    } else {
      return _buildDefaultIcon(context);
    }
  }

  Widget _buildDefaultIcon(BuildContext context) {
    return Container(
      width: 56.0,
      height: 56.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Icon(
        Icons.music_note,
        color: FlutterFlowTheme.of(context).primary,
        size: 28.0,
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título
        Text(
          music.title,
          style: FlutterFlowTheme.of(context).titleSmall.override(
                fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                color: isSelected
                    ? FlutterFlowTheme.of(context).primary
                    : FlutterFlowTheme.of(context).primaryText,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
                useGoogleFonts:
                    !FlutterFlowTheme.of(context).titleSmallIsCustom,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4.0),

        // Artista (se houver)
        if (music.artist != null && music.artist!.isNotEmpty)
          Text(
            music.artist!,
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).bodySmallIsCustom,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

        // Duração e categoria
        Row(
          children: [
            Icon(
              Icons.timer_outlined,
              size: 14.0,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            const SizedBox(width: 4.0),
            Text(
              music.formattedDuration,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 12.0,
                    letterSpacing: 0.0,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).bodySmallIsCustom,
                  ),
            ),
            if (music.category != null && music.category!.isNotEmpty) ...[
              const SizedBox(width: 8.0),
              Text(
                '•',
                style: TextStyle(
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                music.category!,
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily:
                          FlutterFlowTheme.of(context).bodySmallFamily,
                      color: FlutterFlowTheme.of(context).primary,
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodySmallIsCustom,
                    ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    return IconButton(
      onPressed: onPlayPause,
      icon: isLoading
          ? SizedBox(
              width: 24.0,
              height: 24.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                color: FlutterFlowTheme.of(context).primary,
              ),
            )
          : Icon(
              isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
              size: 36.0,
              color: FlutterFlowTheme.of(context).primary,
            ),
    );
  }
}
