import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/data/repositories/notification_repository.dart';

/// ViewModel for NotificationListPage
/// Manages state and business logic for the notification list with tabs
class NotificationListViewModel extends ChangeNotifier {
  final NotificationRepository _repository;

  NotificationListViewModel(this._repository);

  // State properties
  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  /// Set the current tab index
  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  /// Get notifications stream based on current tab
  Stream<List<NotificationsRecord>> getNotificationsForTab() {
    switch (_currentTabIndex) {
      case 0:
        // All Notifications
        return _repository.getAllNotifications();
      case 1:
        // Scheduled Notifications
        return _repository.getScheduledNotifications();
      case 2:
        // Sent Notifications
        return _repository.getSentNotifications();
      default:
        return _repository.getAllNotifications();
    }
  }
}
