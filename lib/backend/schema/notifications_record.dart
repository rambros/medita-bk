import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';

class NotificationsRecord extends FirestoreRecord {
  NotificationsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  bool hasType() => _type != null;

  // "dataEnvio" field.
  DateTime? _dataEnvio;
  DateTime? get dataEnvio => _dataEnvio;
  bool hasDataEnvio() => _dataEnvio != null;

  // "imagePath" field.
  String? _imagePath;
  String get imagePath => _imagePath ?? '';
  bool hasImagePath() => _imagePath != null;

  // "content" field.
  String? _content;
  String get content => _content ?? '';
  bool hasContent() => _content != null;

  // "typeRecipients" field.
  String? _typeRecipients;
  String get typeRecipients => _typeRecipients ?? '';
  bool hasTypeRecipients() => _typeRecipients != null;

  // "recipientEmail" field.
  String? _recipientEmail;
  String get recipientEmail => _recipientEmail ?? '';
  bool hasRecipientEmail() => _recipientEmail != null;

  // "recipientsRef" field.
  List<DocumentReference>? _recipientsRef;
  List<DocumentReference> get recipientsRef => _recipientsRef ?? const [];
  bool hasRecipientsRef() => _recipientsRef != null;

  // "recipientRef" field.
  DocumentReference? _recipientRef;
  DocumentReference? get recipientRef => _recipientRef;
  bool hasRecipientRef() => _recipientRef != null;

  void _initializeFields() {
    _title = snapshotData['title'] as String?;
    _type = snapshotData['type'] as String?;
    _dataEnvio = snapshotData['dataEnvio'] as DateTime?;
    _imagePath = snapshotData['imagePath'] as String?;
    _content = snapshotData['content'] as String?;
    _typeRecipients = snapshotData['typeRecipients'] as String?;
    _recipientEmail = snapshotData['recipientEmail'] as String?;
    _recipientsRef = getDataList(snapshotData['recipientsRef']);
    _recipientRef = snapshotData['recipientRef'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('notifications');

  static Stream<NotificationsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => NotificationsRecord.fromSnapshot(s));

  static Future<NotificationsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => NotificationsRecord.fromSnapshot(s));

  static NotificationsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      NotificationsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static NotificationsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      NotificationsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'NotificationsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is NotificationsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createNotificationsRecordData({
  String? title,
  String? type,
  DateTime? dataEnvio,
  String? imagePath,
  String? content,
  String? typeRecipients,
  String? recipientEmail,
  DocumentReference? recipientRef,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'title': title,
      'type': type,
      'dataEnvio': dataEnvio,
      'imagePath': imagePath,
      'content': content,
      'typeRecipients': typeRecipients,
      'recipientEmail': recipientEmail,
      'recipientRef': recipientRef,
    }.withoutNulls,
  );

  return firestoreData;
}

class NotificationsRecordDocumentEquality
    implements Equality<NotificationsRecord> {
  const NotificationsRecordDocumentEquality();

  @override
  bool equals(NotificationsRecord? e1, NotificationsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.title == e2?.title &&
        e1?.type == e2?.type &&
        e1?.dataEnvio == e2?.dataEnvio &&
        e1?.imagePath == e2?.imagePath &&
        e1?.content == e2?.content &&
        e1?.typeRecipients == e2?.typeRecipients &&
        e1?.recipientEmail == e2?.recipientEmail &&
        listEquality.equals(e1?.recipientsRef, e2?.recipientsRef) &&
        e1?.recipientRef == e2?.recipientRef;
  }

  @override
  int hash(NotificationsRecord? e) => const ListEquality().hash([
        e?.title,
        e?.type,
        e?.dataEnvio,
        e?.imagePath,
        e?.content,
        e?.typeRecipients,
        e?.recipientEmail,
        e?.recipientsRef,
        e?.recipientRef
      ]);

  @override
  bool isValidKey(Object? o) => o is NotificationsRecord;
}
