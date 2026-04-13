import 'package:flutter/material.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/data/services/tc_battery_optimization_service.dart';

/// Dialog exibido no Android quando há risco de os alarmes não tocarem
/// devido a otimização de bateria (padrão Android ou Samsung Freecess).
class TcBatteryOptimizationDialog extends StatelessWidget {
  final BatteryIssueType issueType;

  const TcBatteryOptimizationDialog({
    super.key,
    required this.issueType,
  });

  /// Verifica o problema e exibe o dialog apropriado se necessário.
  static Future<void> showIfNeeded(BuildContext context) async {
    final service = TcBatteryOptimizationService();
    final shouldShow = await service.shouldShowDialog();
    if (!shouldShow || !context.mounted) return;

    final issue = await service.detectIssue();
    if (issue == BatteryIssueType.none || !context.mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => TcBatteryOptimizationDialog(issueType: issue),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = TcBatteryOptimizationService();
    final isSamsung = issueType == BatteryIssueType.samsungFreecess;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).warning.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.battery_alert_rounded,
              size: 36,
              color: FlutterFlowTheme.of(context).warning,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Lembretes podem não tocar',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.0,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).titleMediumIsCustom,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            isSamsung
                ? 'Seu Samsung pode bloquear alarmes em segundo plano (Freecess).\n\nPara garantir que seus lembretes toquem no horário certo, siga os passos:\n\n1. Configurações → Manutenção do dispositivo\n2. Bateria → Limites de uso em 2º plano\n3. Apps nunca suspensos → Adicionar este app'
                : 'Seu celular pode bloquear alarmes em segundo plano para economizar bateria.\n\nPara garantir que seus lembretes toquem no horário certo, desative a otimização de bateria para este app.',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                ),
          ),
          const SizedBox(height: 8),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await service.dismissPermanently();
            if (context.mounted) Navigator.of(context).pop();
          },
          child: Text(
            'Não mostrar novamente',
            style: TextStyle(
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: 13,
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              // Usuário tomou a ação — não mostrar novamente
              await service.dismissPermanently();
              if (context.mounted) Navigator.of(context).pop();
              if (isSamsung) {
                // Samsung: abre detalhes do app onde o usuário acessa
                // Bateria → Sem restrições
                await service.openAppBatterySettings();
              } else {
                // Android padrão: solicita isenção diretamente
                await service.requestIgnore();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: FlutterFlowTheme.of(context).primary,
              foregroundColor: FlutterFlowTheme.of(context).info,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(
              isSamsung ? 'Abrir Configurações' : 'Configurar Agora',
              style: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                    color: FlutterFlowTheme.of(context).info,
                    letterSpacing: 0.0,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).titleSmallIsCustom,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
