import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/flutter_flow/custom_functions.dart' as functions;

/// ViewModel for NotificationViewPage
/// Manages state for viewing a single notification
class NotificationViewViewModel extends ChangeNotifier {
  // State properties
  NotificationsRecord? _notification;
  NotificationsRecord? get notification => _notification;

  bool _isEditing = false;
  bool get isEditing => _isEditing;

  /// Initialize the ViewModel with notification data
  void initialize(NotificationsRecord? doc, bool? editing) {
    _notification = doc;
    _isEditing = editing ?? false;
    notifyListeners();
  }

  /// Get notification image based on type
  String getNotificationImage() {
    if (_notification == null) return '';
    return functions.getNotificationImage(_notification!.type);
  }

  /// Get notification title with fallback
  String getTitle() {
    return _notification?.title ?? 'Título';
  }

  /// Get notification content with fallback
  String getContent() {
    return _notification?.content ?? 'Conteúdo';
  }

  /// Get notification type with fallback
  String getType() {
    return _notification?.type ?? 'Tipo';
  }

  /// Get formatted recipients text
  String getRecipientsText() {
    if (_notification == null) return 'Destinatários: Todos os usuários';

    if (_notification!.typeRecipients == 'Usuário específico') {
      return 'Destinatário: ${_notification!.recipientEmail}';
    }
    return 'Destinatários: Todos os usuários';
  }
}
