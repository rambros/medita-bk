import '/core/structs/index.dart';
import '/domain/agenda/services/agenda_service.dart';
import '/data/services/api_manager.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';

class AgendaRepository {
  Future<List<EventModelStruct>> getEvents() async {
    final response = await ApiManager.instance.makeApiCall(
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

    if (response.succeeded) {
      final jsonBody = response.jsonBody;
      final data = getJsonField(
        jsonBody,
        r'''$.response.data''',
        true,
      );

      if (data != null) {
        return AgendaService.convertJsonToEventList(data);
      }
    }

    throw Exception('Failed to load events');
  }
}
