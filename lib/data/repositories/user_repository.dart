import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/firebase/user_model.dart';
import '../services/firebase/firestore_service.dart';

/// Repository for user data operations
///
/// This repository provides clean access to user data using the new UserModel
/// and FirestoreService, following MVVM architecture.
class UserRepository {
  final FirestoreService _firestoreService;
  static const String _collectionPath = 'users';

  UserRepository({FirestoreService? firestoreService}) : _firestoreService = firestoreService ?? FirestoreService();

  // ========== QUERY METHODS ==========

  /// Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      return await _firestoreService.getDocument(
        collectionPath: _collectionPath,
        documentId: userId,
        fromSnapshot: UserModel.fromFirestore,
      );
    } catch (e) {
      print('Error fetching user by ID: $e');
      rethrow;
    }
  }

  /// Stream user by ID (real-time updates)
  Stream<UserModel?> streamUser(String userId) {
    return _firestoreService.streamDocument(
      collectionPath: _collectionPath,
      documentId: userId,
      fromSnapshot: UserModel.fromFirestore,
    );
  }

  /// Get all users
  Future<List<UserModel>> getAllUsers({int? limit}) async {
    try {
      return await _firestoreService.getCollection(
        collectionPath: _collectionPath,
        fromSnapshot: UserModel.fromFirestore,
        limit: limit,
      );
    } catch (e) {
      print('Error fetching all users: $e');
      rethrow;
    }
  }

  /// Get authors with pagination support
  /// Returns a list of UserModel where userRole contains 'Autor'
  Future<List<UserModel>> getAuthors({
    required int pageSize,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      return await _firestoreService.getCollection(
        collectionPath: _collectionPath,
        fromSnapshot: UserModel.fromFirestore,
        queryBuilder: (query) {
          Query result = query.where('userRole', arrayContains: 'Autor').orderBy('fullName').limit(pageSize);

          if (startAfter != null) {
            result = result.startAfterDocument(startAfter);
          }

          return result;
        },
      );
    } catch (e) {
      print('Error fetching authors: $e');
      rethrow;
    }
  }

  /// Get a stream of authors (for real-time updates)
  Stream<List<UserModel>> getAuthorsStream({int limit = 100}) {
    return _firestoreService.streamCollection(
      collectionPath: _collectionPath,
      fromSnapshot: UserModel.fromFirestore,
      queryBuilder: (query) => query.where('userRole', arrayContains: 'Autor').orderBy('fullName').limit(limit),
    );
  }

  /// Get users by role
  Future<List<UserModel>> getUsersByRole(String role, {int? limit}) async {
    try {
      return await _firestoreService.getCollection(
        collectionPath: _collectionPath,
        fromSnapshot: UserModel.fromFirestore,
        queryBuilder: (query) {
          Query result = query.where('userRole', arrayContains: role);
          if (limit != null) {
            result = result.limit(limit);
          }
          return result;
        },
      );
    } catch (e) {
      print('Error fetching users by role: $e');
      rethrow;
    }
  }

  // ========== WRITE METHODS ==========

  /// Create a new user
  Future<void> createUser(UserModel user) async {
    try {
      await _firestoreService.setDocument(
        collectionPath: _collectionPath,
        documentId: user.uid,
        data: user.toFirestore(),
      );
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  /// Update user
  Future<void> updateUser(String userId, UserModel user) async {
    try {
      await _firestoreService.updateDocument(
        collectionPath: _collectionPath,
        documentId: userId,
        data: user.toFirestore(),
      );
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  /// Update user partial data
  Future<void> updateUserPartial(String userId, Map<String, dynamic> data) async {
    try {
      await _firestoreService.updateDocument(
        collectionPath: _collectionPath,
        documentId: userId,
        data: data,
      );
    } catch (e) {
      print('Error updating user partial: $e');
      rethrow;
    }
  }

  /// Delete user
  Future<void> deleteUser(String userId) async {
    try {
      await _firestoreService.deleteDocument(
        collectionPath: _collectionPath,
        documentId: userId,
      );
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  // ========== FAVORITES METHODS ==========

  /// Add meditation to favorites
  Future<void> addToFavorites(String userId, String meditationId) async {
    try {
      await _firestoreService.updateDocument(
        collectionPath: _collectionPath,
        documentId: userId,
        data: {
          'favorites': FieldValue.arrayUnion([meditationId]),
        },
      );
    } catch (e) {
      print('Error adding to favorites: $e');
      rethrow;
    }
  }

  /// Remove meditation from favorites
  Future<void> removeFromFavorites(String userId, String meditationId) async {
    try {
      await _firestoreService.updateDocument(
        collectionPath: _collectionPath,
        documentId: userId,
        data: {
          'favorites': FieldValue.arrayRemove([meditationId]),
        },
      );
    } catch (e) {
      print('Error removing from favorites: $e');
      rethrow;
    }
  }

  // ========== LAST ACCESS ==========

  /// Update last access timestamp
  Future<void> updateLastAccess(String userId) async {
    try {
      await _firestoreService.updateDocument(
        collectionPath: _collectionPath,
        documentId: userId,
        data: {
          'lastAccess': FieldValue.serverTimestamp(),
        },
      );
    } catch (e) {
      print('Error updating last access: $e');
      rethrow;
    }
  }
}
