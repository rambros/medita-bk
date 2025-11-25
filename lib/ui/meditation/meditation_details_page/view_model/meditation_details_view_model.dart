import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/core/utils/network_utils.dart';

class MeditationDetailsViewModel extends ChangeNotifier {
  // ========== STATE ==========

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  MeditationsRecord? _meditationDoc;
  MeditationsRecord? get meditationDoc => _meditationDoc;

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
    DocumentReference meditationDocRef,
    List<String> userFavorites,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      // Load meditation document
      _meditationDoc = await MeditationsRecord.getDocumentOnce(meditationDocRef);

      if (_meditationDoc == null) {
        _setError('Meditação não encontrada');
        return;
      }

      // Check if audio is downloaded
      final audioPath = _meditationDoc!.audioUrl;
      if (audioPath.isNotEmpty) {
        // TODO: Migrate isAudioDownloaded to AudioService
        // _isAudioDownloaded = await actions.isAudioDownloaded(audioPath);
        _isAudioDownloaded = false; // Temporary: assume not downloaded
      }

      // Check if meditation is in favorites
      _isFavorite = userFavorites.contains(_meditationDoc!.documentId);

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
    DocumentReference meditationDocRef,
    DocumentReference userDocRef,
    String meditationId,
  ) async {
    if (_meditationDoc == null) return;

    try {
      final newFavoriteState = !_isFavorite;
      _isFavorite = newFavoriteState;

      if (newFavoriteState) {
        // Add to favorites
        _numLiked++;
        await meditationDocRef.update(createMeditationsRecordData(
          numLiked: _numLiked,
        ));

        await userDocRef.update({
          'favorites': FieldValue.arrayUnion([meditationId]),
        });
      } else {
        // Remove from favorites
        _numLiked--;
        await meditationDocRef.update(createMeditationsRecordData(
          numLiked: _numLiked,
        ));

        await userDocRef.update({
          'favorites': FieldValue.arrayRemove([meditationId]),
        });
      }

      notifyListeners();
    } catch (e) {
      // Revert on error
      _isFavorite = !_isFavorite;
      _setError('Erro ao atualizar favorito: $e');
      notifyListeners();
    }
  }

  /// Increments play count before playing
  Future<void> incrementPlayCountCommand(DocumentReference meditationDocRef) async {
    if (_meditationDoc == null) return;

    try {
      _numPlayed++;
      await meditationDocRef.update(createMeditationsRecordData(
        numPlayed: _numPlayed,
      ));
      notifyListeners();
    } catch (e) {
      _setError('Erro ao atualizar contador: $e');
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

  @override
  void dispose() {
    super.dispose();
  }
}
