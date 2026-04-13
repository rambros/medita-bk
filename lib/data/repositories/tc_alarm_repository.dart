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
  bool _isRinging = false;
  String? _ringingAlarmId;

  // Listener do ringStream para detectar quando alarmes tocam
  StreamSubscription? _ringStreamSubscription;

  // Getters públicos
  List<TcAlarmEntity> get alarms => List.unmodifiable(_alarms);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasAlarms => _alarms.isNotEmpty;
  int get alarmsCount => _alarms.length;
  int get activeAlarmsCount => _alarms.where((a) => a.isEnabled).length;
  bool get isRinging => _isRinging;
  String? get ringingAlarmId => _ringingAlarmId;

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
    // Limpa estado de "tocando" ao recarregar — pode ter ficado travado quando o app
    // estava em background e o Future.delayed foi suspenso pelo Android (Doze/battery opt.)
    _isRinging = false;
    _ringingAlarmId = null;
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
      debugPrint('TcAlarmRepository: ===== REAGENDAMENTO =====');
      debugPrint('TcAlarmRepository: Alarme: ${alarm.title}');
      debugPrint('TcAlarmRepository: Horário configurado: ${alarm.formattedTime}');
      debugPrint('TcAlarmRepository: DateTime.now() no momento do reagendamento: ${DateTime.now()}');

      // Garantir que o áudio está em cache
      final audioPath = await _audioCache.ensureCached(alarm.musicUrl);

      // Cancelar alarme anterior (se existir)
      await _scheduler.cancelAlarm(alarm.id);

      // Agendar novo alarme
      await _scheduler.scheduleAlarm(alarm, audioPath);

      debugPrint('TcAlarmRepository: ============================');
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

  /// Debug: imprime alarmes agendados no scheduler
  Future<void> debugPrintScheduledAlarms() async {
    debugPrint('\n2. ALARMES AGENDADOS NO SISTEMA:');
    await _scheduler.debugPrintScheduledAlarms();
  }

  // ==================== AUTO-STOP: RINGSTREAM + TIMER ====================

  /// Inicia o listener do ringStream para detectar quando alarmes tocam
  void _startAlarmRingingListener() {
    _ringStreamSubscription = _scheduler.ringStream.listen((alarmSettings) {
      _handleAlarmRinging(alarmSettings);
    });
    debugPrint('TcAlarmRepository: Listener de ringStream iniciado');
  }

  /// Quando um alarme toca, atualiza UI e agenda próxima ocorrência imediatamente.
  ///
  /// IMPORTANTE: O reagendamento é feito NA HORA em que o alarme dispara, sem esperar
  /// a música terminar. Isso evita o bug em que o app fica em background e o
  /// Future.delayed é suspenso pelo Android (Doze/battery optimization), fazendo
  /// o alarme nunca ser reagendado.
  ///
  /// Não chamamos cancelAlarm antes de scheduleAlarm aqui porque isso pararia
  /// o áudio que está tocando. O scheduleAlarm sozinho agenda a próxima ocorrência
  /// (que será amanhã, pois o horário de hoje já passou).
  void _handleAlarmRinging(dynamic alarmSettings) {
    try {
      final alarmIdHash = alarmSettings.id as int;

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

      final alarmId = matchingAlarm.id;
      debugPrint('TcAlarmRepository: Alarme ${matchingAlarm.title} tocando');

      // Atualizar UI para mostrar que alarme está tocando
      _isRinging = true;
      _ringingAlarmId = alarmId;
      notifyListeners();

      // Reagendar IMEDIATAMENTE para a próxima ocorrência — não espera a música terminar.
      // scheduleAlarm calcula a próxima data: se o horário de hoje já passou (acabou de tocar),
      // ele agenda para amanhã (ou próximo dia da semana permitido).
      _scheduleNextOccurrenceOnly(matchingAlarm);

      // Timer apenas para limpar o estado de UI após a música terminar.
      // Se o app for suspenso antes disso, loadAlarms() limpa o estado ao reabrir.
      final durationSec = matchingAlarm.musicDurationSec + 2;
      Future.delayed(Duration(seconds: durationSec), () {
        if (_ringingAlarmId == alarmId) {
          _isRinging = false;
          _ringingAlarmId = null;
          notifyListeners();
          debugPrint('TcAlarmRepository: Estado de tocando limpo para: ${matchingAlarm?.title}');
        }
      });

    } catch (e) {
      debugPrint('TcAlarmRepository: Erro ao processar alarme tocando: $e');
    }
  }

  /// Agenda a próxima ocorrência do alarme SEM cancelar o que está tocando.
  ///
  /// Chamado imediatamente quando um alarme dispara para garantir que o próximo
  /// toque seja agendado mesmo se o app for para background em seguida.
  Future<void> _scheduleNextOccurrenceOnly(TcAlarmEntity alarm) async {
    try {
      if (!alarm.isEnabled) return;
      final audioPath = await _audioCache.ensureCached(alarm.musicUrl);
      // Não chama cancelAlarm — apenas agenda a próxima ocorrência.
      // Como o horário de hoje já passou (o alarme acabou de tocar), scheduleAlarm
      // automaticamente calcula o próximo dia.
      await _scheduler.scheduleAlarm(alarm, audioPath);
      debugPrint('TcAlarmRepository: Próxima ocorrência agendada imediatamente: ${alarm.title}');
    } catch (e) {
      debugPrint('TcAlarmRepository: Erro ao agendar próxima ocorrência: $e');
    }
  }

  /// Para o alarme manualmente (ação do usuário)
  Future<void> stopRingingManually() async {
    if (_ringingAlarmId != null) {
      final alarmId = _ringingAlarmId!;

      // Parar som (também remove a notificação)
      await _scheduler.stopRinging(alarmId);
      debugPrint('TcAlarmRepository: Alarme $alarmId parado manualmente');

      // Reagendar para o próximo dia
      final matchingAlarm = getAlarmById(alarmId);
      if (matchingAlarm != null && matchingAlarm.isEnabled) {
        debugPrint('TcAlarmRepository: Reagendando alarme após parar manualmente');
        await _rescheduleAlarm(matchingAlarm);
      }

      // Atualizar estado
      _isRinging = false;
      _ringingAlarmId = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    debugPrint('TcAlarmRepository: Disposed');

    // Cancelar subscription do ringStream
    _ringStreamSubscription?.cancel();

    super.dispose();
  }
}
