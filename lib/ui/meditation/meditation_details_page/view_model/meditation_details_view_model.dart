import 'package:flutter/material.dart';
import 'package:medita_b_k/data/models/firebase/meditation_model.dart';
import 'package:medita_b_k/data/repositories/meditation_repository.dart';
import 'package:medita_b_k/data/repositories/user_repository.dart';
import 'package:medita_b_k/core/utils/network_utils.dart';

class MeditationDetailsViewModel extends ChangeNotifier {
  final MeditationRepository _meditationRepository;
  final UserRepository _userRepository;

  MeditationDetailsViewModel({
    required MeditationRepository meditationRepository,
    required UserRepository userRepository,
  })  : _meditationRepository = meditationRepository,
        _userRepository = userRepository;

  // ========== STATE ==========

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  MeditationModel? _meditationDoc;
  MeditationModel? get meditationDoc => _meditationDoc;

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  bool _isAudioDownloaded = false;
  bool get isAudioDownloaded => _isAudioDownloaded;

  int _numPlayed = 0;
  int get numPlayed => _numPlayed;

  int _numLiked = 0;
  int get numLiked => _numLiked;

  // ========== INITIALIZATION ==========

  Future<void> loadMeditationDetails(
    String meditationId,
    List<String> userFavorites,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      // Load meditation document
      _meditationDoc = await _meditationRepository.getMeditationById(meditationId);

      if (_meditationDoc == null) {
        _setError('Meditação não encontrada');
        return;
      }

      // Check if audio is downloaded
      final audioPath = _meditationDoc!.audioUrl;
      if (audioPath.isNotEmpty) {
        // _isAudioDownloaded = await actions.isAudioDownloaded(audioPath);
        _isAudioDownloaded = false; // Temporary: assume not downloaded
      }

      // Check if meditation is in favorites
      _isFavorite = userFavorites.contains(_meditationDoc!.id);

      // Initialize counters
      _numPlayed = _meditationDoc!.numPlayed;
      _numLiked = _meditationDoc!.numLiked;

      notifyListeners();
    } catch (e) {
      _setError('Erro ao carregar detalhes: $e');
    } finally {
      _setLoading(false);
    }
  }

  // ========== COMMANDS ==========

  /// Toggles favorite status and updates Firestore
  Future<void> toggleFavoriteCommand(
    String meditationId,
    String userId,
  ) async {
    if (_meditationDoc == null) return;

    final newFavoriteState = !_isFavorite; // Move outside try block

    try {
      _isFavorite = newFavoriteState;

      if (newFavoriteState) {
        // Add to favorites
        _numLiked++;
        await _meditationRepository.incrementLikeCount(meditationId);
        await _userRepository.addToFavorites(userId, meditationId);
      } else {
        // Remove from favorites
        _numLiked--;
        await _meditationRepository.decrementLikeCount(meditationId);
        await _userRepository.removeFromFavorites(userId, meditationId);
      }

      notifyListeners();
    } catch (e) {
      // Revert on error
      _isFavorite = !_isFavorite;
      if (newFavoriteState) {
        _numLiked--;
      } else {
        _numLiked++;
      }
      _setError('Erro ao atualizar favorito: $e');
      notifyListeners();
    }
  }

  /// Increments play count before playing
  Future<void> incrementPlayCountCommand(String meditationId) async {
    if (_meditationDoc == null) return;

    try {
      _numPlayed++;
      await _meditationRepository.incrementPlayCount(meditationId);
      notifyListeners();
    } catch (e) {
      _numPlayed--; // Revert on error
      _setError('Erro ao atualizar contador: $e');
      notifyListeners();
    }
  }

  /// Checks internet access before playing
  Future<bool> checkInternetAccess() async {
    try {
      final hasInternet = await NetworkUtils.hasInternetAccess();
      return hasInternet;
    } catch (e) {
      return false;
    }
  }

  // ========== HELPER METHODS ==========

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
