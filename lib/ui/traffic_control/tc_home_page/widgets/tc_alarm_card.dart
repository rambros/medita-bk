import 'package:flutter/material.dart';
import 'package:medita_bk/domain/models/traffic_control/tc_alarm_entity.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';

/// Card que exibe um alarme individual na lista
///
/// Mostra:
/// - Horário em destaque
/// - Título do alarme
/// - Nome da música
/// - Dias da semana (se configurado)
/// - Switch para ativar/desativar
/// - Menu de ações (editar, duplicar, deletar)
class TcAlarmCard extends StatelessWidget {
  final TcAlarmEntity alarm;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;

  const TcAlarmCard({
    super.key,
    required this.alarm,
    required this.onToggle,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: alarm.isEnabled ? 2.0 : 1.0,
      color: alarm.isEnabled
          ? FlutterFlowTheme.of(context).secondaryBackground
          : FlutterFlowTheme.of(context).primaryBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: alarm.isEnabled
              ? FlutterFlowTheme.of(context).primary.withOpacity(0.3)
              : FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Horário em destaque
            _buildTimeDisplay(context),
            const SizedBox(width: 12.0),

            // Informações do alarme
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // LINHA 1: Título expandido
                  Text(
                    alarm.title,
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                          color: alarm.isEnabled
                              ? FlutterFlowTheme.of(context).primaryText
                              : FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).titleMediumIsCustom,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),

                  // LINHA 2: Detalhes + Controles
                  Row(
                    children: [
                      // Coluna 1: Detalhes (música, duração, dias)
                      Expanded(
                        child: _buildAlarmDetails(context),
                      ),

                      // Coluna 2: Controles (switch e menu)
                      Switch.adaptive(
                        value: alarm.isEnabled,
                        onChanged: onToggle,
                        activeColor: FlutterFlowTheme.of(context).primary,
                      ),
                      _buildActionMenu(context),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeDisplay(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: alarm.isEnabled
              ? [
                  FlutterFlowTheme.of(context).primary,
                  FlutterFlowTheme.of(context).secondary,
                ]
              : [
                  FlutterFlowTheme.of(context).secondaryText.withOpacity(0.3),
                  FlutterFlowTheme.of(context).secondaryText.withOpacity(0.2),
                ],
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            alarm.formattedTime,
            style: FlutterFlowTheme.of(context).displaySmall.override(
                  fontFamily: FlutterFlowTheme.of(context).displaySmallFamily,
                  color: alarm.isEnabled
                      ? Colors.white
                      : FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.0,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).displaySmallIsCustom,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlarmDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Nome da música
        Row(
          children: [
            Icon(
              Icons.music_note,
              size: 16.0,
              color: alarm.isEnabled
                  ? FlutterFlowTheme.of(context).primary
                  : FlutterFlowTheme.of(context).secondaryText,
            ),
            const SizedBox(width: 4.0),
            Expanded(
              child: Text(
                alarm.musicTitle,
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily:
                          FlutterFlowTheme.of(context).bodySmallFamily,
                      color: alarm.isEnabled
                          ? FlutterFlowTheme.of(context).secondaryText
                          : FlutterFlowTheme.of(context).secondaryText
                              .withOpacity(0.6),
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodySmallIsCustom,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        // Duração da música
        const SizedBox(height: 2.0),
        Row(
          children: [
            Icon(
              Icons.timer_outlined,
              size: 14.0,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            const SizedBox(width: 4.0),
            Text(
              alarm.formattedMusicDuration,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily:
                        FlutterFlowTheme.of(context).bodySmallFamily,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 12.0,
                    letterSpacing: 0.0,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).bodySmallIsCustom,
                  ),
            ),
          ],
        ),

        // Dias da semana
        if (alarm.daysOfWeek.isNotEmpty) ...[
          const SizedBox(height: 6.0),
          Text(
            alarm.daysDescription,
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                  color: alarm.isEnabled
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 12.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).bodySmallIsCustom,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: FlutterFlowTheme.of(context).secondaryText,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Icons.edit,
                size: 20.0,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
              const SizedBox(width: 12.0),
              const Text('Editar'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'duplicate',
          child: Row(
            children: [
              Icon(
                Icons.copy,
                size: 20.0,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
              const SizedBox(width: 12.0),
              const Text('Duplicar'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_outline,
                size: 20.0,
                color: FlutterFlowTheme.of(context).error,
              ),
              const SizedBox(width: 12.0),
              Text(
                'Deletar',
                style: TextStyle(
                  color: FlutterFlowTheme.of(context).error,
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit();
            break;
          case 'duplicate':
            onDuplicate();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
    );
  }
}
