import '/backend/backend.dart';
import '/backend/api_requests/api_calls.dart';

class MensagemRepository {
  /// Get a specific message by ID
  Future<MessagesRecord?> getMensagemById(int id) async {
    final results = await queryMessagesRecordOnce(
      queryBuilder: (messagesRecord) => messagesRecord.where(
        'id',
        isEqualTo: id,
      ),
      singleRecord: true,
    );
    return results.firstOrNull;
  }

  /// Search messages using semantic search API
  Future<dynamic> searchMensagens(String query) async {
    final response = await SearchMensagensCall.call(pesquisar: query);

    if (response.succeeded) {
      return response.jsonBody;
    }

    throw Exception('Failed to search messages: ${response.statusCode}');
  }
}
