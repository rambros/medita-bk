import '/data/models/firebase/notification_model.dart';
import '/data/services/firebase/firestore_service.dart';

/// Repository for notification data access
/// Centralizes Firestore queries for notifications
class NotificationRepository {
  NotificationRepository({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  final FirestoreService _firestoreService;
  static const String _collection = 'notifications';

  /// Get all notifications ordered by send date (descending)
  Stream<List<NotificationModel>> getAllNotifications({int limit = 30}) {
    return _firestoreService.streamCollection(
      collectionPath: _collection,
      fromSnapshot: NotificationModel.fromFirestore,
      queryBuilder: (query) => query.orderBy('dataEnvio', descending: true).limit(limit),
    );
  }

  /// Get scheduled notifications (not yet sent)
  /// Note: This assumes there's a field to distinguish scheduled vs sent
  /// If not, this will need to be updated based on actual data model
  Stream<List<NotificationModel>> getScheduledNotifications({int limit = 30}) {
    return _firestoreService.streamCollection(
      collectionPath: _collection,
      fromSnapshot: NotificationModel.fromFirestore,
      queryBuilder: (query) =>
          query.where('type', isEqualTo: 'Agendada').orderBy('dataEnvio', descending: true).limit(limit),
    );
  }

  /// Get sent notifications
  Stream<List<NotificationModel>> getSentNotifications({int limit = 30}) {
    return _firestoreService.streamCollection(
      collectionPath: _collection,
      fromSnapshot: NotificationModel.fromFirestore,
      queryBuilder: (query) =>
          query.where('type', isEqualTo: 'Enviada').orderBy('dataEnvio', descending: true).limit(limit),
    );
  }

  /// Get a single notification by ID
  Future<NotificationModel?> getNotificationById(String id) async {
    return _firestoreService.getDocument(
      collectionPath: _collection,
      documentId: id,
      fromSnapshot: NotificationModel.fromFirestore,
    );
  }
}
