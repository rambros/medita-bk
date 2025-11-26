import 'package:cloud_firestore/cloud_firestore.dart';

/// Generic Firestore service for CRUD operations
///
/// This service provides reusable methods for interacting with Firestore
/// without coupling to specific data models.
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  // ========== QUERY METHODS ==========

  /// Get a collection with optional query builder
  Future<List<T>> getCollection<T>({
    required String collectionPath,
    required T Function(DocumentSnapshot) fromSnapshot,
    Query Function(Query)? queryBuilder,
    int? limit,
  }) async {
    Query query = _firestore.collection(collectionPath);

    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => fromSnapshot(doc)).toList();
  }

  /// Stream a collection with optional query builder
  Stream<List<T>> streamCollection<T>({
    required String collectionPath,
    required T Function(DocumentSnapshot) fromSnapshot,
    Query Function(Query)? queryBuilder,
  }) {
    Query query = _firestore.collection(collectionPath);

    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    return query.snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => fromSnapshot(doc)).toList(),
        );
  }

  /// Get a single document
  Future<T?> getDocument<T>({
    required String collectionPath,
    required String documentId,
    required T Function(DocumentSnapshot) fromSnapshot,
  }) async {
    final doc = await _firestore.collection(collectionPath).doc(documentId).get();

    if (!doc.exists) return null;
    return fromSnapshot(doc);
  }

  /// Stream a single document
  Stream<T?> streamDocument<T>({
    required String collectionPath,
    required String documentId,
    required T Function(DocumentSnapshot) fromSnapshot,
  }) {
    return _firestore
        .collection(collectionPath)
        .doc(documentId)
        .snapshots()
        .map((doc) => doc.exists ? fromSnapshot(doc) : null);
  }

  // ========== WRITE METHODS ==========

  /// Set a document (create or replace)
  Future<void> setDocument({
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    await _firestore.collection(collectionPath).doc(documentId).set(data, SetOptions(merge: merge));
  }

  /// Update a document (partial update)
  Future<void> updateDocument({
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(collectionPath).doc(documentId).update(data);
  }

  /// Add a document (auto-generated ID)
  Future<DocumentReference> addDocument({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    return await _firestore.collection(collectionPath).add(data);
  }

  /// Delete a document
  Future<void> deleteDocument({
    required String collectionPath,
    required String documentId,
  }) async {
    await _firestore.collection(collectionPath).doc(documentId).delete();
  }

  // ========== BATCH OPERATIONS ==========

  /// Create a batch for multiple operations
  WriteBatch batch() => _firestore.batch();

  /// Commit a batch
  Future<void> commitBatch(WriteBatch batch) async {
    await batch.commit();
  }

  // ========== TRANSACTION OPERATIONS ==========

  /// Run a transaction
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction) transactionHandler,
  ) async {
    return await _firestore.runTransaction(transactionHandler);
  }

  // ========== UTILITY METHODS ==========

  /// Get collection reference
  CollectionReference collection(String path) {
    return _firestore.collection(path);
  }

  /// Get document reference
  DocumentReference document(String collectionPath, String documentId) {
    return _firestore.collection(collectionPath).doc(documentId);
  }

  /// Count documents in a collection
  Future<int> countDocuments({
    required String collectionPath,
    Query Function(Query)? queryBuilder,
  }) async {
    Query query = _firestore.collection(collectionPath);

    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    final snapshot = await query.count().get();
    return snapshot.count ?? 0;
  }
}
