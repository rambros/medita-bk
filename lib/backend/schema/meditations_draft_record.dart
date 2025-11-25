import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';

class MeditationsDraftRecord extends FirestoreRecord {
  MeditationsDraftRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "documentId" field.
  String? _documentId;
  String get documentId => _documentId ?? '';
  bool hasDocumentId() => _documentId != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "authorId" field.
  String? _authorId;
  String get authorId => _authorId ?? '';
  bool hasAuthorId() => _authorId != null;

  // "authorName" field.
  String? _authorName;
  String get authorName => _authorName ?? '';
  bool hasAuthorName() => _authorName != null;

  // "authorText" field.
  String? _authorText;
  String get authorText => _authorText ?? '';
  bool hasAuthorText() => _authorText != null;

  // "authorMusic" field.
  String? _authorMusic;
  String get authorMusic => _authorMusic ?? '';
  bool hasAuthorMusic() => _authorMusic != null;

  // "date" field.
  String? _date;
  String get date => _date ?? '';
  bool hasDate() => _date != null;

  // "featured" field.
  bool? _featured;
  bool get featured => _featured ?? false;
  bool hasFeatured() => _featured != null;

  // "imageFileName" field.
  String? _imageFileName;
  String get imageFileName => _imageFileName ?? '';
  bool hasImageFileName() => _imageFileName != null;

  // "audioFileName" field.
  String? _audioFileName;
  String get audioFileName => _audioFileName ?? '';
  bool hasAudioFileName() => _audioFileName != null;

  // "audioDuration" field.
  String? _audioDuration;
  String get audioDuration => _audioDuration ?? '';
  bool hasAudioDuration() => _audioDuration != null;

  // "callText" field.
  String? _callText;
  String get callText => _callText ?? '';
  bool hasCallText() => _callText != null;

  // "detailsText" field.
  String? _detailsText;
  String get detailsText => _detailsText ?? '';
  bool hasDetailsText() => _detailsText != null;

  // "numPlayed" field.
  int? _numPlayed;
  int get numPlayed => _numPlayed ?? 0;
  bool hasNumPlayed() => _numPlayed != null;

  // "numLiked" field.
  int? _numLiked;
  int get numLiked => _numLiked ?? 0;
  bool hasNumLiked() => _numLiked != null;

  // "category" field.
  List<String>? _category;
  List<String> get category => _category ?? const [];
  bool hasCategory() => _category != null;

  // "titleIndex" field.
  List<String>? _titleIndex;
  List<String> get titleIndex => _titleIndex ?? const [];
  bool hasTitleIndex() => _titleIndex != null;

  // "comments" field.
  List<CommentStruct>? _comments;
  List<CommentStruct> get comments => _comments ?? const [];
  bool hasComments() => _comments != null;

  // "imageUrl" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  bool hasImageUrl() => _imageUrl != null;

  // "audioUrl" field.
  String? _audioUrl;
  String get audioUrl => _audioUrl ?? '';
  bool hasAudioUrl() => _audioUrl != null;

  void _initializeFields() {
    _documentId = snapshotData['documentId'] as String?;
    _title = snapshotData['title'] as String?;
    _authorId = snapshotData['authorId'] as String?;
    _authorName = snapshotData['authorName'] as String?;
    _authorText = snapshotData['authorText'] as String?;
    _authorMusic = snapshotData['authorMusic'] as String?;
    _date = snapshotData['date'] as String?;
    _featured = snapshotData['featured'] as bool?;
    _imageFileName = snapshotData['imageFileName'] as String?;
    _audioFileName = snapshotData['audioFileName'] as String?;
    _audioDuration = snapshotData['audioDuration'] as String?;
    _callText = snapshotData['callText'] as String?;
    _detailsText = snapshotData['detailsText'] as String?;
    _numPlayed = castToType<int>(snapshotData['numPlayed']);
    _numLiked = castToType<int>(snapshotData['numLiked']);
    _category = getDataList(snapshotData['category']);
    _titleIndex = getDataList(snapshotData['titleIndex']);
    _comments = getStructList(
      snapshotData['comments'],
      CommentStruct.fromMap,
    );
    _imageUrl = snapshotData['imageUrl'] as String?;
    _audioUrl = snapshotData['audioUrl'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('meditations_draft');

  static Stream<MeditationsDraftRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => MeditationsDraftRecord.fromSnapshot(s));

  static Future<MeditationsDraftRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => MeditationsDraftRecord.fromSnapshot(s));

  static MeditationsDraftRecord fromSnapshot(DocumentSnapshot snapshot) =>
      MeditationsDraftRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static MeditationsDraftRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      MeditationsDraftRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'MeditationsDraftRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is MeditationsDraftRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createMeditationsDraftRecordData({
  String? documentId,
  String? title,
  String? authorId,
  String? authorName,
  String? authorText,
  String? authorMusic,
  String? date,
  bool? featured,
  String? imageFileName,
  String? audioFileName,
  String? audioDuration,
  String? callText,
  String? detailsText,
  int? numPlayed,
  int? numLiked,
  String? imageUrl,
  String? audioUrl,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'documentId': documentId,
      'title': title,
      'authorId': authorId,
      'authorName': authorName,
      'authorText': authorText,
      'authorMusic': authorMusic,
      'date': date,
      'featured': featured,
      'imageFileName': imageFileName,
      'audioFileName': audioFileName,
      'audioDuration': audioDuration,
      'callText': callText,
      'detailsText': detailsText,
      'numPlayed': numPlayed,
      'numLiked': numLiked,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
    }.withoutNulls,
  );

  return firestoreData;
}

class MeditationsDraftRecordDocumentEquality
    implements Equality<MeditationsDraftRecord> {
  const MeditationsDraftRecordDocumentEquality();

  @override
  bool equals(MeditationsDraftRecord? e1, MeditationsDraftRecord? e2) {
    const listEquality = ListEquality();
    return e1?.documentId == e2?.documentId &&
        e1?.title == e2?.title &&
        e1?.authorId == e2?.authorId &&
        e1?.authorName == e2?.authorName &&
        e1?.authorText == e2?.authorText &&
        e1?.authorMusic == e2?.authorMusic &&
        e1?.date == e2?.date &&
        e1?.featured == e2?.featured &&
        e1?.imageFileName == e2?.imageFileName &&
        e1?.audioFileName == e2?.audioFileName &&
        e1?.audioDuration == e2?.audioDuration &&
        e1?.callText == e2?.callText &&
        e1?.detailsText == e2?.detailsText &&
        e1?.numPlayed == e2?.numPlayed &&
        e1?.numLiked == e2?.numLiked &&
        listEquality.equals(e1?.category, e2?.category) &&
        listEquality.equals(e1?.titleIndex, e2?.titleIndex) &&
        listEquality.equals(e1?.comments, e2?.comments) &&
        e1?.imageUrl == e2?.imageUrl &&
        e1?.audioUrl == e2?.audioUrl;
  }

  @override
  int hash(MeditationsDraftRecord? e) => const ListEquality().hash([
        e?.documentId,
        e?.title,
        e?.authorId,
        e?.authorName,
        e?.authorText,
        e?.authorMusic,
        e?.date,
        e?.featured,
        e?.imageFileName,
        e?.audioFileName,
        e?.audioDuration,
        e?.callText,
        e?.detailsText,
        e?.numPlayed,
        e?.numLiked,
        e?.category,
        e?.titleIndex,
        e?.comments,
        e?.imageUrl,
        e?.audioUrl
      ]);

  @override
  bool isValidKey(Object? o) => o is MeditationsDraftRecord;
}
