import 'package:medita_b_k/ui/core/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

class YouTubeGroup {
  static String getBaseUrl() => 'https://www.googleapis.com';
  static Map<String, String> headers = {};
  static CanalViverMeditarCall canalViverMeditarCall = CanalViverMeditarCall();
  static CanalBrahmaKumarisCall canalBrahmaKumarisCall = CanalBrahmaKumarisCall();
  static VideosCongressoCall videosCongressoCall = VideosCongressoCall();
  static VideosEntrevistasCall videosEntrevistasCall = VideosEntrevistasCall();
  static VideosPalestrasCall videosPalestrasCall = VideosPalestrasCall();
  static GetNumVideosPalestrasCall getNumVideosPalestrasCall = GetNumVideosPalestrasCall();
  static VideosMeditationsCall videosMeditationsCall = VideosMeditationsCall();
  static VideosCanalViverMeditarCall videosCanalViverMeditarCall = VideosCanalViverMeditarCall();
}

class CanalViverMeditarCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = YouTubeGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'CanalViverMeditar',
      apiUrl: '$baseUrl/youtube/v3/channels',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'id': "UC13Vp3d9hlz6h1q4avzYF9A",
        'key': "AIzaSyBW4nFybqLOKz9o6hbW37BQactu-GlmA10",
        'part': "snippet, contentDetails, statistics",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? title(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.items[:].snippet.title''',
      ));
  String? profilePicture(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.items[:].snippet.thumbnails.default.url''',
      ));
  dynamic subscribers(dynamic response) => getJsonField(
        response,
        r'''$.items[:].statistics.subscriberCount''',
      );
  dynamic videos(dynamic response) => getJsonField(
        response,
        r'''$.items[:].statistics.videoCount''',
      );
  dynamic playlistId(dynamic response) => getJsonField(
        response,
        r'''$.items[:].contentDetails.relatedPlaylists.uploads''',
      );
}

class CanalBrahmaKumarisCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = YouTubeGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'CanalBrahmaKumaris',
      apiUrl: '$baseUrl/youtube/v3/channels',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'id': "UCiUPv5cFKeZuiJgkntsoOLQ",
        'key': "AIzaSyBW4nFybqLOKz9o6hbW37BQactu-GlmA10",
        'part': "snippet, contentDetails, statistics",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? title(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.items[:].snippet.title''',
      ));
  String? profilePicture(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.items[:].snippet.thumbnails.default.url''',
      ));
  String? subscribers(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.items[:].statistics.subscriberCount''',
      ));
  String? videos(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.items[:].statistics.videoCount''',
      ));
  String? playlistId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.items[:].contentDetails.relatedPlaylists.uploads''',
      ));
}

class VideosCongressoCall {
  Future<ApiCallResponse> call({
    String? maxResults = '45',
    String? pageToken = '',
  }) async {
    pageToken ??= '';
    final baseUrl = YouTubeGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'videosCongresso',
      apiUrl: '$baseUrl/youtube/v3/playlistItems',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'key': "AIzaSyBW4nFybqLOKz9o6hbW37BQactu-GlmA10",
        'part': "snippet, contentDetails",
        'playlistId': "PL_imquHBp-AfvhiU7po3bYwdrPdsdWcIx",
        'maxResults': maxResults,
        if (pageToken.isNotEmpty) 'pageToken': pageToken,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? nextPageToken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.nextPageToken''',
      ));
  List? items(dynamic response) => getJsonField(
        response,
        r'''$.items''',
        true,
      ) as List?;
  dynamic totalVideosPlaylist(dynamic response) => getJsonField(
        response,
        r'''$.pageInfo.totalResults''',
      );
}

