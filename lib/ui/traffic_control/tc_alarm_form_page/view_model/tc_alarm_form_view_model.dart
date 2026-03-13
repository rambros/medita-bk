import 'package:flutter/material.dart';
import 'package:medita_bk/data/repositories/tc_alarm_repository.dart';
import 'package:medita_bk/data/repositories/tc_music_repository.dart';
import 'package:medita_bk/domain/models/traffic_control/tc_alarm_entity.dart';
import 'package:medita_bk/domain/models/traffic_control/tc_music_entity.dart';
import 'package:uuid/uuid.dart';

/// ViewModel do formulário de alarme do Traffic Control
///
/// Gerencia o estado do formulário para criar/editar alarmes.
class TcAlarmFormViewModel extends ChangeNotifier {
  final TcAlarmRepository _alarmRepository;
  final TcMusicRepository _musicRepository;
  final String? alarmId;

  // Controllers
  final titleController = TextEditingController();

  // Estado do formulário
  TimeOfDay _selectedTime = const TimeOfDay(hour: 7, minute: 0);
  TcMusicEntity? _selectedMusic;
  int _maxDurationSec = 0; // 0 = sem limite (em segundos)
  Set<int> _selectedDays = {}; // 1-7 (seg-dom)
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;
  String? _successMessage;
  String? _pendingMusicId; // ID da música que ainda precisa ser carregada

  // Getters
  TimeOfDay get selectedTime => _selectedTime;
  TcMusicEntity? get selectedMusic => _selectedMusic;
  int get maxDurationSec => _maxDurationSec;
  Set<int> get selectedDays => _selectedDays;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get isEditMode => alarmId != null && alarmId!.isNotEmpty;

