import 'package:medita_bk/data/models/firebase/message_model.dart';
import 'package:medita_bk/data/services/firebase/firestore_service.dart';
import 'package:medita_bk/data/services/messages_service.dart';

class MensagemRepository {
  MensagemRepository({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  final FirestoreService _firestoreService;

  /// Get a specific message by ID
  Future<MessageModel?> getMensagemById(int id) async {
    final results = await _firestoreService.getCollection(
      collectionPath: 'messages',
      fromSnapshot: MessageModel.fromFirestore,
      queryBuilder: (query) => query.where('id', isEqualTo: id).limit(1),
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