class VideosEntrevistasCall {
  Future<ApiCallResponse> call({
    String? maxResults = '45',
    String? pageToken = '',
  }) async {
    pageToken ??= '';
    final baseUrl = YouTubeGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'videosEntrevistas',
      apiUrl: '$baseUrl/youtube/v3/playlistItems',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'key': "AIzaSyBW4nFybqLOKz9o6hbW37BQactu-GlmA10",
        'part': "snippet, contentDetails",
        'playlistId': "PL_imquHBp-Adfd5zarNNRqLCB3Fto89eM",
        'maxResults': maxResults,
        if (pageToken.isNotEmpty) 'pageToken': pageToken,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? nextPageToken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.nextPageToken''',
      ));
  List? items(dynamic response) => getJsonField(
        response,
        r'''$.items''',
        true,
      ) as List?;
  dynamic totalVideosPlaylist(dynamic response) => getJsonField(
        response,
        r'''$.pageInfo.totalResults''',
      );
}

class VideosPalestrasCall {
  Future<ApiCallResponse> call({
    String? maxResults = '45',
    String? pageToken = '',
  }) async {
    pageToken ??= '';
    final baseUrl = YouTubeGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'videosPalestras ',
      apiUrl: '$baseUrl/youtube/v3/playlistItems',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'key': "AIzaSyBW4nFybqLOKz9o6hbW37BQactu-GlmA10",
        'part': "snippet, contentDetails",
        'playlistId': "PL_imquHBp-AciFsIWSmUqtfUKr3Zp_cVD",
        'maxResults': maxResults,
        if (pageToken.isNotEmpty) 'pageToken': pageToken,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? nextPageToken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.nextPageToken''',
      ));
  List? items(dynamic response) => getJsonField(
        response,
        r'''$.items''',
        true,
      ) as List?;
  int? totalVideosPlaylist(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.pageInfo.totalResults''',
      ));
}

class GetNumVideosPalestrasCall {
  Future<ApiCallResponse> call({
    String? maxResults = '1',
    String? pageToken = '',
  }) async {
    final baseUrl = YouTubeGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'getNumVideosPalestras ',
      apiUrl: '$baseUrl/youtube/v3/playlistItems',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'key': "AIzaSyBW4nFybqLOKz9o6hbW37BQactu-GlmA10",
        'part': "snippet, contentDetails",
        'playlistId': "PL_imquHBp-AciFsIWSmUqtfUKr3Zp_cVD",
        'maxResults': maxResults,
        'pageToken': pageToken,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? nextPageToken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.nextPageToken''',
      ));
  List? items(dynamic response) => getJsonField(
        response,
        r'''$.items''',
        true,
      ) as List?;
  int? totalVideosPlaylist(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.pageInfo.totalResults''',
      ));
}

class VideosMeditationsCall {
  Future<ApiCallResponse> call({
    String? maxResults = '45',
    String? pageToken = '',
  }) async {
    pageToken ??= '';
    final baseUrl = YouTubeGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'videosMeditations',
      apiUrl: '$baseUrl/youtube/v3/playlistItems',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'key': "AIzaSyBW4nFybqLOKz9o6hbW37BQactu-GlmA10",
        'part': "snippet, contentDetails",
        'playlistId': "PL_imquHBp-AflY6p2_knipuxmRPwYUOny",
        'maxResults': maxResults,
        if (pageToken.isNotEmpty) 'pageToken': pageToken,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? nextPageToken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.nextPageToken''',
      ));
  List? items(dynamic response) => getJsonField(
        response,
        r'''$.items''',
        true,
      ) as List?;
  dynamic totalVideosPlaylist(dynamic response) => getJsonField(
        response,
        r'''$.pageInfo.totalResults''',
      );
}

class VideosCanalViverMeditarCall {
  Future<ApiCallResponse> call({
    String? maxResults = '25',
    String? pageToken,
  }) async {
    pageToken ??= '';
    final baseUrl = YouTubeGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'videosCanalViverMeditar',
      apiUrl: '$baseUrl/youtube/v3/playlistItems',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'key': "AIzaSyBW4nFybqLOKz9o6hbW37BQactu-GlmA10",
        'part': "snippet, contentDetails",
        'playlistId': "UU13Vp3d9hlz6h1q4avzYF9A",
        'maxResults': maxResults,
        'pageToken': pageToken,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? nextPageToken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.nextPageToken''',
      ));
  List? items(dynamic response) => getJsonField(
        response,
        r'''$.items''',
        true,
      ) as List?;
  List<String>? title(dynamic response) => (getJsonField(
        response,
        r'''$.items[:].snippet.title''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<String>? thumbnail(dynamic response) => (getJsonField(
        response,
        r'''$.items[:].snippet.thumbnails.high.url''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<String>? videoId(dynamic response) => (getJsonField(
        response,
        r'''$.items[:].snippet.resourceId.videoId''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}
