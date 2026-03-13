import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:medita_bk/domain/models/traffic_control/index.dart';

/// Service para agendar e gerenciar alarmes usando o pacote alarm
class TcAlarmSchedulerService {
  bool _isInitialized = false;

  /// Inicializa o serviço de alarmes
  Future<void> init() async {
    if (_isInitialized) return;

    await Alarm.init();
    _isInitialized = true;

    print('TcAlarmScheduler: Serviço inicializado');
  }

  /// Agenda um alarme
  ///
  /// [alarm] - Entidade do alarme com configurações
  /// [audioPath] - Path local do arquivo de áudio (já em cache)
  Future<void> scheduleAlarm(TcAlarmEntity alarm, String audioPath) async {
    await init();

    try {
      final now = DateTime.now();
      DateTime scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        alarm.hour,
        alarm.minute,
      );

      // Se o horário já passou hoje, agenda para amanhã
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      print('TcAlarmScheduler: Agendando alarme com áudio: $audioPath');
      print('TcAlarmScheduler: Horário agendado: $scheduledTime');

      // Determina qual path usar baseado na origem do áudio
      String finalAudioPath;

      // Verifica se é um asset (começa com 'assets/')
      final isAsset = audioPath.startsWith('assets/');

      if (isAsset) {
        // Path já é um asset (iOS ou asset manual)
        finalAudioPath = audioPath;
        print('TcAlarmScheduler: Usando asset: $finalAudioPath');
      } else {
        // Path é arquivo local (Android)
        if (Platform.isAndroid) {
          // Valida o arquivo de áudio
          final audioFile = File(audioPath);
          final fileExists = await audioFile.exists();
          print('TcAlarmScheduler: [Android] Arquivo local existe? $fileExists');

          if (fileExists) {
            final fileSize = await audioFile.length();
            final permissions = await audioFile.stat();
            print('TcAlarmScheduler: [Android] Tamanho: $fileSize bytes');
            print('TcAlarmScheduler: [Android] Permissões: ${permissions.mode}');
            finalAudioPath = audioFile.absolute.path;
          } else {
            print('TcAlarmScheduler: [Android] ERRO - Arquivo não encontrado!');
            // Fallback para asset padrão
            finalAudioPath = 'assets/audios/gongo.mp3';
          }
        } else {
          // iOS com path não-asset (não deveria acontecer, mas fallback)
          print('TcAlarmScheduler: [iOS] AVISO - Path não-asset detectado, usando fallback');
          finalAudioPath = 'assets/audios/gongo.mp3';
        }
      }

      // Configuração do alarme
      final alarmSettings = AlarmSettings(
        id: alarm.id.hashCode,
        dateTime: scheduledTime,
        assetAudioPath: finalAudioPath,
        loopAudio: false, // Toca apenas uma vez até o final
        vibrate: false, // Apenas música, sem vibração
        volumeSettings: VolumeSettings.fixed(
          volume: 1.0, // Volume máximo desde o início
        ),
        notificationSettings: NotificationSettings(
          title: alarm.title,
          body: 'Hora de meditar 🧘',
          stopButton: 'Parar',
          icon: 'notification_icon',
        ),
        warningNotificationOnKill: true,
      );

      await Alarm.set(alarmSettings: alarmSettings);

      print('TcAlarmScheduler: Alarme agendado - ${alarm.title} às ${alarm.formattedTime}');
    } catch (e) {
      print('TcAlarmScheduler: Erro ao agendar alarme: $e');
      rethrow;
    }
  }

  /// Cancela um alarme pelo ID
  Future<void> cancelAlarm(String alarmId) async {
    await init();

    try {
      final alarmIdHash = alarmId.hashCode;
      await Alarm.stop(alarmIdHash);

      print('TcAlarmScheduler: Alarme cancelado - ID: $alarmId');
    } catch (e) {
      print('TcAlarmScheduler: Erro ao cancelar alarme: $e');
      rethrow;
    }
  }

  /// Cancela todos os alarmes
  Future<void> cancelAllAlarms() async {
    await init();

    try {
      await Alarm.stopAll();
      print('TcAlarmScheduler: Todos os alarmes cancelados');
    } catch (e) {
      print('TcAlarmScheduler: Erro ao cancelar todos os alarmes: $e');
      rethrow;
    }
  }

  /// Verifica se um alarme está agendado
  Future<bool> isAlarmScheduled(String alarmId) async {
    await init();

    try {
      final alarmIdHash = alarmId.hashCode;
      final alarmSettings = await Alarm.getAlarm(alarmIdHash);
      return alarmSettings != null;
    } catch (e) {
      print('TcAlarmScheduler: Erro ao verificar alarme: $e');
      return false;
    }
  }

  /// Obtém as configurações de um alarme agendado
  Future<AlarmSettings?> getAlarmSettings(String alarmId) async {
    final alarmIdHash = alarmId.hashCode;
    return Alarm.getAlarm(alarmIdHash);
  }

  /// Obtém todos os alarmes agendados
  Future<List<AlarmSettings>> getAllScheduledAlarms() async {
    return Alarm.getAlarms();
  }

  /// Stream de alarmes que estão tocando
  Stream<AlarmSettings> get ringStream => Alarm.ringStream.stream;

  /// Para um alarme que está tocando
  Future<void> stopRinging(String alarmId) async {
    await init();

    try {
      final alarmIdHash = alarmId.hashCode;
      await Alarm.stop(alarmIdHash);
      print('TcAlarmScheduler: Alarme parado - ID: $alarmId');
    } catch (e) {
      print('TcAlarmScheduler: Erro ao parar alarme: $e');
      rethrow;
    }
  }

  /// Reagenda um alarme (útil após edição)
  Future<void> rescheduleAlarm(TcAlarmEntity alarm, String audioPath) async {
    await cancelAlarm(alarm.id);
    await scheduleAlarm(alarm, audioPath);
  }

  /// Verifica quantos alarmes estão atualmente agendados
  Future<int> getScheduledAlarmsCount() async {
    final alarms = await Alarm.getAlarms();
    return alarms.length;
  }

  /// Debug: lista todos os alarmes agendados
  Future<void> debugPrintScheduledAlarms() async {
    final alarms = await Alarm.getAlarms();

    if (alarms.isEmpty) {
      print('TcAlarmScheduler: Nenhum alarme agendado');
      return;
    }

    print('TcAlarmScheduler: ${alarms.length} alarme(s) agendado(s):');
    for (final alarm in alarms) {
      print('  - ID: ${alarm.id}, Horário: ${alarm.dateTime}, Título: ${alarm.notificationSettings.title}');
    }
  }
}
