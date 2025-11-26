import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Pure Dart model for notifications, replacing NotificationsRecord
class NotificationModel extends Equatable {
  final String id;
  final String title;
  final String type;
  final DateTime? sendDate;
  final String imagePath;
  final String content;
  final String typeRecipients;
  final String recipientEmail;
  final List<DocumentReference> recipientsRef;
  final DocumentReference? recipientRef;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.type,
    required this.imagePath,
    required this.content,
    required this.typeRecipients,
    required this.recipientEmail,
    this.sendDate,
    this.recipientsRef = const [],
    this.recipientRef,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? type,
    DateTime? sendDate,
    String? imagePath,
    String? content,
    String? typeRecipients,
    String? recipientEmail,
    List<DocumentReference>? recipientsRef,
    DocumentReference? recipientRef,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      sendDate: sendDate ?? this.sendDate,
      imagePath: imagePath ?? this.imagePath,
      content: content ?? this.content,
      typeRecipients: typeRecipients ?? this.typeRecipients,
      recipientEmail: recipientEmail ?? this.recipientEmail,
      recipientsRef: recipientsRef ?? this.recipientsRef,
      recipientRef: recipientRef ?? this.recipientRef,
    );
  }

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final timestamp = data['dataEnvio'];
    return NotificationModel(
      id: doc.id,
      title: (data['title'] as String?) ?? '',
      type: (data['type'] as String?) ?? '',
      sendDate: timestamp is Timestamp ? timestamp.toDate() : timestamp as DateTime?,
      imagePath: (data['imagePath'] as String?) ?? '',
      content: (data['content'] as String?) ?? '',
      typeRecipients: (data['typeRecipients'] as String?) ?? '',
      recipientEmail: (data['recipientEmail'] as String?) ?? '',
      recipientsRef: (data['recipientsRef'] as List<dynamic>?)
              ?.whereType<DocumentReference>()
              .toList() ??
          const [],
      recipientRef: data['recipientRef'] as DocumentReference?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'type': type,
      'dataEnvio': sendDate,
      'imagePath': imagePath,
      'content': content,
      'typeRecipients': typeRecipients,
      'recipientEmail': recipientEmail,
      'recipientsRef': recipientsRef,
      'recipientRef': recipientRef,
    }..removeWhere((_, value) => value == null);
  }

  @override
  List<Object?> get props => [
        id,
        title,
        type,
        sendDate,
        imagePath,
        content,
        typeRecipients,
        recipientEmail,
        recipientsRef,
        recipientRef,
      ];
}
