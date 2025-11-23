import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/backend.dart';

class UserRepository {
  /// Get authors with pagination support
  /// Returns a list of UsersRecord where userRole contains 'Autor'
  Future<List<UsersRecord>> getAuthors({
    required int pageSize,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      Query query =
          UsersRecord.collection.where('userRole', arrayContains: 'Autor').orderBy('fullName').limit(pageSize);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) => UsersRecord.fromSnapshot(doc)).toList();
    } catch (e) {
      // Log error and rethrow for ViewModel to handle
      print('Error fetching authors: $e');
      rethrow;
    }
  }

  /// Get a stream of authors (for real-time updates)
  Stream<List<UsersRecord>> getAuthorsStream({
    int limit = 100,
  }) {
    return UsersRecord.collection
        .where('userRole', arrayContains: 'Autor')
        .orderBy('fullName')
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => UsersRecord.fromSnapshot(doc)).toList());
  }

  /// Update user document
  Future<void> updateUser(DocumentReference reference, Map<String, dynamic> data) async {
    try {
      await reference.update(data);
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }
}
