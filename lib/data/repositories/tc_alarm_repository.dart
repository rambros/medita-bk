import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:medita_bk/domain/models/traffic_control/index.dart';
import 'package:medita_bk/data/services/tc_local_storage_service.dart';
import 'package:medita_bk/data/services/tc_alarm_scheduler_service.dart';
import 'package:medita_bk/data/services/tc_audio_cache_service.dart';

/// Repository responsável por gerenciar alarmes do Traffic Control
///
/// Orquestra persistência local, agendamento e cache de áudios.
/// Segue o padrão ChangeNotifier para notificar a UI sobre mudanças.
class TcAlarmRepository extends ChangeNotifier {
  final TcLocalStorageService _localStorage;
  final TcAlarmSchedulerService _scheduler;
  final TcAudioCacheService _audioCache;

  List<TcAlarmEntity> _alarms = [];
  bool _isLoading = false;
  String? _error;

  // Auto-stop: Listener e timers para parar alarmes automaticamente
  StreamSubscription? _ringStreamSubscription;
  final Map<int, Timer> _activeTimers = {};

  // Getters públicos
  List<TcAlarmEntity> get alarms => List.unmodifiable(_alarms);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasAlarms => _alarms.isNotEmpty;
  int get alarmsCount => _alarms.length;
  int get activeAlarmsCount => _alarms.where((a) => a.isEnabled).length;

  TcAlarmRepository({
    required TcLocalStorageService localStorage,
    required TcAlarmSchedulerService scheduler,
    required TcAudioCacheService audioCache,
  })  : _localStorage = localStorage,
        _scheduler = scheduler,
        _audioCache = audioCache {
    _init();
  }

  /// Inicializa o repository carregando alarmes salvos
  Future<void> _init() async {
    debugPrint('TcAlarmRepository: Iniciando _init()');
    await loadAlarms();
    _startAlarmRingingListener();
    debugPrint('TcAlarmRepository: _init() concluído - isLoading: $_isLoading');
  }

