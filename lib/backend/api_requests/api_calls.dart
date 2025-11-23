import 'dart:convert';
import 'dart:typed_data';
import '../schema/structs/index.dart';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start YouTube Group Code

class YouTubeGroup {
  static String getBaseUrl() => 'https://www.googleapis.com';
  static Map<String, String> headers = {};
  static CanalViverMeditarCall canalViverMeditarCall = CanalViverMeditarCall();
  static CanalBrahmaKumarisCall canalBrahmaKumarisCall =
      CanalBrahmaKumarisCall();
  static VideosCongressoCall videosCongressoCall = VideosCongressoCall();
  static VideosEntrevistasCall videosEntrevistasCall = VideosEntrevistasCall();
  static VideosPalestrasCall videosPalestrasCall = VideosPalestrasCall();
  static GetNumVideosPalestrasCall getNumVideosPalestrasCall =
      GetNumVideosPalestrasCall();
  static VideosMeditationsCall videosMeditationsCall = VideosMeditationsCall();
  static VideosCanalViverMeditarCall videosCanalViverMeditarCall =
      VideosCanalViverMeditarCall();
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

/// End YouTube Group Code

class GetEventListByIdCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'getEventListById',
      apiUrl:
          'http://events.brahmakumaris.org/bkregistration/organisationEventReportController.do?orgEventTemplate=jsonEventExport.ftl&orgId=258&fromIndex=0&toIndex=100&mimeType=text/plain',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class SearchMensagensCall {
  static Future<ApiCallResponse> call({
    String? pesquisar = '',
  }) async {
    final ffApiRequestBody = '''
{
  "search": "$pesquisar"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'searchMensagens',
      apiUrl:
          'https://hxhpzoyjjghtekqgfbfh.supabase.co/functions/v1/search-mbk-messages',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer  eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh4aHB6b3lqamdodGVrcWdmYmZoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDE5NTQ2NTcsImV4cCI6MjAxNzUzMDY1N30.AXFvKve52GjqNJu9Npg3HCnfQ5suy_ba3n-2_s5ZnDs',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers':
            'authorization, x-client-info, apikey, content-type',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}
