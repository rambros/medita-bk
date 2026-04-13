import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:provider/provider.dart';
import 'view_model/tc_home_view_model.dart';
import 'widgets/tc_alarm_card.dart';
import 'widgets/tc_global_toggle.dart';
import 'widgets/tc_empty_state.dart';
import 'widgets/tc_battery_optimization_dialog.dart';

/// Página principal do módulo Traffic Control
///
/// Exibe a lista de alarmes cadastrados e permite:
/// - Ativar/desativar alarmes individualmente
/// - Ativar/desativar todos os alarmes (toggle global)
/// - Criar novos alarmes
/// - Editar alarmes existentes
/// - Duplicar alarmes
/// - Deletar alarmes
class TcHomePage extends StatefulWidget {
  const TcHomePage({super.key});

  static String routeName = 'TcHomePage';
  static String routePath = 'traffic-control';

  @override
  State<TcHomePage> createState() => _TcHomePageState();
}

class _TcHomePageState extends State<TcHomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'TcHomePage'});

    // Inicializa o ViewModel
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.read<TcHomeViewModel>().initialize();
      _checkBatteryOptimization();
    });
  }

  Future<void> _checkBatteryOptimization() async {
    if (!mounted) return;
    await TcBatteryOptimizationDialog.showIfNeeded(context);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TcHomeViewModel>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 60.0,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).info,
            size: 30.0,
          ),
          onPressed: () async {
            context.pop();
          },
        ),
        title: Text(
          'Lembretes para Meditar',
          style: FlutterFlowTheme.of(context).titleLarge.override(
                fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                color: FlutterFlowTheme.of(context).info,
                letterSpacing: 0.0,
                useGoogleFonts:
                    !FlutterFlowTheme.of(context).titleLargeIsCustom,
              ),
        ),
        actions: const [],
        centerTitle: true,
        elevation: 2.0,
      ),
      body: _buildBody(context, viewModel),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.pushNamed('TcAlarmFormPageNew');
          // Recarrega a lista ao voltar
          viewModel.refresh();
        },
        backgroundColor: FlutterFlowTheme.of(context).primary,
        icon: Icon(
          Icons.add,
          color: FlutterFlowTheme.of(context).info,
        ),
        label: Text(
          'Novo Lembrete',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                color: FlutterFlowTheme.of(context).info,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
                useGoogleFonts:
                    !FlutterFlowTheme.of(context).bodyMediumIsCustom,
              ),
        ),
        elevation: 8.0,
      ),
    );
  }

  Widget _buildBody(BuildContext context, TcHomeViewModel viewModel) {
    // Estado de carregamento
    if (viewModel.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: FlutterFlowTheme.of(context).primary,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Carregando lembretes...',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                  ),
            ),
          ],
        ),
      );
    }

    // Estado vazio
    if (!viewModel.hasAlarms) {
      return TcEmptyState(
        onCreateFirst: () async {
          await context.pushNamed('TcAlarmFormPageNew');
          // Recarrega a lista ao voltar
          viewModel.refresh();
        },
      );
    }

    // Lista de alarmes
    return Column(
      children: [
        if (viewModel.isRinging)
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                await viewModel.stopRinging();
              },
              icon: const Icon(Icons.stop_circle, size: 24),
              label: Text(
                'Parar Som do Lembrete',
                style: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                      color: FlutterFlowTheme.of(context).info,
                      useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                    ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).error,
                foregroundColor: FlutterFlowTheme.of(context).info,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
            ),
          ),

        // Toggle global
        TcGlobalToggle(
          value: viewModel.globalToggle,
          onChanged: (value) async {
            await viewModel.toggleAll(value);
          },
        ),

        // Lista de alarmes
        Expanded(
          child: RefreshIndicator(
            onRefresh: viewModel.refresh,
            color: FlutterFlowTheme.of(context).primary,
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 80.0),
              itemCount: viewModel.alarms.length,
              itemBuilder: (context, index) {
                final alarm = viewModel.alarms[index];
                return TcAlarmCard(
                  alarm: alarm,
                  onToggle: (enabled) async {
                    await viewModel.toggleAlarm(alarm.id, enabled);
                  },
                  onEdit: () async {
                    await context.pushNamed(
                      'TcAlarmFormPageEdit',
                      pathParameters: {'id': alarm.id},
                    );
                    // Recarrega a lista ao voltar
                    viewModel.refresh();
                  },
                  onDuplicate: () async {
                    await _handleDuplicate(context, viewModel, alarm);
                  },
                  onDelete: () async {
                    await _handleDelete(context, viewModel, alarm);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleDuplicate(
    BuildContext context,
    TcHomeViewModel viewModel,
    alarm,
  ) async {
    try {
      await viewModel.duplicateAlarm(alarm);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lembrete duplicado com sucesso!',
            style: TextStyle(
              color: FlutterFlowTheme.of(context).info,
            ),
          ),
          backgroundColor: FlutterFlowTheme.of(context).success,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao duplicar: $e'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

  Future<void> _handleDelete(
    BuildContext context,
    TcHomeViewModel viewModel,
    alarm,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (alertDialogContext) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: Text(
            'Deseja realmente deletar o lembrete "${alarm.title}"?\n\nEsta ação não pode ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(alertDialogContext, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(alertDialogContext, true),
              style: TextButton.styleFrom(
                foregroundColor: FlutterFlowTheme.of(context).error,
              ),
              child: const Text('Deletar'),
            ),
          ],
        );
      },
    );

    if (confirm == true && mounted) {
      try {
        await viewModel.deleteAlarm(alarm.id);
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Lembrete deletado com sucesso!',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).info,
              ),
            ),
            backgroundColor: FlutterFlowTheme.of(context).success,
            duration: const Duration(seconds: 2),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao deletar: $e'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    }
  }
}
