import '/core/structs/index.dart';
import '/data/services/auth/firebase_auth/auth_util.dart';
import '/data/services/firebase/firestore_service.dart';

import '/data/models/firebase/desafio21_model.dart';
import 'package:collection/collection.dart';

class DesafioRepository {
  DesafioRepository({FirestoreService? firestoreService}) : _firestoreService = firestoreService ?? FirestoreService();

  final FirestoreService _firestoreService;
  static const String _collection = 'users';

  /// Updates the user's Desafio 21 progress.
  Future<void> updateDesafio21(D21ModelStruct desafio21, {bool? desafio21Started}) async {
    final uid = currentUserUid;
    if (uid.isEmpty) return;

    final Map<String, dynamic> updateData = {
      'desafio21': desafio21.toMap(),
      if (desafio21Started != null) 'desafio21Started': desafio21Started,
    };

    await _firestoreService.updateDocument(
      collectionPath: _collection,
      documentId: uid,
      data: updateData,
    );
  }

  /// Updates the user's Desafio 21 progress (alias for compatibility).
  Future<void> updateUserDesafio21(String userId, D21ModelStruct desafio21) async {
    await _firestoreService.updateDocument(
      collectionPath: _collection,
      documentId: userId,
      data: {'desafio21': desafio21.toMap()},
    );
  }

  /// Get Desafio 21 template (docId = 1)
  Future<Desafio21Model?> getDesafio21Template() async {
    final results = await _firestoreService.getCollection(
      collectionPath: 'desafio21',
      fromSnapshot: Desafio21Model.fromFirestore,
      queryBuilder: (query) => query.where('docId', isEqualTo: 1).limit(1),
    );
    return results.firstOrNull;
  }

  /// Resets the user's Desafio 21 progress.
  Future<void> resetDesafio() async {
    final uid = currentUserUid;
    if (uid.isEmpty) return;

    // TODO: define reset logic (template reload, clear progress, etc.)
  }
}