  // Computed
  String get formattedTime {
    final hour = _selectedTime.hour.toString().padLeft(2, '0');
    final minute = _selectedTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get selectedMusicTitle => _selectedMusic?.title ?? 'Nenhuma música selecionada';

  String get daysDescription {
    if (_selectedDays.isEmpty) return 'Todo dia';
    if (_selectedDays.length == 7) return 'Todo dia';

    final dayNames = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    final selected = _selectedDays.toList()..sort();
    return selected.map((d) => dayNames[d - 1]).join(', ');
  }

  String get durationDescription {
    if (_maxDurationSec == 0) return 'Duração da música';
    final mins = _maxDurationSec ~/ 60;
    final secs = _maxDurationSec % 60;

    if (mins > 0 && secs > 0) {
      return '${mins}min ${secs}s';
    } else if (mins > 0) {
      return '${mins}min';
    } else {
      return '${secs}s';
    }
  }

  TcAlarmFormViewModel({
    required TcAlarmRepository alarmRepository,
    required TcMusicRepository musicRepository,
    this.alarmId,
  })  : _alarmRepository = alarmRepository,
        _musicRepository = musicRepository {
    // Listener para quando músicas carregarem
    _musicRepository.addListener(_onMusicRepositoryChanged);
  }

  /// Chamado quando o MusicRepository atualiza
  void _onMusicRepositoryChanged() {
    // Se temos uma música pendente e agora há músicas disponíveis
    if (_pendingMusicId != null && _selectedMusic == null && _musicRepository.musics.isNotEmpty) {
      debugPrint('TcAlarmFormVM: MusicRepository carregou! Tentando buscar música pendente: $_pendingMusicId');
      _selectedMusic = _musicRepository.getMusicById(_pendingMusicId!);

      if (_selectedMusic != null) {
        debugPrint('TcAlarmFormVM: ✅ Música encontrada - ${_selectedMusic!.title}');
        _pendingMusicId = null; // Limpa a pendência
        notifyListeners();
      } else {
        debugPrint('TcAlarmFormVM: ❌ Música $_pendingMusicId ainda não encontrada');
      }
    }
  }

  /// Inicializa o formulário
  Future<void> initialize() async {
    if (isEditMode) {
      await _loadAlarm();
    } else {
      // Valores padrão para novo alarme
      titleController.text = 'Meditação Matinal';
      _selectedTime = const TimeOfDay(hour: 7, minute: 0);
      // Duração padrão: duração da música (0 = sem limite) para ambas plataformas
      _maxDurationSec = 0;
    }
    notifyListeners();
  }

  /// Carrega alarme existente para edição
  Future<void> _loadAlarm() async {
    debugPrint('TcAlarmFormVM: _loadAlarm iniciado - alarmId: $alarmId');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final alarm = _alarmRepository.getAlarmById(alarmId!);

      if (alarm == null) {
        _errorMessage = 'Alarme não encontrado';
        debugPrint('TcAlarmFormVM: ERRO - Alarme não encontrado!');
        return;
      }

      debugPrint('TcAlarmFormVM: Alarme encontrado - ${alarm.title}, musicId: ${alarm.musicId}');

      // Preenche campos
      titleController.text = alarm.title;
      _selectedTime = TimeOfDay(hour: alarm.hour, minute: alarm.minute);
      _selectedDays = alarm.daysOfWeek.toSet();
      _maxDurationSec = alarm.maxDurationSec;

      // Busca música selecionada
      debugPrint('TcAlarmFormVM: Buscando música com ID: ${alarm.musicId}');
      debugPrint('TcAlarmFormVM: Músicas disponíveis no repository: ${_musicRepository.musics.length}');
      if (_musicRepository.musics.isNotEmpty) {
        debugPrint('TcAlarmFormVM: IDs das músicas: ${_musicRepository.musics.map((m) => m.id).join(", ")}');
      }

      _selectedMusic = _musicRepository.getMusicById(alarm.musicId);

      if (_selectedMusic != null) {
        debugPrint('TcAlarmFormVM: Música encontrada - ${_selectedMusic!.title}');
        _pendingMusicId = null; // Limpa qualquer pendência
      } else {
        debugPrint('TcAlarmFormVM: AVISO - Música não encontrada no repository!');
        debugPrint('TcAlarmFormVM: Guardando musicId como pendente - listener tentará carregar quando músicas estiverem disponíveis');
        _pendingMusicId = alarm.musicId; // Guarda para tentar novamente quando carregar
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Erro ao carregar alarme: $e';
      debugPrint('TcAlarmFormVM: EXCEPTION - $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners();
      debugPrint('TcAlarmFormVM: _loadAlarm finalizado - selectedMusic: ${_selectedMusic?.title ?? "null"}');
    }
  }

  /// Atualiza horário selecionado
  void setTime(TimeOfDay time) {
    _selectedTime = time;
    notifyListeners();
  }

  /// Atualiza música selecionada
  void setMusic(TcMusicEntity music) {
    debugPrint('TcAlarmFormVM: setMusic chamado - ${music.title}');
    _selectedMusic = music;
    notifyListeners();
  }

  /// Atualiza duração máxima (em segundos)
  void setMaxDuration(int seconds) {
    debugPrint('TcAlarmFormVM: setMaxDuration chamado - $seconds segundos');
    _maxDurationSec = seconds;
    notifyListeners();
  }

  /// Alterna seleção de um dia da semana
  void toggleDay(int day) {
    if (_selectedDays.contains(day)) {
      _selectedDays.remove(day);
    } else {
      _selectedDays.add(day);
    }
    notifyListeners();
  }

  /// Seleciona todos os dias
  void selectAllDays() {
    _selectedDays = {1, 2, 3, 4, 5, 6, 7};
    notifyListeners();
  }

  /// Seleciona apenas dias úteis
  void selectWeekdays() {
    _selectedDays = {1, 2, 3, 4, 5};
    notifyListeners();
  }

  /// Seleciona apenas finais de semana
  void selectWeekends() {
    _selectedDays = {6, 7};
    notifyListeners();
  }

  /// Limpa seleção de dias
  void clearDays() {
    _selectedDays = {};
    notifyListeners();
  }

  /// Valida formulário
  bool validate() {
    _errorMessage = null;

    if (titleController.text.trim().isEmpty) {
      _errorMessage = 'Título é obrigatório';
      notifyListeners();
      return false;
    }

    if (_selectedMusic == null) {
      _errorMessage = 'Selecione uma música';
      notifyListeners();
      return false;
    }

    return true;
  }

  /// Salva o alarme
  Future<bool> save() async {
    if (!validate()) {
      return false;
    }

    _isSaving = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final alarm = TcAlarmEntity(
        id: alarmId ?? const Uuid().v4(),
        title: titleController.text.trim(),
        hour: _selectedTime.hour,
        minute: _selectedTime.minute,
        musicId: _selectedMusic!.id,
        musicTitle: _selectedMusic!.title,
        musicUrl: _selectedMusic!.audioUrl,
        musicDurationSec: _selectedMusic!.durationSec,
        maxDurationSec: _maxDurationSec,
        isEnabled: true, // Novo alarme sempre começa ativo
        daysOfWeek: _selectedDays.toList()..sort(),
        createdAt: DateTime.now(),
      );

      if (isEditMode) {
        await _alarmRepository.updateAlarm(alarm);
        _successMessage = 'Alarme atualizado com sucesso!';
      } else {
        await _alarmRepository.createAlarm(alarm);
        _successMessage = 'Alarme criado com sucesso!';
      }

      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Erro ao salvar alarme: $e';
      debugPrint('TcAlarmFormVM: $_errorMessage');
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  /// Limpa mensagens
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _musicRepository.removeListener(_onMusicRepositoryChanged);
    titleController.dispose();
    debugPrint('TcAlarmFormVM: Disposed');
    super.dispose();
  }
}
