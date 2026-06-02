// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medita_bk/domain/models/traffic_control/index.dart';

/// Service para persistência local de alarmes usando SharedPreferences
class TcLocalStorageService {
  static const String _alarmsKey = 'tc_alarms';

  late SharedPreferences _prefs;
  bool _isInitialized = false;

  /// Inicializa o SharedPreferences
  Future<void> init() async {
    if (_isInitialized) return;

    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  /// Carrega todos os alarmes salvos
  Future<List<TcAlarmEntity>> loadAlarms() async {
    await init();

    final jsonList = _prefs.getStringList(_alarmsKey) ?? [];

    return jsonList.map((jsonString) {
      try {
        final map = jsonDecode(jsonString) as Map<String, dynamic>;
        return TcAlarmEntity.fromMap(map);
      } catch (e) {
        // Se falhar ao deserializar, retorna null e será removido
        print('Erro ao deserializar alarme: $e');
        return null;
      }
    }).whereType<TcAlarmEntity>().toList();
  }

  /// Salva todos os alarmes
  Future<void> saveAlarms(List<TcAlarmEntity> alarms) async {
    await init();

    final jsonList = alarms.map((alarm) {
      return jsonEncode(alarm.toMap());
    }).toList();

    await _prefs.setStringList(_alarmsKey, jsonList);
  }

  /// Salva um único alarme (adiciona ou atualiza)
  Future<void> saveAlarm(TcAlarmEntity alarm) async {
    final alarms = await loadAlarms();

    final index = alarms.indexWhere((a) => a.id == alarm.id);

    if (index != -1) {
      alarms[index] = alarm;
    } else {
      alarms.add(alarm);
    }

    await saveAlarms(alarms);
  }

  /// Remove um alarme pelo ID
  Future<void> deleteAlarm(String id) async {
    final alarms = await loadAlarms();
    alarms.removeWhere((a) => a.id == id);
    await saveAlarms(alarms);
  }

  /// Limpa todos os alarmes
  Future<void> clearAllAlarms() async {
    await init();
    await _prefs.remove(_alarmsKey);
  }

  /// Verifica se há alarmes salvos
  Future<bool> hasAlarms() async {
    final alarms = await loadAlarms();
    return alarms.isNotEmpty;
  }

  /// Conta quantos alarmes estão salvos
  Future<int> countAlarms() async {
    final alarms = await loadAlarms();
    return alarms.length;
  }

  /// Conta quantos alarmes estão ativos
  Future<int> countActiveAlarms() async {
    final alarms = await loadAlarms();
    return alarms.where((a) => a.isEnabled).length;
  }
}
