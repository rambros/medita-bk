import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MusicsRecord extends FirestoreRecord {
  MusicsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "audioType" field.
  String? _audioType;
  String get audioType => _audioType ?? '';
  bool hasAudioType() => _audioType != null;

  // "author" field.
  String? _author;
  String get author => _author ?? '';
  bool hasAuthor() => _author != null;

  // "fileType" field.
  String? _fileType;
  String get fileType => _fileType ?? '';
  bool hasFileType() => _fileType != null;

  // "fileLocation" field.
  String? _fileLocation;
  String get fileLocation => _fileLocation ?? '';
  bool hasFileLocation() => _fileLocation != null;

  // "duration" field.
  int? _duration;
  int get duration => _duration ?? 0;
  bool hasDuration() => _duration != null;

  void _initializeFields() {
    _title = snapshotData['title'] as String?;
    _audioType = snapshotData['audioType'] as String?;
    _author = snapshotData['author'] as String?;
    _fileType = snapshotData['fileType'] as String?;
    _fileLocation = snapshotData['fileLocation'] as String?;
    _duration = castToType<int>(snapshotData['duration']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('musics');

  static Stream<MusicsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => MusicsRecord.fromSnapshot(s));

  static Future<MusicsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => MusicsRecord.fromSnapshot(s));

  static MusicsRecord fromSnapshot(DocumentSnapshot snapshot) => MusicsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static MusicsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      MusicsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'MusicsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is MusicsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createMusicsRecordData({
  String? title,
  String? audioType,
  String? author,
  String? fileType,
  String? fileLocation,
  int? duration,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'title': title,
      'audioType': audioType,
      'author': author,
      'fileType': fileType,
      'fileLocation': fileLocation,
      'duration': duration,
    }.withoutNulls,
  );

  return firestoreData;
}

class MusicsRecordDocumentEquality implements Equality<MusicsRecord> {
  const MusicsRecordDocumentEquality();

  @override
  bool equals(MusicsRecord? e1, MusicsRecord? e2) {
    return e1?.title == e2?.title &&
        e1?.audioType == e2?.audioType &&
        e1?.author == e2?.author &&
        e1?.fileType == e2?.fileType &&
        e1?.fileLocation == e2?.fileLocation &&
        e1?.duration == e2?.duration;
  }

  @override
  int hash(MusicsRecord? e) => const ListEquality().hash([
        e?.title,
        e?.audioType,
        e?.author,
        e?.fileType,
        e?.fileLocation,
        e?.duration
      ]);

  @override
  bool isValidKey(Object? o) => o is MusicsRecord;
}
