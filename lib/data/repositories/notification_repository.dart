import '/backend/backend.dart';

/// Repository for notification data access
/// Centralizes Firestore queries for notifications
class NotificationRepository {
  /// Get all notifications ordered by send date (descending)
  Stream<List<NotificationsRecord>> getAllNotifications({int limit = 30}) {
    return queryNotificationsRecord(
      queryBuilder: (notificationsRecord) => notificationsRecord.orderBy('dataEnvio', descending: true),
      limit: limit,
    );
  }

  /// Get scheduled notifications (not yet sent)
  /// Note: This assumes there's a field to distinguish scheduled vs sent
  /// If not, this will need to be updated based on actual data model
  Stream<List<NotificationsRecord>> getScheduledNotifications({int limit = 30}) {
    return queryNotificationsRecord(
      queryBuilder: (notificationsRecord) =>
          notificationsRecord.where('type', isEqualTo: 'Agendada').orderBy('dataEnvio', descending: true),
      limit: limit,
    );
  }

  /// Get sent notifications
  Stream<List<NotificationsRecord>> getSentNotifications({int limit = 30}) {
    return queryNotificationsRecord(
      queryBuilder: (notificationsRecord) =>
          notificationsRecord.where('type', isEqualTo: 'Enviada').orderBy('dataEnvio', descending: true),
      limit: limit,
    );
  }

  /// Get a single notification by ID
  Future<NotificationsRecord?> getNotificationById(String id) async {
    // Implementation depends on how IDs are structured in Firestore
    // This is a placeholder
    return null;
  }
}
