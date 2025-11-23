// ignore_for_file: unnecessary_getters_setters
import '/backend/algolia/serialization_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AudioModelStruct extends FFFirebaseStruct {
  AudioModelStruct({
    String? id,
    String? title,
    String? author,
    String? fileLocation,
    FileType? fileType,
    int? duration,
    AudioType? audioType,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _title = title,
        _author = author,
        _fileLocation = fileLocation,
        _fileType = fileType,
        _duration = duration,
        _audioType = audioType,
        super(firestoreUtilData);

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "author" field.
  String? _author;
  String get author => _author ?? '';
  set author(String? val) => _author = val;

  bool hasAuthor() => _author != null;

  // "fileLocation" field.
  String? _fileLocation;
  String get fileLocation => _fileLocation ?? '';
  set fileLocation(String? val) => _fileLocation = val;

  bool hasFileLocation() => _fileLocation != null;

  // "fileType" field.
  FileType? _fileType;
  FileType get fileType => _fileType ?? FileType.asset;
  set fileType(FileType? val) => _fileType = val;

  bool hasFileType() => _fileType != null;

  // "duration" field.
  int? _duration;
  int get duration => _duration ?? 0;
  set duration(int? val) => _duration = val;

  void incrementDuration(int amount) => duration = duration + amount;

  bool hasDuration() => _duration != null;

  // "audioType" field.
  AudioType? _audioType;
  AudioType get audioType => _audioType ?? AudioType.music;
  set audioType(AudioType? val) => _audioType = val;

  bool hasAudioType() => _audioType != null;

  static AudioModelStruct fromMap(Map<String, dynamic> data) =>
      AudioModelStruct(
        id: data['id'] as String?,
        title: data['title'] as String?,
        author: data['author'] as String?,
        fileLocation: data['fileLocation'] as String?,
        fileType: data['fileType'] is FileType
            ? data['fileType']
            : deserializeEnum<FileType>(data['fileType']),
        duration: castToType<int>(data['duration']),
        audioType: data['audioType'] is AudioType
            ? data['audioType']
            : deserializeEnum<AudioType>(data['audioType']),
      );

  static AudioModelStruct? maybeFromMap(dynamic data) => data is Map
      ? AudioModelStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'title': _title,
        'author': _author,
        'fileLocation': _fileLocation,
        'fileType': _fileType?.serialize(),
        'duration': _duration,
        'audioType': _audioType?.serialize(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'author': serializeParam(
          _author,
          ParamType.String,
        ),
        'fileLocation': serializeParam(
          _fileLocation,
          ParamType.String,
        ),
        'fileType': serializeParam(
          _fileType,
          ParamType.Enum,
        ),
        'duration': serializeParam(
          _duration,
          ParamType.int,
        ),
        'audioType': serializeParam(
          _audioType,
          ParamType.Enum,
        ),
      }.withoutNulls;

  static AudioModelStruct fromSerializableMap(Map<String, dynamic> data) =>
      AudioModelStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        author: deserializeParam(
          data['author'],
          ParamType.String,
          false,
        ),
        fileLocation: deserializeParam(
          data['fileLocation'],
          ParamType.String,
          false,
        ),
        fileType: deserializeParam<FileType>(
          data['fileType'],
          ParamType.Enum,
          false,
        ),
        duration: deserializeParam(
          data['duration'],
          ParamType.int,
          false,
        ),
        audioType: deserializeParam<AudioType>(
          data['audioType'],
          ParamType.Enum,
          false,
        ),
      );

  static AudioModelStruct fromAlgoliaData(Map<String, dynamic> data) =>
      AudioModelStruct(
        id: convertAlgoliaParam(
          data['id'],
          ParamType.String,
          false,
        ),
        title: convertAlgoliaParam(
          data['title'],
          ParamType.String,
          false,
        ),
        author: convertAlgoliaParam(
          data['author'],
          ParamType.String,
          false,
        ),
        fileLocation: convertAlgoliaParam(
          data['fileLocation'],
          ParamType.String,
          false,
        ),
        fileType: convertAlgoliaParam<FileType>(
          data['fileType'],
          ParamType.Enum,
          false,
        ),
        duration: convertAlgoliaParam(
          data['duration'],
          ParamType.int,
          false,
        ),
        audioType: convertAlgoliaParam<AudioType>(
          data['audioType'],
          ParamType.Enum,
          false,
        ),
        firestoreUtilData: const FirestoreUtilData(
          clearUnsetFields: false,
          create: true,
        ),
      );

  @override
  String toString() => 'AudioModelStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AudioModelStruct &&
        id == other.id &&
        title == other.title &&
        author == other.author &&
        fileLocation == other.fileLocation &&
        fileType == other.fileType &&
        duration == other.duration &&
        audioType == other.audioType;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([id, title, author, fileLocation, fileType, duration, audioType]);
}

AudioModelStruct createAudioModelStruct({
  String? id,
  String? title,
  String? author,
  String? fileLocation,
  FileType? fileType,
  int? duration,
  AudioType? audioType,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    AudioModelStruct(
      id: id,
      title: title,
      author: author,
      fileLocation: fileLocation,
      fileType: fileType,
      duration: duration,
      audioType: audioType,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

AudioModelStruct? updateAudioModelStruct(
  AudioModelStruct? audioModel, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    audioModel
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addAudioModelStructData(
  Map<String, dynamic> firestoreData,
  AudioModelStruct? audioModel,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (audioModel == null) {
    return;
  }
  if (audioModel.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && audioModel.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final audioModelData = getAudioModelFirestoreData(audioModel, forFieldValue);
  final nestedData = audioModelData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = audioModel.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAudioModelFirestoreData(
  AudioModelStruct? audioModel, [
  bool forFieldValue = false,
]) {
  if (audioModel == null) {
    return {};
  }
  final firestoreData = mapToFirestore(audioModel.toMap());

  // Add any Firestore field values
  audioModel.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAudioModelListFirestoreData(
  List<AudioModelStruct>? audioModels,
) =>
    audioModels?.map((e) => getAudioModelFirestoreData(e, true)).toList() ?? [];
