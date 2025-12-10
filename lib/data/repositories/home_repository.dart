import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

import 'package:medita_b_k/core/structs/index.dart';
import 'package:medita_b_k/data/models/firebase/desafio21_model.dart';
import 'package:medita_b_k/data/models/firebase/settings_model.dart';
import 'package:medita_b_k/data/models/firebase/user_model.dart';
import 'package:medita_b_k/data/services/firebase/firestore_service.dart';

/// Repository for home page data access
/// Centralizes Firestore queries for users, Desafio 21, and settings
class HomeRepository {
  HomeRepository({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  final FirestoreService _firestoreService;
  static const String _userCollection = 'users';

  /// Get user by id using the new UserModel
  Future<UserModel?> getUserById(String userId) async {
    return _firestoreService.getDocument(
      collectionPath: _userCollection,
      documentId: userId,
      fromSnapshot: UserModel.fromFirestore,
    );
  }

  /// Update user's last access timestamp
  Future<void> updateLastAccess(String userId) async {
    await _firestoreService.updateDocument(
      collectionPath: _userCollection,
      documentId: userId,
      data: {
        'lastAccess': FieldValue.serverTimestamp(),
      },
    );
  }

  /// Update user's desafio21Started flag
  Future<void> updateDesafio21Started(String userId, bool started) async {
    await _firestoreService.updateDocument(
      collectionPath: _userCollection,
      documentId: userId,
      data: {
        'desafio21Started': started,
      },
    );
  }

  /// Update user's desafio21 data
  Future<void> updateUserDesafio21(String userId, D21ModelStruct data) async {
    final firestoreData = <String, dynamic>{};
    addD21ModelStructData(
      firestoreData,
      updateD21ModelStruct(data, clearUnsetFields: false),
      'desafio21',
    );

    await _firestoreService.updateDocument(
      collectionPath: _userCollection,
      documentId: userId,
      data: firestoreData,
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

  /// Get app settings
  Future<SettingsModel?> getSettings() async {
    final results = await _firestoreService.getCollection(
      collectionPath: 'settings',
      fromSnapshot: SettingsModel.fromFirestore,
      queryBuilder: (query) => query.limit(1),
    );
    return results.firstOrNull;
  }
}