  /// Carrega todos os alarmes do armazenamento local
  Future<void> loadAlarms() async {
    debugPrint('TcAlarmRepository: loadAlarms() INICIOU - setando isLoading = true');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _alarms = await _localStorage.loadAlarms();

      // Reagendar alarmes ativos
      for (final alarm in _alarms.where((a) => a.isEnabled)) {
        await _rescheduleAlarm(alarm);
      }

      _error = null;
      debugPrint('TcAlarmRepository: ${_alarms.length} alarme(s) carregado(s)');
    } catch (e) {
      _error = 'Erro ao carregar alarmes: $e';
      debugPrint('TcAlarmRepository: $_error');
    } finally {
      debugPrint('TcAlarmRepository: loadAlarms() FINALIZOU - setando isLoading = false');
      _isLoading = false;
      notifyListeners();
      debugPrint('TcAlarmRepository: notifyListeners() chamado - isLoading: $_isLoading, hasAlarms: $hasAlarms');
    }
  }

  /// Cria um novo alarme
  Future<bool> createAlarm(TcAlarmEntity alarm) async {
    try {
      _alarms.add(alarm);
      await _saveAndSchedule(alarm);

      debugPrint('TcAlarmRepository: Alarme criado - ${alarm.title}');
      return true;
    } catch (e) {
      _error = 'Erro ao criar alarme: $e';
      debugPrint('TcAlarmRepository: $_error');
      _alarms.removeWhere((a) => a.id == alarm.id); // Rollback
      notifyListeners();
      return false;
    }
  }

  /// Atualiza um alarme existente
  Future<bool> updateAlarm(TcAlarmEntity alarm) async {
    final index = _alarms.indexWhere((a) => a.id == alarm.id);

    if (index == -1) {
      _error = 'Alarme não encontrado';
      notifyListeners();
      return false;
    }

    final oldAlarm = _alarms[index];

    try {
      _alarms[index] = alarm;
      await _saveAndSchedule(alarm);

      debugPrint('TcAlarmRepository: Alarme atualizado - ${alarm.title}');
      return true;
    } catch (e) {
      _error = 'Erro ao atualizar alarme: $e';
      debugPrint('TcAlarmRepository: $_error');
      _alarms[index] = oldAlarm; // Rollback
      notifyListeners();
      return false;
    }
  }

  /// Deleta um alarme
  Future<bool> deleteAlarm(String id) async {
    final index = _alarms.indexWhere((a) => a.id == id);

    if (index == -1) {
      return false;
    }

    final removedAlarm = _alarms[index];

    try {
      await _scheduler.cancelAlarm(id);
      _alarms.removeAt(index);
      await _localStorage.saveAlarms(_alarms);

      notifyListeners();
      debugPrint('TcAlarmRepository: Alarme deletado - ${removedAlarm.title}');
      return true;
    } catch (e) {
      _error = 'Erro ao deletar alarme: $e';
      debugPrint('TcAlarmRepository: $_error');
      _alarms.insert(index, removedAlarm); // Rollback
      notifyListeners();
      return false;
    }
  }

  /// Liga ou desliga um alarme individual
  Future<bool> toggleAlarm(String id, bool enabled) async {
    final index = _alarms.indexWhere((a) => a.id == id);

    if (index == -1) {
      return false;
    }

    final oldAlarm = _alarms[index];
    final updatedAlarm = oldAlarm.copyWith(isEnabled: enabled);

    try {
      _alarms[index] = updatedAlarm;

      if (enabled) {
        await _rescheduleAlarm(updatedAlarm);
      } else {
        await _scheduler.cancelAlarm(id);
      }

      await _localStorage.saveAlarms(_alarms);
      notifyListeners();

      debugPrint('TcAlarmRepository: Alarme ${enabled ? 'ativado' : 'desativado'} - ${updatedAlarm.title}');
      return true;
    } catch (e) {
      _error = 'Erro ao alternar alarme: $e';
      debugPrint('TcAlarmRepository: $_error');
      _alarms[index] = oldAlarm; // Rollback
      notifyListeners();
      return false;
    }
  }

  /// Liga ou desliga todos os alarmes de uma vez
  Future<bool> toggleAllAlarms(bool enabled) async {
    final oldAlarms = List<TcAlarmEntity>.from(_alarms);

    try {
      for (var i = 0; i < _alarms.length; i++) {
        _alarms[i] = _alarms[i].copyWith(isEnabled: enabled);

        if (enabled) {
          await _rescheduleAlarm(_alarms[i]);
        } else {
          await _scheduler.cancelAlarm(_alarms[i].id);
        }
      }

      await _localStorage.saveAlarms(_alarms);
      notifyListeners();

      debugPrint('TcAlarmRepository: Todos os alarmes ${enabled ? 'ativados' : 'desativados'}');
      return true;
    } catch (e) {
      _error = 'Erro ao alternar todos os alarmes: $e';
      debugPrint('TcAlarmRepository: $_error');
      _alarms = oldAlarms; // Rollback
      notifyListeners();
      return false;
    }
  }

  /// Duplica um alarme existente
  Future<bool> duplicateAlarm(TcAlarmEntity alarm) async {
    final newAlarm = alarm.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '${alarm.title} (cópia)',
      createdAt: DateTime.now(),
    );

    return await createAlarm(newAlarm);
  }

  /// Obtém um alarme específico pelo ID
  TcAlarmEntity? getAlarmById(String id) {
    try {
      return _alarms.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Verifica se um alarme está ativo
  bool isAlarmActive(String id) {
    final alarm = getAlarmById(id);
    return alarm?.isEnabled ?? false;
  }

  /// Limpa o erro
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Recarrega todos os alarmes
  Future<void> refresh() async {
    await loadAlarms();
  }

  // ==================== MÉTODOS PRIVADOS ====================

  /// Salva os alarmes e agenda o alarme especificado
  Future<void> _saveAndSchedule(TcAlarmEntity alarm) async {
    await _localStorage.saveAlarms(_alarms);

    if (alarm.isEnabled) {
      await _rescheduleAlarm(alarm);
    }

    notifyListeners();
  }

  /// Reagenda um alarme (cancela o anterior e cria um novo)
  Future<void> _rescheduleAlarm(TcAlarmEntity alarm) async {
    try {
      // Garantir que o áudio está em cache
      final audioPath = await _audioCache.ensureCached(alarm.musicUrl);

      // Cancelar alarme anterior (se existir)
      await _scheduler.cancelAlarm(alarm.id);

      // Agendar novo alarme
      await _scheduler.scheduleAlarm(alarm, audioPath);
    } catch (e) {
      debugPrint('TcAlarmRepository: Erro ao reagendar alarme ${alarm.id}: $e');
      rethrow;
    }
  }

  // ==================== MÉTODOS DE UTILIDADE ====================

  /// Obtém alarmes ordenados por horário
  List<TcAlarmEntity> get alarmsSortedByTime {
    final sorted = List<TcAlarmEntity>.from(_alarms);
    sorted.sort((a, b) {
      final timeA = a.hour * 60 + a.minute;
      final timeB = b.hour * 60 + b.minute;
      return timeA.compareTo(timeB);
    });
    return sorted;
  }

  /// Obtém apenas alarmes ativos
  List<TcAlarmEntity> get activeAlarms {
    return _alarms.where((a) => a.isEnabled).toList();
  }

  /// Obtém apenas alarmes inativos
  List<TcAlarmEntity> get inactiveAlarms {
    return _alarms.where((a) => !a.isEnabled).toList();
  }

  /// Verifica se há algum alarme ativo
  bool get hasActiveAlarms {
    return _alarms.any((a) => a.isEnabled);
  }

  /// Verifica se todos os alarmes estão ativos
  bool get allAlarmsActive {
    if (_alarms.isEmpty) return false;
    return _alarms.every((a) => a.isEnabled);
  }

  /// Debug: imprime informações dos alarmes
  void debugPrintAlarms() {
    debugPrint('TcAlarmRepository: ${_alarms.length} alarme(s):');
    for (final alarm in _alarms) {
      debugPrint('  - ${alarm.formattedTime} | ${alarm.title} | ${alarm.isEnabled ? 'ON' : 'OFF'}');
    }
  }

  // ==================== AUTO-STOP: RINGSTREAM + TIMER ====================

  /// Inicia o listener do ringStream para detectar quando alarmes tocam
  void _startAlarmRingingListener() {
    _ringStreamSubscription = _scheduler.ringStream.listen((alarmSettings) {
      _handleAlarmRinging(alarmSettings);
    });
    debugPrint('TcAlarmRepository: Listener de ringStream iniciado');
  }

  /// Quando um alarme toca, inicia um timer para pará-lo automaticamente
  void _handleAlarmRinging(dynamic alarmSettings) {
    try {
      // Extrair o ID do alarme (hash do id original)
      final alarmIdHash = alarmSettings.id as int;

      // Buscar o alarme correspondente pelo ID original
      // Nota: o alarm package usa hash do ID, então precisamos encontrar pelo contexto
      TcAlarmEntity? matchingAlarm;
      for (final alarm in _alarms) {
        if (alarm.id.hashCode == alarmIdHash) {
          matchingAlarm = alarm;
          break;
        }
      }

      if (matchingAlarm == null) {
        debugPrint('TcAlarmRepository: Alarme $alarmIdHash não encontrado na lista');
        return;
      }

      final durationSec = matchingAlarm.musicDurationSec;
      final alarmId = matchingAlarm.id; // ID original (string)
      debugPrint('TcAlarmRepository: Alarme ${matchingAlarm.title} tocando - duração: ${durationSec}s');

      // Cancelar timer anterior se existir
      _activeTimers[alarmIdHash]?.cancel();

      // Criar novo timer para parar o alarme automaticamente
      _activeTimers[alarmIdHash] = Timer(Duration(seconds: durationSec), () async {
        debugPrint('TcAlarmRepository: Timer finalizado - parando alarme ${matchingAlarm!.title}');
        await _scheduler.stopRinging(alarmId); // Passa o ID original (string)
        _activeTimers.remove(alarmIdHash);
      });

      debugPrint('TcAlarmRepository: Timer de ${durationSec}s iniciado para alarme $alarmIdHash');
    } catch (e) {
      debugPrint('TcAlarmRepository: Erro ao processar alarme tocando: $e');
    }
  }

  @override
  void dispose() {
    debugPrint('TcAlarmRepository: Disposed');

    // Cancelar subscription do ringStream
    _ringStreamSubscription?.cancel();

    // Cancelar todos os timers ativos
    for (final timer in _activeTimers.values) {
      timer.cancel();
    }
    _activeTimers.clear();

    super.dispose();
  }
}
