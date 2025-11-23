import '/backend/api_requests/api_calls.dart';
import '/domain/models/video/video_model.dart';

class VideoRepository {
  Future<Channel?> getCanalViverMeditar() async {
    final response = await YouTubeGroup.canalViverMeditarCall.call();
    if (response.succeeded) {
      final items = response.jsonBody['items'] as List?;
      if (items != null && items.isNotEmpty) {
        return Channel.fromJson(items.first);
      }
    }
    return null;
  }

  Future<Channel?> getCanalBrahmaKumaris() async {
    print('VideoRepository: Calling getCanalBrahmaKumaris');
    final response = await YouTubeGroup.canalBrahmaKumarisCall.call();
    print('VideoRepository: BrahmaKumaris API response succeeded: ${response.succeeded}');
    print('VideoRepository: BrahmaKumaris API status code: ${response.statusCode}');
    if (response.succeeded) {
      final items = response.jsonBody['items'] as List?;
      print('VideoRepository: BrahmaKumaris items count: ${items?.length ?? 0}');
      if (items != null && items.isNotEmpty) {
        return Channel.fromJson(items.first);
      }
    }
    return null;
  }

  Future<VideoListResponse> getVideosCongresso({String? pageToken}) async {
    final response = await YouTubeGroup.videosCongressoCall.call(pageToken: pageToken);
    return _parseVideoListResponse(response);
  }

  Future<VideoListResponse> getVideosEntrevistas({String? pageToken}) async {
    print('VideoRepository: Calling getVideosEntrevistas with pageToken: $pageToken');
    final response = await YouTubeGroup.videosEntrevistasCall.call(pageToken: pageToken);
    print('VideoRepository: Entrevistas API response succeeded: ${response.succeeded}');
    print('VideoRepository: Entrevistas API status code: ${response.statusCode}');
    if (response.succeeded) {
      final items = response.jsonBody['items'] as List?;
      print('VideoRepository: Entrevistas items count: ${items?.length ?? 0}');
    }
    return _parseVideoListResponse(response);
  }

  Future<VideoListResponse> getVideosPalestras({String? pageToken}) async {
    print('VideoRepository: Calling getVideosPalestras with pageToken: $pageToken');
    final response = await YouTubeGroup.videosPalestrasCall.call(pageToken: pageToken);
    print('VideoRepository: Palestras API response succeeded: ${response.succeeded}');
    print('VideoRepository: Palestras API status code: ${response.statusCode}');
    if (response.succeeded) {
      final items = response.jsonBody['items'] as List?;
      print('VideoRepository: Palestras items count: ${items?.length ?? 0}');
    }
    return _parseVideoListResponse(response);
  }

  Future<VideoListResponse> getVideosCanalViverMeditar({String? pageToken}) async {
    final response = await YouTubeGroup.videosCanalViverMeditarCall.call(pageToken: pageToken);
    return _parseVideoListResponse(response);
  }

  Future<int> getTotalVideosPalestras() async {
    final response = await YouTubeGroup.getNumVideosPalestrasCall.call();
    if (response.succeeded) {
      return YouTubeGroup.getNumVideosPalestrasCall.totalVideosPlaylist(response.jsonBody) ?? 0;
    }
    return 0;
  }

  VideoListResponse _parseVideoListResponse(ApiCallResponse response) {
    if (response.succeeded) {
      final items = response.jsonBody['items'] as List?;
      final videos = items?.map((e) => Video.fromJson(e)).toList() ?? [];
      final nextPageToken = response.jsonBody['nextPageToken'] as String?;
      final totalResults = response.jsonBody['pageInfo']?['totalResults'] as int? ?? 0;
      return VideoListResponse(
        videos: videos,
        nextPageToken: nextPageToken,
        totalResults: totalResults,
      );
    }
    return VideoListResponse(videos: [], totalResults: 0);
  }
}
