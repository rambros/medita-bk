import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

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
      apiUrl: 'https://hxhpzoyjjghtekqgfbfh.supabase.co/functions/v1/search-mbk-messages',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer  eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh4aHB6b3lqamdodGVrcWdmYmZoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDE5NTQ2NTcsImV4cCI6MjAxNzUzMDY1N30.AXFvKve52GjqNJu9Npg3HCnfQ5suy_ba3n-2_s5ZnDs',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
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
