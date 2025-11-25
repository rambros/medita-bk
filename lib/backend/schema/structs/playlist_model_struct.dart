// ignore_for_file: unnecessary_getters_setters
import '/backend/algolia/serialization_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';

class PlaylistModelStruct extends FFFirebaseStruct {
  PlaylistModelStruct({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    int? duration,
    List<AudioModelStruct>? audios,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _title = title,
        _description = description,
        _imageUrl = imageUrl,
        _duration = duration,
        _audios = audios,
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

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "imageUrl" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  set imageUrl(String? val) => _imageUrl = val;

  bool hasImageUrl() => _imageUrl != null;

  // "duration" field.
  int? _duration;
  int get duration => _duration ?? 0;
  set duration(int? val) => _duration = val;

  void incrementDuration(int amount) => duration = duration + amount;

  bool hasDuration() => _duration != null;

  // "audios" field.
  List<AudioModelStruct>? _audios;
  List<AudioModelStruct> get audios => _audios ?? const [];
  set audios(List<AudioModelStruct>? val) => _audios = val;

  void updateAudios(Function(List<AudioModelStruct>) updateFn) {
    updateFn(_audios ??= []);
  }

  bool hasAudios() => _audios != null;

  static PlaylistModelStruct fromMap(Map<String, dynamic> data) =>
      PlaylistModelStruct(
        id: data['id'] as String?,
        title: data['title'] as String?,
        description: data['description'] as String?,
        imageUrl: data['imageUrl'] as String?,
        duration: castToType<int>(data['duration']),
        audios: getStructList(
          data['audios'],
          AudioModelStruct.fromMap,
        ),
      );

  static PlaylistModelStruct? maybeFromMap(dynamic data) => data is Map
      ? PlaylistModelStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'title': _title,
        'description': _description,
        'imageUrl': _imageUrl,
        'duration': _duration,
        'audios': _audios?.map((e) => e.toMap()).toList(),
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
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'imageUrl': serializeParam(
          _imageUrl,
          ParamType.String,
        ),
        'duration': serializeParam(
          _duration,
          ParamType.int,
        ),
        'audios': serializeParam(
          _audios,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static PlaylistModelStruct fromSerializableMap(Map<String, dynamic> data) =>
      PlaylistModelStruct(
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
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        imageUrl: deserializeParam(
          data['imageUrl'],
          ParamType.String,
          false,
        ),
        duration: deserializeParam(
          data['duration'],
          ParamType.int,
          false,
        ),
        audios: deserializeStructParam<AudioModelStruct>(
          data['audios'],
          ParamType.DataStruct,
          true,
          structBuilder: AudioModelStruct.fromSerializableMap,
        ),
      );

  static PlaylistModelStruct fromAlgoliaData(Map<String, dynamic> data) =>
      PlaylistModelStruct(
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
        description: convertAlgoliaParam(
          data['description'],
          ParamType.String,
          false,
        ),
        imageUrl: convertAlgoliaParam(
          data['imageUrl'],
          ParamType.String,
          false,
        ),
        duration: convertAlgoliaParam(
          data['duration'],
          ParamType.int,
          false,
        ),
        audios: convertAlgoliaParam<AudioModelStruct>(
          data['audios'],
          ParamType.DataStruct,
          true,
          structBuilder: AudioModelStruct.fromAlgoliaData,
        ),
        firestoreUtilData: const FirestoreUtilData(
          clearUnsetFields: false,
          create: true,
        ),
      );

  @override
  String toString() => 'PlaylistModelStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is PlaylistModelStruct &&
        id == other.id &&
        title == other.title &&
        description == other.description &&
        imageUrl == other.imageUrl &&
        duration == other.duration &&
        listEquality.equals(audios, other.audios);
  }

  @override
  int get hashCode => const ListEquality()
      .hash([id, title, description, imageUrl, duration, audios]);
}

PlaylistModelStruct createPlaylistModelStruct({
  String? id,
  String? title,
  String? description,
  String? imageUrl,
  int? duration,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PlaylistModelStruct(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      duration: duration,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PlaylistModelStruct? updatePlaylistModelStruct(
  PlaylistModelStruct? playlistModel, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    playlistModel
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPlaylistModelStructData(
  Map<String, dynamic> firestoreData,
  PlaylistModelStruct? playlistModel,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (playlistModel == null) {
    return;
  }
  if (playlistModel.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && playlistModel.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final playlistModelData =
      getPlaylistModelFirestoreData(playlistModel, forFieldValue);
  final nestedData =
      playlistModelData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = playlistModel.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPlaylistModelFirestoreData(
  PlaylistModelStruct? playlistModel, [
  bool forFieldValue = false,
]) {
  if (playlistModel == null) {
    return {};
  }
  final firestoreData = mapToFirestore(playlistModel.toMap());

  // Add any Firestore field values
  playlistModel.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPlaylistModelListFirestoreData(
  List<PlaylistModelStruct>? playlistModels,
) =>
    playlistModels
        ?.map((e) => getPlaylistModelFirestoreData(e, true))
        .toList() ??
    [];
