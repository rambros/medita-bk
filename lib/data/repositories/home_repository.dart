import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';

/// Repository for home page data access
/// Centralizes Firestore queries for users, Desafio 21, and settings
class HomeRepository {
  /// Get user record by reference
  Future<UsersRecord> getUserRecord(DocumentReference userRef) async {
    return await UsersRecord.getDocumentOnce(userRef);
  }

  /// Update user's last access timestamp
  Future<void> updateLastAccess(DocumentReference userRef) async {
    await userRef.update(createUsersRecordData(
      lastAccess: DateTime.now(),
    ));
  }

  /// Update user's desafio21Started flag
  Future<void> updateDesafio21Started(
    DocumentReference userRef,
    bool started,
  ) async {
    await userRef.update(createUsersRecordData(
      desafio21Started: started,
    ));
  }

  /// Update user's desafio21 data
  Future<void> updateUserDesafio21(
    DocumentReference userRef,
    D21ModelStruct data,
  ) async {
    await userRef.update(createUsersRecordData(
      desafio21: updateD21ModelStruct(
        data,
        clearUnsetFields: false,
      ),
    ));
  }

  /// Get Desafio 21 template (docId = 1)
  Future<Desafio21Record?> getDesafio21Template() async {
    final results = await queryDesafio21RecordOnce(
      queryBuilder: (desafio21Record) => desafio21Record.where(
        'docId',
        isEqualTo: 1,
      ),
      singleRecord: true,
    );
    return results.firstOrNull;
  }

  /// Get app settings
  Future<SettingsRecord?> getSettings() async {
    final results = await querySettingsRecordOnce(
      singleRecord: true,
    );
    return results.firstOrNull;
  }
}
