// ignore_for_file: unnecessary_getters_setters
import '/backend/algolia/serialization_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';

class D21MeditationModelStruct extends FFFirebaseStruct {
  D21MeditationModelStruct({
    int? etapa,
    int? dia,
    String? titulo,
    String? descricao,
    String? audioFilename,
    String? audioUrl,
    int? audioDuration,
    String? imageUrl,
    String? imageFilename,
    String? mandalaUrl,
    String? mandalaFilename,
    DateTime? dateCreated,
    DateTime? dateCompleted,
    D21Status? meditationStatus,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _etapa = etapa,
        _dia = dia,
        _titulo = titulo,
        _descricao = descricao,
        _audioFilename = audioFilename,
        _audioUrl = audioUrl,
        _audioDuration = audioDuration,
        _imageUrl = imageUrl,
        _imageFilename = imageFilename,
        _mandalaUrl = mandalaUrl,
        _mandalaFilename = mandalaFilename,
        _dateCreated = dateCreated,
        _dateCompleted = dateCompleted,
        _meditationStatus = meditationStatus,
        super(firestoreUtilData);

  // "etapa" field.
  int? _etapa;
  int get etapa => _etapa ?? 1;
  set etapa(int? val) => _etapa = val;

  void incrementEtapa(int amount) => etapa = etapa + amount;

  bool hasEtapa() => _etapa != null;

  // "dia" field.
  int? _dia;
  int get dia => _dia ?? 1;
  set dia(int? val) => _dia = val;

  void incrementDia(int amount) => dia = dia + amount;

  bool hasDia() => _dia != null;

  // "titulo" field.
  String? _titulo;
  String get titulo => _titulo ?? 'Meditação 1';
  set titulo(String? val) => _titulo = val;

  bool hasTitulo() => _titulo != null;

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? 'Descrição da meditação 1';
  set descricao(String? val) => _descricao = val;

  bool hasDescricao() => _descricao != null;

  // "audio_filename" field.
  String? _audioFilename;
  String get audioFilename => _audioFilename ?? '';
  set audioFilename(String? val) => _audioFilename = val;

  bool hasAudioFilename() => _audioFilename != null;

  // "audio_url" field.
  String? _audioUrl;
  String get audioUrl => _audioUrl ?? '';
  set audioUrl(String? val) => _audioUrl = val;

  bool hasAudioUrl() => _audioUrl != null;

  // "audio_duration" field.
  int? _audioDuration;
  int get audioDuration => _audioDuration ?? 0;
  set audioDuration(int? val) => _audioDuration = val;

  void incrementAudioDuration(int amount) =>
      audioDuration = audioDuration + amount;

  bool hasAudioDuration() => _audioDuration != null;

  // "image_url" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  set imageUrl(String? val) => _imageUrl = val;

  bool hasImageUrl() => _imageUrl != null;

  // "image_filename" field.
  String? _imageFilename;
  String get imageFilename => _imageFilename ?? '';
  set imageFilename(String? val) => _imageFilename = val;

  bool hasImageFilename() => _imageFilename != null;

  // "mandala_url" field.
  String? _mandalaUrl;
  String get mandalaUrl => _mandalaUrl ?? '';
  set mandalaUrl(String? val) => _mandalaUrl = val;

  bool hasMandalaUrl() => _mandalaUrl != null;

  // "mandala_filename" field.
  String? _mandalaFilename;
  String get mandalaFilename => _mandalaFilename ?? 'mandala 1-1.png';
  set mandalaFilename(String? val) => _mandalaFilename = val;

  bool hasMandalaFilename() => _mandalaFilename != null;

  // "dateCreated" field.
  DateTime? _dateCreated;
  DateTime? get dateCreated => _dateCreated;
  set dateCreated(DateTime? val) => _dateCreated = val;

  bool hasDateCreated() => _dateCreated != null;

  // "dateCompleted" field.
  DateTime? _dateCompleted;
  DateTime? get dateCompleted => _dateCompleted;
  set dateCompleted(DateTime? val) => _dateCompleted = val;

  bool hasDateCompleted() => _dateCompleted != null;

  // "meditationStatus" field.
  D21Status? _meditationStatus;
  D21Status get meditationStatus => _meditationStatus ?? D21Status.closed;
  set meditationStatus(D21Status? val) => _meditationStatus = val;

  bool hasMeditationStatus() => _meditationStatus != null;

  static D21MeditationModelStruct fromMap(Map<String, dynamic> data) =>
      D21MeditationModelStruct(
        etapa: castToType<int>(data['etapa']),
        dia: castToType<int>(data['dia']),
        titulo: data['titulo'] as String?,
        descricao: data['descricao'] as String?,
        audioFilename: data['audio_filename'] as String?,
        audioUrl: data['audio_url'] as String?,
        audioDuration: castToType<int>(data['audio_duration']),
        imageUrl: data['image_url'] as String?,
        imageFilename: data['image_filename'] as String?,
        mandalaUrl: data['mandala_url'] as String?,
        mandalaFilename: data['mandala_filename'] as String?,
        dateCreated: data['dateCreated'] as DateTime?,
        dateCompleted: data['dateCompleted'] as DateTime?,
        meditationStatus: data['meditationStatus'] is D21Status
            ? data['meditationStatus']
            : deserializeEnum<D21Status>(data['meditationStatus']),
      );

  static D21MeditationModelStruct? maybeFromMap(dynamic data) => data is Map
      ? D21MeditationModelStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'etapa': _etapa,
        'dia': _dia,
        'titulo': _titulo,
        'descricao': _descricao,
        'audio_filename': _audioFilename,
        'audio_url': _audioUrl,
        'audio_duration': _audioDuration,
        'image_url': _imageUrl,
        'image_filename': _imageFilename,
        'mandala_url': _mandalaUrl,
        'mandala_filename': _mandalaFilename,
        'dateCreated': _dateCreated,
        'dateCompleted': _dateCompleted,
        'meditationStatus': _meditationStatus?.serialize(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'etapa': serializeParam(
          _etapa,
          ParamType.int,
        ),
        'dia': serializeParam(
          _dia,
          ParamType.int,
        ),
        'titulo': serializeParam(
          _titulo,
          ParamType.String,
        ),
        'descricao': serializeParam(
          _descricao,
          ParamType.String,
        ),
        'audio_filename': serializeParam(
          _audioFilename,
          ParamType.String,
        ),
        'audio_url': serializeParam(
          _audioUrl,
          ParamType.String,
        ),
        'audio_duration': serializeParam(
          _audioDuration,
          ParamType.int,
        ),
        'image_url': serializeParam(
          _imageUrl,
          ParamType.String,
        ),
        'image_filename': serializeParam(
          _imageFilename,
          ParamType.String,
        ),
        'mandala_url': serializeParam(
          _mandalaUrl,
          ParamType.String,
        ),
        'mandala_filename': serializeParam(
          _mandalaFilename,
          ParamType.String,
        ),
        'dateCreated': serializeParam(
          _dateCreated,
          ParamType.DateTime,
        ),
        'dateCompleted': serializeParam(
          _dateCompleted,
          ParamType.DateTime,
        ),
        'meditationStatus': serializeParam(
          _meditationStatus,
          ParamType.Enum,
        ),
      }.withoutNulls;

  static D21MeditationModelStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      D21MeditationModelStruct(
        etapa: deserializeParam(
          data['etapa'],
          ParamType.int,
          false,
        ),
        dia: deserializeParam(
          data['dia'],
          ParamType.int,
          false,
        ),
        titulo: deserializeParam(
          data['titulo'],
          ParamType.String,
          false,
        ),
        descricao: deserializeParam(
          data['descricao'],
          ParamType.String,
          false,
        ),
        audioFilename: deserializeParam(
          data['audio_filename'],
          ParamType.String,
          false,
        ),
        audioUrl: deserializeParam(
          data['audio_url'],
          ParamType.String,
          false,
        ),
        audioDuration: deserializeParam(
          data['audio_duration'],
          ParamType.int,
          false,
        ),
        imageUrl: deserializeParam(
          data['image_url'],
          ParamType.String,
          false,
        ),
        imageFilename: deserializeParam(
          data['image_filename'],
          ParamType.String,
          false,
        ),
        mandalaUrl: deserializeParam(
          data['mandala_url'],
          ParamType.String,
          false,
        ),
        mandalaFilename: deserializeParam(
          data['mandala_filename'],
          ParamType.String,
          false,
        ),
        dateCreated: deserializeParam(
          data['dateCreated'],
          ParamType.DateTime,
          false,
        ),
        dateCompleted: deserializeParam(
          data['dateCompleted'],
          ParamType.DateTime,
          false,
        ),
        meditationStatus: deserializeParam<D21Status>(
          data['meditationStatus'],
          ParamType.Enum,
          false,
        ),
      );

  static D21MeditationModelStruct fromAlgoliaData(Map<String, dynamic> data) =>
      D21MeditationModelStruct(
        etapa: convertAlgoliaParam(
          data['etapa'],
          ParamType.int,
          false,
        ),
        dia: convertAlgoliaParam(
          data['dia'],
          ParamType.int,
          false,
        ),
        titulo: convertAlgoliaParam(
          data['titulo'],
          ParamType.String,
          false,
        ),
        descricao: convertAlgoliaParam(
          data['descricao'],
          ParamType.String,
          false,
        ),
        audioFilename: convertAlgoliaParam(
          data['audio_filename'],
          ParamType.String,
          false,
        ),
        audioUrl: convertAlgoliaParam(
          data['audio_url'],
          ParamType.String,
          false,
        ),
        audioDuration: convertAlgoliaParam(
          data['audio_duration'],
          ParamType.int,
          false,
        ),
        imageUrl: convertAlgoliaParam(
          data['image_url'],
          ParamType.String,
          false,
        ),
        imageFilename: convertAlgoliaParam(
          data['image_filename'],
          ParamType.String,
          false,
        ),
        mandalaUrl: convertAlgoliaParam(
          data['mandala_url'],
          ParamType.String,
          false,
        ),
        mandalaFilename: convertAlgoliaParam(
          data['mandala_filename'],
          ParamType.String,
          false,
        ),
        dateCreated: convertAlgoliaParam(
          data['dateCreated'],
          ParamType.DateTime,
          false,
        ),
        dateCompleted: convertAlgoliaParam(
          data['dateCompleted'],
          ParamType.DateTime,
          false,
        ),
        meditationStatus: convertAlgoliaParam<D21Status>(
          data['meditationStatus'],
          ParamType.Enum,
          false,
        ),
        firestoreUtilData: const FirestoreUtilData(
          clearUnsetFields: false,
          create: true,
        ),
      );

  @override
  String toString() => 'D21MeditationModelStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is D21MeditationModelStruct &&
        etapa == other.etapa &&
        dia == other.dia &&
        titulo == other.titulo &&
        descricao == other.descricao &&
        audioFilename == other.audioFilename &&
        audioUrl == other.audioUrl &&
        audioDuration == other.audioDuration &&
        imageUrl == other.imageUrl &&
        imageFilename == other.imageFilename &&
        mandalaUrl == other.mandalaUrl &&
        mandalaFilename == other.mandalaFilename &&
        dateCreated == other.dateCreated &&
        dateCompleted == other.dateCompleted &&
        meditationStatus == other.meditationStatus;
  }

  @override
  int get hashCode => const ListEquality().hash([
        etapa,
        dia,
        titulo,
        descricao,
        audioFilename,
        audioUrl,
        audioDuration,
        imageUrl,
        imageFilename,
        mandalaUrl,
        mandalaFilename,
        dateCreated,
        dateCompleted,
        meditationStatus
      ]);
}

D21MeditationModelStruct createD21MeditationModelStruct({
  int? etapa,
  int? dia,
  String? titulo,
  String? descricao,
  String? audioFilename,
  String? audioUrl,
  int? audioDuration,
  String? imageUrl,
  String? imageFilename,
  String? mandalaUrl,
  String? mandalaFilename,
  DateTime? dateCreated,
  DateTime? dateCompleted,
  D21Status? meditationStatus,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    D21MeditationModelStruct(
      etapa: etapa,
      dia: dia,
      titulo: titulo,
      descricao: descricao,
      audioFilename: audioFilename,
      audioUrl: audioUrl,
      audioDuration: audioDuration,
      imageUrl: imageUrl,
      imageFilename: imageFilename,
      mandalaUrl: mandalaUrl,
      mandalaFilename: mandalaFilename,
      dateCreated: dateCreated,
      dateCompleted: dateCompleted,
      meditationStatus: meditationStatus,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

D21MeditationModelStruct? updateD21MeditationModelStruct(
  D21MeditationModelStruct? d21MeditationModel, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    d21MeditationModel
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addD21MeditationModelStructData(
  Map<String, dynamic> firestoreData,
  D21MeditationModelStruct? d21MeditationModel,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (d21MeditationModel == null) {
    return;
  }
  if (d21MeditationModel.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && d21MeditationModel.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final d21MeditationModelData =
      getD21MeditationModelFirestoreData(d21MeditationModel, forFieldValue);
  final nestedData =
      d21MeditationModelData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      d21MeditationModel.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getD21MeditationModelFirestoreData(
  D21MeditationModelStruct? d21MeditationModel, [
  bool forFieldValue = false,
]) {
  if (d21MeditationModel == null) {
    return {};
  }
  final firestoreData = mapToFirestore(d21MeditationModel.toMap());

  // Add any Firestore field values
  d21MeditationModel.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getD21MeditationModelListFirestoreData(
  List<D21MeditationModelStruct>? d21MeditationModels,
) =>
    d21MeditationModels
        ?.map((e) => getD21MeditationModelFirestoreData(e, true))
        .toList() ??
    [];
