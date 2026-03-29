import 'package:flutter/foundation.dart';
import 'package:medita_bk/data/repositories/tc_alarm_repository.dart';
import 'package:medita_bk/domain/models/traffic_control/tc_alarm_entity.dart';
import 'package:uuid/uuid.dart';

/// ViewModel da página principal do Traffic Control
///
/// Gerencia a lista de alarmes e suas operações (toggle, delete, duplicate).
class TcHomeViewModel extends ChangeNotifier {
  final TcAlarmRepository _repository;
  bool _isInitializing = true;

  TcHomeViewModel({required TcAlarmRepository repository})
      : _repository = repository {
    debugPrint('TcHomeVM: Construtor - _isInitializing = true, repository.isLoading = ${repository.isLoading}');
    _repository.addListener(_onRepositoryChanged);

    // Verificar imediatamente se repository já carregou
    Future.delayed(const Duration(milliseconds: 100), () {
      debugPrint('TcHomeVM: Checagem 100ms - repository.isLoading: ${_repository.isLoading}');
      if (!_repository.isLoading) {
        debugPrint('TcHomeVM: Repository já carregou! Finalizando _isInitializing');
        _isInitializing = false;
        notifyListeners();
      }
    });

    // Timeout para forçar fim do loading após 2 segundos (fallback)
    Future.delayed(const Duration(seconds: 2), () {
      if (_isInitializing) {
        debugPrint('TcHomeVM: Timeout de 2s - forçando isLoading = false');
        _isInitializing = false;
        notifyListeners();
      }
    });
  }

  void _onRepositoryChanged() {
    debugPrint('TcHomeVM: Repository mudou - isLoading: ${_repository.isLoading}, hasAlarms: ${_repository.hasAlarms}');
    if (!_repository.isLoading && _isInitializing) {
      _isInitializing = false;
    }
    notifyListeners();
  }

  /// Lista de alarmes carregados do repository
  List<TcAlarmEntity> get alarms => _repository.alarmsSortedByTime;

  /// Estado de carregamento
  bool get isLoading => _isInitializing || _repository.isLoading;

  /// Verifica se há alarmes cadastrados
  bool get hasAlarms => _repository.hasAlarms;

  /// Mensagem de erro (se houver)
  String? get error => _repository.error;

  /// Toggle global - true se TODOS os alarmes estão ativos
  bool get globalToggle =>
      alarms.isNotEmpty && alarms.every((a) => a.isEnabled);

  /// Verifica se algum alarme está tocando
  bool get isRinging => _repository.isRinging;

  /// Para o toque de um alarme manualmente
  Future<void> stopRinging() async {
    await _repository.stopRingingManually();
  }

  /// Alterna o estado de um alarme específico (ativo/inativo)
  Future<void> toggleAlarm(String id, bool enabled) async {
    try {
      await _repository.toggleAlarm(id, enabled);
      debugPrint('TcHomeVM: Alarme $id ${enabled ? 'ativado' : 'desativado'}');
    } catch (e) {
      debugPrint('TcHomeVM: Erro ao alternar alarme: $e');
    }
  }

  /// Alterna TODOS os alarmes (ativa todos ou desativa todos)
  Future<void> toggleAll(bool enabled) async {
    try {
      await _repository.toggleAllAlarms(enabled);
      debugPrint(
          'TcHomeVM: Todos os alarmes ${enabled ? 'ativados' : 'desativados'}');
    } catch (e) {
      debugPrint('TcHomeVM: Erro ao alternar todos os alarmes: $e');
    }
  }

  /// Deleta um alarme
  Future<void> deleteAlarm(String id) async {
    try {
      await _repository.deleteAlarm(id);
      debugPrint('TcHomeVM: Alarme $id deletado');
    } catch (e) {
      debugPrint('TcHomeVM: Erro ao deletar alarme: $e');
      rethrow;
    }
  }

  /// Duplica um alarme existente
  Future<void> duplicateAlarm(TcAlarmEntity alarm) async {
    try {
      final newAlarm = alarm.copyWith(
        id: const Uuid().v4(),
        title: '${alarm.title} (cópia)',
      );
      await _repository.createAlarm(newAlarm);
      debugPrint('TcHomeVM: Alarme duplicado: ${newAlarm.id}');
    } catch (e) {
      debugPrint('TcHomeVM: Erro ao duplicar alarme: $e');
      rethrow;
    }
  }

  /// Recarrega os alarmes
  Future<void> refresh() async {
    await _repository.loadAlarms();
  }

  /// Inicializa o ViewModel
  void initialize() {
    debugPrint('TcHomeVM: Inicializado');
    // Os alarmes já são carregados automaticamente no repository
  }

  /// Debug: imprime informações detalhadas dos alarmes
  Future<void> debugPrintAlarms() async {
    debugPrint('\n========================================');
    debugPrint('DEBUG ALARMES - ${DateTime.now()}');
    debugPrint('========================================');

    // 1. Alarmes salvos no repository
    debugPrint('\n1. ALARMES SALVOS (${alarms.length}):');
    for (final alarm in alarms) {
      debugPrint('  - ${alarm.formattedTime} | ${alarm.title}');
      debugPrint('    Configurado: hour=${alarm.hour}, minute=${alarm.minute}');
      debugPrint('    Ativo: ${alarm.isEnabled}');
      debugPrint('    ID: ${alarm.id}');
      debugPrint('    ID.hashCode: ${alarm.id.hashCode}');
      debugPrint('    Dias: ${alarm.daysDescription}');
    }

    // 2. Alarmes agendados no sistema
    await _repository.debugPrintScheduledAlarms();

    debugPrint('========================================\n');
  }

  @override
  void dispose() {
    debugPrint('TcHomeVM: Disposed');
    super.dispose();
  }
}
