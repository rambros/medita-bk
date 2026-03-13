import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:provider/provider.dart';
import 'package:medita_bk/domain/models/traffic_control/tc_music_entity.dart';
import 'package:medita_bk/data/repositories/tc_alarm_repository.dart';
import 'package:medita_bk/data/repositories/tc_music_repository.dart';
import 'view_model/tc_alarm_form_view_model.dart';
import 'widgets/tc_time_picker.dart';
import 'widgets/tc_music_selector.dart';
import 'widgets/tc_days_selector.dart';

/// Página de formulário para criar/editar alarme do Traffic Control
///
/// Permite configurar:
/// - Horário do alarme
/// - Título personalizado
/// - Música que será reproduzida
/// - Dias da semana (vazio = todo dia)
class TcAlarmFormPage extends StatefulWidget {
  final String? alarmId;

  const TcAlarmFormPage({super.key, this.alarmId});

  static String routeName = 'TcAlarmFormPage';
  static String routePath = 'traffic-control/alarm-form';

  @override
  State<TcAlarmFormPage> createState() => _TcAlarmFormPageState();
}

class _TcAlarmFormPageState extends State<TcAlarmFormPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  late TcAlarmFormViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'TcAlarmFormPage'});

    // Cria o ViewModel localmente com o alarmId
    _viewModel = TcAlarmFormViewModel(
      alarmRepository: context.read<TcAlarmRepository>(),
      musicRepository: context.read<TcMusicRepository>(),
      alarmId: widget.alarmId,
    );

    // Inicializa o ViewModel
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _viewModel.initialize();
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TcAlarmFormViewModel>.value(
      value: _viewModel,
      child: Consumer<TcAlarmFormViewModel>(
        builder: (context, viewModel, _) {
          return _buildScaffold(context, viewModel);
        },
      ),
    );
  }

  Widget _buildScaffold(BuildContext context, TcAlarmFormViewModel viewModel) {
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
          viewModel.isEditMode ? 'Editar Lembrete' : 'Novo Lembrete',
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
    );
  }

  Widget _buildBody(BuildContext context, TcAlarmFormViewModel viewModel) {
    // Loading state
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
              'Carregando...',
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

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Mensagem de erro
            if (viewModel.errorMessage != null) ...[
              _buildErrorMessage(context, viewModel),
              const SizedBox(height: 16.0),
            ],

            // Time Picker
            TcTimePicker(
              selectedTime: viewModel.selectedTime,
              onTimeChanged: viewModel.setTime,
            ),
            const SizedBox(height: 24.0),

            // Título
            TextFormField(
              controller: viewModel.titleController,
              decoration: InputDecoration(
                labelText: 'Título do Lembrete',
                hintText: 'Ex: Meditação Matinal',
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              style: FlutterFlowTheme.of(context).bodyLarge.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                    letterSpacing: 0.0,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                  ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Título é obrigatório';
                }
                return null;
              },
            ),
            const SizedBox(height: 24.0),

            // Music Selector
            TcMusicSelector(
              selectedMusicTitle: viewModel.selectedMusicTitle,
              onSelectMusic: () async {
                debugPrint('TcAlarmFormPage: Clicou em selecionar música');
                // Navega para o picker de música (FASE 5)
                try {
                  final result = await context.pushNamed('TcMusicPickerPage');
                  debugPrint('TcAlarmFormPage: Retornou do picker - result: $result');
                  if (result != null && result is TcMusicEntity) {
                    debugPrint('TcAlarmFormPage: Música selecionada - ${result.title}');
                    viewModel.setMusic(result);
                  } else {
                    debugPrint('TcAlarmFormPage: Nenhuma música selecionada ou tipo incorreto');
                  }
                } catch (e) {
                  debugPrint('TcAlarmFormPage: Erro ao navegar para picker - $e');
                }
              },
            ),
            const SizedBox(height: 24.0),

            // Days Selector
            TcDaysSelector(
              selectedDays: viewModel.selectedDays,
              onDayToggled: viewModel.toggleDay,
              onSelectAll: viewModel.selectAllDays,
              onSelectWeekdays: viewModel.selectWeekdays,
              onSelectWeekends: viewModel.selectWeekends,
              onClearAll: viewModel.clearDays,
            ),
            const SizedBox(height: 32.0),

            // Resumo
            _buildSummary(context, viewModel),
            const SizedBox(height: 32.0),

            // Botão Salvar
            ElevatedButton(
              onPressed: viewModel.isSaving ? null : () => _handleSave(context, viewModel),
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 2.0,
              ),
              child: viewModel.isSaving
                  ? SizedBox(
                      height: 20.0,
                      width: 20.0,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.0,
                      ),
                    )
                  : Text(
                      viewModel.isEditMode ? 'Salvar Alterações' : 'Criar Lembrete',
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).titleMediumFamily,
                            color: Colors.white,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .titleMediumIsCustom,
                          ),
                    ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage(
      BuildContext context, TcAlarmFormViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).error,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: FlutterFlowTheme.of(context).error,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              viewModel.errorMessage!,
              style: TextStyle(
                color: FlutterFlowTheme.of(context).error,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20.0),
            onPressed: viewModel.clearMessages,
            color: FlutterFlowTheme.of(context).error,
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context, TcAlarmFormViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.summarize,
                color: FlutterFlowTheme.of(context).primary,
                size: 20.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                'Resumo do Lembrete',
                style: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily:
                          FlutterFlowTheme.of(context).titleSmallFamily,
                      color: FlutterFlowTheme.of(context).primary,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).titleSmallIsCustom,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          _buildSummaryItem(
            context,
            Icons.access_time,
            'Horário',
            viewModel.formattedTime,
          ),
          _buildSummaryItem(
            context,
            Icons.calendar_today,
            'Dias',
            viewModel.daysDescription,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
      BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16.0,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
          const SizedBox(width: 8.0),
          Text(
            '$label: ',
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).bodySmallIsCustom,
                ),
          ),
          Text(
            value,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                  color: FlutterFlowTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSave(
      BuildContext context, TcAlarmFormViewModel viewModel) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final success = await viewModel.save();

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            viewModel.successMessage ?? 'Lembrete salvo com sucesso!',
            style: TextStyle(
              color: FlutterFlowTheme.of(context).info,
            ),
          ),
          backgroundColor: FlutterFlowTheme.of(context).success,
          duration: const Duration(seconds: 2),
        ),
      );

      // Aguarda um pouco e volta
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        context.pop();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            viewModel.errorMessage ?? 'Erro ao salvar lembrete',
          ),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }
}
