import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_widgets.dart';
import 'package:medita_bk/ui/core/actions/actions.dart' as actions;
import 'package:medita_bk/core/enums/enums.dart';

/// Widget para selecionar duração máxima do alarme
///
/// Permite escolher minutos e segundos precisos através de um picker.
/// 0 = sem limite (toca até o final do áudio).
class TcDurationPicker extends StatelessWidget {
  final int selectedSeconds;
  final ValueChanged<int> onDurationChanged;

  const TcDurationPicker({
    super.key,
    required this.selectedSeconds,
    required this.onDurationChanged,
  });

  String _formatDuration(int seconds) {
    if (seconds == 0) return 'Duração da música';

    final mins = seconds ~/ 60;
    final secs = seconds % 60;

    if (mins > 0 && secs > 0) {
      return '$mins min ${secs}s';
    } else if (mins > 0) {
      return '$mins min';
    } else {
      return '${secs}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.timer_outlined,
                color: FlutterFlowTheme.of(context).primary,
                size: 20.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                'Duração Máxima',
                style: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                      color: FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          // Descrição
          Text(
            'Escolha por quanto tempo o áudio deve tocar',
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                  useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                ),
          ),
          const SizedBox(height: 16.0),

          // Botão para abrir picker
          FFButtonWidget(
            onPressed: () async {
              await actions.showPickerNumberFormatValue(
                context,
                selectedSeconds,
                FileType.silence,
                (newDuration) async {
                  debugPrint('TcDurationPicker: Nova duração selecionada - $newDuration segundos');
                  onDurationChanged(newDuration);
                },
              );
            },
            text: 'Definir duração',
            options: FFButtonOptions(
              width: double.infinity,
              height: 48.0,
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              color: FlutterFlowTheme.of(context).primary,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                    color: Colors.white,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                    useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                  ),
              elevation: 2.0,
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).primary,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            showLoadingIndicator: false,
          ),
          const SizedBox(height: 12.0),

          // Duração selecionada
          Center(
            child: Text(
              'Duração selecionada: ${_formatDuration(selectedSeconds)}',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                  ),
            ),
          ),

          // Atalhos rápidos
          const SizedBox(height: 16.0),
          Text(
            'Atalhos rápidos:',
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                  useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                ),
          ),
          const SizedBox(height: 8.0),
          Platform.isIOS
              ? Row(
                  // iOS: Centraliza as 2 opções
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildQuickButton(context, 0, 'Duração da música'),
                    const SizedBox(width: 8.0),
                    _buildQuickButton(context, 60, '1 min'),
                  ],
                )
              : Wrap(
                  // Android: 4 opções em wrap
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    _buildQuickButton(context, 0, 'Duração da música'),
                    _buildQuickButton(context, 60, '1 min'),
                    _buildQuickButton(context, 180, '3 min'),
                    _buildQuickButton(context, 300, '5 min'),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildQuickButton(BuildContext context, int seconds, String label) {
    final isSelected = selectedSeconds == seconds;

    return InkWell(
      onTap: () {
        debugPrint('TcDurationPicker: Atalho rápido selecionado - $seconds segundos ($label)');
        onDurationChanged(seconds);
      },
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected
              ? FlutterFlowTheme.of(context).primary.withOpacity(0.1)
              : FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: isSelected ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).alternate,
            width: 1.0,
          ),
        ),
        child: Text(
          label,
          style: FlutterFlowTheme.of(context).bodySmall.override(
                fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                color: isSelected ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
              ),
        ),
      ),
    );
  }
}
