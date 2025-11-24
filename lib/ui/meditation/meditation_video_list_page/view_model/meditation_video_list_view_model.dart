import 'package:flutter/material.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MeditationVideoListViewModel extends ChangeNotifier {
  // ========== STATE ==========

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Channel data
  String? _channelTitle;
  String? get channelTitle => _channelTitle;

  String? _channelProfilePicture;
  String? get channelProfilePicture => _channelProfilePicture;

  String? _channelSubscribers;
  String? get channelSubscribers => _channelSubscribers;

  // Videos data
  List<dynamic> _videos = [];
  List<dynamic> get videos => _videos;

  int get videosCount => _videos.length;

  // ========== INITIALIZATION ==========

  Future<void> loadData() async {
    _setLoading(true);
    _clearError();

    try {
      // Load channel info and videos in parallel
      final results = await Future.wait([
        YouTubeGroup.canalBrahmaKumarisCall.call(),
        YouTubeGroup.videosMeditationsCall.call(),
      ]);

      final channelResponse = results[0];
      final videosResponse = results[1];

      // Extract channel data
      _channelTitle = YouTubeGroup.canalBrahmaKumarisCall.title(
        channelResponse.jsonBody,
      );
      _channelProfilePicture = YouTubeGroup.canalBrahmaKumarisCall.profilePicture(
        channelResponse.jsonBody,
      );
      _channelSubscribers = YouTubeGroup.canalBrahmaKumarisCall.subscribers(
        channelResponse.jsonBody,
      );

      // Extract videos list
      _videos = YouTubeGroup.videosMeditationsCall
              .items(
                videosResponse.jsonBody,
              )
              ?.toList() ??
          [];

      notifyListeners();
    } catch (e) {
      _setError('Erro ao carregar vídeos: $e');
    } finally {
      _setLoading(false);
    }
  }

  // ========== COMMANDS ==========

  /// Gets video ID from video item
  String? getVideoId(dynamic videoItem) {
    return getJsonField(
      videoItem,
      r'''$.snippet.resourceId.videoId''',
    )?.toString();
  }

  /// Gets video title from video item
  String? getVideoTitle(dynamic videoItem) {
    return getJsonField(
      videoItem,
      r'''$.snippet.title''',
    )?.toString();
  }

  /// Gets video thumbnail URL from video item
  String? getVideoThumbnail(dynamic videoItem) {
    return getJsonField(
      videoItem,
      r'''$.snippet.thumbnails.high.url''',
    )?.toString();
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
