import 'package:flutter/material.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';

/// Widget para selecionar dias da semana do alarme
///
/// Permite escolher em quais dias o alarme deve tocar.
/// Vazio = todo dia.
class TcDaysSelector extends StatelessWidget {
  final Set<int> selectedDays;
  final ValueChanged<int> onDayToggled;
  final VoidCallback onSelectAll;
  final VoidCallback onSelectWeekdays;
  final VoidCallback onSelectWeekends;
  final VoidCallback onClearAll;

  const TcDaysSelector({
    super.key,
    required this.selectedDays,
    required this.onDayToggled,
    required this.onSelectAll,
    required this.onSelectWeekdays,
    required this.onSelectWeekends,
    required this.onClearAll,
  });

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
                Icons.calendar_today,
                color: FlutterFlowTheme.of(context).primary,
                size: 20.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                'Repetir em',
                style: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily:
                          FlutterFlowTheme.of(context).titleSmallFamily,
                      color: FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).titleSmallIsCustom,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Dias da semana
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDayChip(context, 1, 'S'),
              _buildDayChip(context, 2, 'T'),
              _buildDayChip(context, 3, 'Q'),
              _buildDayChip(context, 4, 'Q'),
              _buildDayChip(context, 5, 'S'),
              _buildDayChip(context, 6, 'S'),
              _buildDayChip(context, 7, 'D'),
            ],
          ),
          const SizedBox(height: 16.0),

          // Atalhos
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              _buildShortcutChip(context, 'Todo dia', onSelectAll),
              _buildShortcutChip(context, 'Dias úteis', onSelectWeekdays),
              _buildShortcutChip(context, 'Fim de semana', onSelectWeekends),
              _buildShortcutChip(context, 'Limpar', onClearAll),
            ],
          ),
          const SizedBox(height: 12.0),

          // Descrição
          Text(
            _getDescription(),
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                  color: FlutterFlowTheme.of(context).primary,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).bodySmallIsCustom,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayChip(BuildContext context, int day, String label) {
    final isSelected = selectedDays.contains(day);

    return InkWell(
      onTap: () => onDayToggled(day),
      borderRadius: BorderRadius.circular(24.0),
      child: Container(
        width: 44.0,
        height: 44.0,
        decoration: BoxDecoration(
          color: isSelected
              ? FlutterFlowTheme.of(context).primary
              : FlutterFlowTheme.of(context).primaryBackground,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                  color: isSelected
                      ? Colors.white
                      : FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildShortcutChip(
      BuildContext context, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).alternate,
          ),
        ),
        child: Text(
          label,
          style: FlutterFlowTheme.of(context).bodySmall.override(
                fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                color: FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
                useGoogleFonts:
                    !FlutterFlowTheme.of(context).bodySmallIsCustom,
              ),
        ),
      ),
    );
  }

  String _getDescription() {
    if (selectedDays.isEmpty) {
      return 'O alarme tocará todo dia';
    } else if (selectedDays.length == 7) {
      return 'O alarme tocará todo dia';
    } else {
      final dayNames = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
      final sorted = selectedDays.toList()..sort();
      final names = sorted.map((d) => dayNames[d - 1]).join(', ');
      return 'O alarme tocará: $names';
    }
  }
}
