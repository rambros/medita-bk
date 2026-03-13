import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:medita_bk/domain/models/traffic_control/index.dart';
import 'package:medita_bk/data/services/tc_music_api_service.dart';
import 'package:medita_bk/data/services/tc_local_music_service.dart';

/// Repository responsável por gerenciar músicas do Traffic Control
///
/// Carrega músicas ativas do Firestore e fornece métodos de busca/filtro.
/// Segue o padrão ChangeNotifier para notificar a UI sobre mudanças.
class TcMusicRepository extends ChangeNotifier {
  final TcMusicApiService _apiService;

  List<TcMusicEntity> _musics = [];
  bool _isLoading = false;
  String? _error;

  // Getters públicos
  List<TcMusicEntity> get musics => List.unmodifiable(_musics);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMusics => _musics.isNotEmpty;
  int get musicsCount => _musics.length;

  TcMusicRepository({required TcMusicApiService apiService})
      : _apiService = apiService {
    loadMusics();
  }

  /// Carrega músicas baseado na plataforma
  ///
  /// - iOS: Carrega músicas locais dos assets (7 músicas pré-definidas)
  /// - Android: Carrega do Firestore (músicas ilimitadas)
  Future<void> loadMusics() async {
    debugPrint('TcMusicRepository: Iniciando carregamento de músicas...');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (Platform.isIOS) {
        // iOS: Usar apenas músicas locais dos assets
        _musics = TcLocalMusicService.getLocalMusics();
        debugPrint('TcMusicRepository: ${_musics.length} música(s) local(is) carregada(s) (iOS)');
        if (_musics.isNotEmpty) {
          debugPrint('TcMusicRepository: Primeira música - ${_musics.first.title}');
        }
      } else {
        // Android: Carregar do Firestore (comportamento atual)
        _musics = await _apiService.getActiveMusics();
        debugPrint('TcMusicRepository: ${_musics.length} música(s) carregada(s) do Firestore (Android)');
        if (_musics.isNotEmpty) {
          debugPrint('TcMusicRepository: Primeira música - ${_musics.first.title}');
        } else {
          debugPrint('TcMusicRepository: AVISO - Nenhuma música ativa encontrada no Firestore!');
        }
      }

      _error = null;
    } catch (e) {
      _error = 'Erro ao carregar músicas: $e';
      debugPrint('TcMusicRepository: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Recarrega as músicas do servidor
  Future<void> refresh() async {
    await loadMusics();
  }

  /// Obtém uma música específica pelo ID
  TcMusicEntity? getMusicById(String id) {
    try {
      return _musics.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Busca músicas por título (case-insensitive)
  List<TcMusicEntity> searchByTitle(String query) {
    if (query.isEmpty) return _musics;

    final lowerQuery = query.toLowerCase();
    return _musics.where((music) {
      return music.title.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Filtra músicas por categoria
  List<TcMusicEntity> filterByCategory(String? category) {
    if (category == null || category.isEmpty) return _musics;

    return _musics.where((music) {
      return music.category == category;
    }).toList();
  }

  /// Busca e filtra músicas (combina título e categoria)
  List<TcMusicEntity> searchAndFilter({
    String? searchQuery,
    String? category,
  }) {
    var results = _musics;

    // Filtrar por categoria primeiro
    if (category != null && category.isNotEmpty) {
      results = results.where((m) => m.category == category).toList();
    }

    // Depois buscar por título
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final lowerQuery = searchQuery.toLowerCase();
      results = results.where((m) {
        return m.title.toLowerCase().contains(lowerQuery);
      }).toList();
    }

    return results;
  }

  /// Obtém todas as categorias disponíveis (únicas)
  List<String> get categories {
    final cats = _musics
        .map((m) => m.category)
        .whereType<String>()
        .toSet()
        .toList();

    cats.sort();
    return cats;
  }

  /// Obtém músicas ordenadas por título
  List<TcMusicEntity> get musicsSortedByTitle {
    final sorted = List<TcMusicEntity>.from(_musics);
    sorted.sort((a, b) => a.title.compareTo(b.title));
    return sorted;
  }

  /// Obtém músicas ordenadas por duração
  List<TcMusicEntity> get musicsSortedByDuration {
    final sorted = List<TcMusicEntity>.from(_musics);
    sorted.sort((a, b) => a.durationSec.compareTo(b.durationSec));
    return sorted;
  }

  /// Obtém músicas de uma categoria específica
  List<TcMusicEntity> getMusicsByCategory(String category) {
    return _musics.where((m) => m.category == category).toList();
  }

  /// Verifica se uma música existe
  bool musicExists(String id) {
    return _musics.any((m) => m.id == id);
  }

  /// Conta músicas por categoria
  Map<String, int> get musicCountByCategory {
    final counts = <String, int>{};

    for (final music in _musics) {
      final category = music.category ?? 'Sem categoria';
      counts[category] = (counts[category] ?? 0) + 1;
    }

    return counts;
  }

  /// Limpa o erro
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Debug: imprime informações das músicas
  void debugPrintMusics() {
    debugPrint('TcMusicRepository: ${_musics.length} música(s):');
    for (final music in _musics) {
      debugPrint('  - ${music.title} | ${music.category ?? 'N/A'} | ${music.formattedDuration}');
    }
  }

  @override
  void dispose() {
    debugPrint('TcMusicRepository: Disposed');
    super.dispose();
  }
}
