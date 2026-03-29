import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:medita_bk/data/repositories/tc_music_repository.dart';
import 'package:medita_bk/domain/models/traffic_control/tc_music_entity.dart';

/// ViewModel do seletor de músicas do Traffic Control
///
/// Permite buscar, filtrar e ouvir preview das músicas disponíveis.
class TcMusicPickerViewModel extends ChangeNotifier {
  final TcMusicRepository _repository;
  final AudioPlayer _previewPlayer = AudioPlayer();

  String _searchQuery = '';
  String? _selectedCategory;
  TcMusicEntity? _selectedMusic;
  String? _previewingMusicId;
  bool _isPlaying = false;
  bool _isLoadingPreview = false;
  double _previewProgress = 0.0;
  Duration? _previewDuration;
  Duration? _previewPosition;

  // Getters
  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;
  TcMusicEntity? get selectedMusic => _selectedMusic;
  String? get previewingMusicId => _previewingMusicId;
  bool get isPlaying => _isPlaying;
  bool get isLoadingPreview => _isLoadingPreview;
  double get previewProgress => _previewProgress;
  Duration? get previewDuration => _previewDuration;
  Duration? get previewPosition => _previewPosition;

  bool get isLoading => _repository.isLoading;
  String? get error => _repository.error;

  /// Lista de músicas filtradas
  List<TcMusicEntity> get musics {
    var filtered = _repository.musics;

    // Filtro de busca
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((m) =>
              m.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              (m.artist?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
                  false))
          .toList();
    }

    // Filtro de categoria
    if (_selectedCategory != null) {
      filtered = filtered.where((m) => m.category == _selectedCategory).toList();
    }

    return filtered;
  }

  /// Lista de categorias disponíveis
  List<String> get categories {
    return _repository.categories;
  }

  TcMusicPickerViewModel({required TcMusicRepository repository})
      : _repository = repository {
    _initAudioPlayer();
    // Escuta mudanças do repository (ex: quando músicas terminam de carregar)
    _repository.addListener(_onRepositoryChanged);
  }

  void _onRepositoryChanged() {
    notifyListeners();
  }

  /// Inicializa o audio player
  void _initAudioPlayer() {
    // Listen para mudanças de posição
    _previewPlayer.positionStream.listen((position) {
      _previewPosition = position;
      if (_previewDuration != null && _previewDuration!.inMilliseconds > 0) {
        _previewProgress =
            position.inMilliseconds / _previewDuration!.inMilliseconds;
      }
      notifyListeners();
    });

    // Listen para mudanças de duração
    _previewPlayer.durationStream.listen((duration) {
      _previewDuration = duration;
      notifyListeners();
    });

    // Listen para mudanças de estado
    _previewPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      _isLoadingPreview = state.processingState == ProcessingState.loading ||
          state.processingState == ProcessingState.buffering;

      // Se terminou de tocar, reseta
      if (state.processingState == ProcessingState.completed) {
        _isPlaying = false;
        _previewingMusicId = null;
        _previewProgress = 0.0;
      }

      notifyListeners();
    });
  }

  /// Atualiza query de busca
  void search(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  /// Filtra por categoria
  void filterByCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// Limpa filtros
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    notifyListeners();
  }

  /// Seleciona uma música
  void selectMusic(TcMusicEntity music) {
    _selectedMusic = music;
    notifyListeners();
  }

  /// Alterna preview de áudio (play/pause)
  Future<void> togglePreview(TcMusicEntity music) async {
    try {
      // Se está tocando a mesma música, pausa
      if (_previewingMusicId == music.id && _isPlaying) {
        await _previewPlayer.pause();
        _isPlaying = false;
        notifyListeners();
        return;
      }

      // Se está tocando outra música, para e troca
      if (_previewingMusicId != music.id) {
        await _previewPlayer.stop();
        _previewingMusicId = music.id;
        _previewProgress = 0.0;
        _previewDuration = null;
        _previewPosition = null;

        _isLoadingPreview = true;
        notifyListeners();

        // Assets locais (iOS) usam setAsset(), URLs (Android) usam setUrl()
        if (music.audioUrl.startsWith('assets/')) {
          await _previewPlayer.setAsset(music.audioUrl);
        } else {
          await _previewPlayer.setUrl(music.audioUrl);
        }
      }

      // Toca
      await _previewPlayer.play();
      _isPlaying = true;
      _isLoadingPreview = false;
      notifyListeners();
    } catch (e) {
      debugPrint('TcMusicPickerVM: Erro ao tocar preview: $e');
      _isPlaying = false;
      _isLoadingPreview = false;
      _previewingMusicId = null;
      notifyListeners();
    }
  }

  /// Para o preview
  Future<void> stopPreview() async {
    await _previewPlayer.stop();
    _isPlaying = false;
    _previewingMusicId = null;
    _previewProgress = 0.0;
    _previewDuration = null;
    _previewPosition = null;
    notifyListeners();
  }

  /// Recarrega músicas
  Future<void> refresh() async {
    await _repository.loadMusics();
  }

  /// Retorna a música selecionada
  TcMusicEntity? confirmSelection() {
    return _selectedMusic;
  }

  @override
  void dispose() {
    _repository.removeListener(_onRepositoryChanged);
    _previewPlayer.dispose();
    debugPrint('TcMusicPickerVM: Disposed');
    super.dispose();
  }
}
