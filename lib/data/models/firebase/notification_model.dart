import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Pure Dart model for notifications, replacing NotificationsRecord
/// Usado para notificações das collections: global_push_notifications
///
/// NOTA: O campo 'typeRecipients' no código mapeia para 'destinatarioTipo' no Firestore
/// para manter consistência com ead_push_notifications que usa 'destinatarioTipo'
class NotificationModel extends Equatable {
  final String id;
  final String title;
  final String type;
  final DateTime? sendDate;
  final String imagePath;
  final String content;
  final String typeRecipients; // Mapeia para 'destinatarioTipo' no Firestore
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

    // COMPATIBILIDADE: Aceita tanto 'destinatarioTipo' (novo) quanto 'typeRecipients' (antigo)
    final typeRecipientsValue = (data['destinatarioTipo'] as String?) ??
                                 (data['typeRecipients'] as String?) ?? '';

    // COMPATIBILIDADE: Tenta vários nomes possíveis para título e conteúdo
    final titleValue = (data['title'] as String?) ??
                       (data['titulo'] as String?) ??
                       (data['name'] as String?) ?? '';

    final contentValue = (data['content'] as String?) ??
                         (data['conteudo'] as String?) ??
                         (data['message'] as String?) ??
                         (data['body'] as String?) ?? '';

    final typeValue = (data['type'] as String?) ??
                      (data['tipo'] as String?) ?? '';

    final imagePathValue = (data['imagePath'] as String?) ??
                           (data['image'] as String?) ??
                           (data['imageUrl'] as String?) ?? '';

    return NotificationModel(
      id: doc.id,
      title: titleValue,
      type: typeValue,
      sendDate: timestamp is Timestamp ? timestamp.toDate() : timestamp as DateTime?,
      imagePath: imagePathValue,
      content: contentValue,
      typeRecipients: typeRecipientsValue,
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
      'destinatarioTipo': typeRecipients, // Salva como 'destinatarioTipo' no Firestore
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
