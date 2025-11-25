// ignore_for_file: unnecessary_getters_setters
import '/backend/algolia/serialization_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';

class D21ModelStruct extends FFFirebaseStruct {
  D21ModelStruct({
    String? title,
    String? description,
    List<D21MeditationModelStruct>? d21Meditations,
    int? etapasCompletadas,
    int? etapaAtual,
    int? diasCompletados,
    int? diaAtual,
    DateTime? dateStarted,
    DateTime? dateCompleted,
    D21Status? d21Status,
    bool? isD21Completed,
    List<D21BrasaoModelStruct>? listaBrasoes,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _title = title,
        _description = description,
        _d21Meditations = d21Meditations,
        _etapasCompletadas = etapasCompletadas,
        _etapaAtual = etapaAtual,
        _diasCompletados = diasCompletados,
        _diaAtual = diaAtual,
        _dateStarted = dateStarted,
        _dateCompleted = dateCompleted,
        _d21Status = d21Status,
        _isD21Completed = isD21Completed,
        _listaBrasoes = listaBrasoes,
        super(firestoreUtilData);

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

  // "d21_meditations" field.
  List<D21MeditationModelStruct>? _d21Meditations;
  List<D21MeditationModelStruct> get d21Meditations =>
      _d21Meditations ?? const [];
  set d21Meditations(List<D21MeditationModelStruct>? val) =>
      _d21Meditations = val;

  void updateD21Meditations(Function(List<D21MeditationModelStruct>) updateFn) {
    updateFn(_d21Meditations ??= []);
  }

  bool hasD21Meditations() => _d21Meditations != null;

  // "etapasCompletadas" field.
  int? _etapasCompletadas;
  int get etapasCompletadas => _etapasCompletadas ?? 0;
  set etapasCompletadas(int? val) => _etapasCompletadas = val;

  void incrementEtapasCompletadas(int amount) =>
      etapasCompletadas = etapasCompletadas + amount;

  bool hasEtapasCompletadas() => _etapasCompletadas != null;

  // "etapaAtual" field.
  int? _etapaAtual;
  int get etapaAtual => _etapaAtual ?? 1;
  set etapaAtual(int? val) => _etapaAtual = val;

  void incrementEtapaAtual(int amount) => etapaAtual = etapaAtual + amount;

  bool hasEtapaAtual() => _etapaAtual != null;

  // "diasCompletados" field.
  int? _diasCompletados;
  int get diasCompletados => _diasCompletados ?? 0;
  set diasCompletados(int? val) => _diasCompletados = val;

  void incrementDiasCompletados(int amount) =>
      diasCompletados = diasCompletados + amount;

  bool hasDiasCompletados() => _diasCompletados != null;

  // "diaAtual" field.
  int? _diaAtual;
  int get diaAtual => _diaAtual ?? 1;
  set diaAtual(int? val) => _diaAtual = val;

  void incrementDiaAtual(int amount) => diaAtual = diaAtual + amount;

  bool hasDiaAtual() => _diaAtual != null;

  // "dateStarted" field.
  DateTime? _dateStarted;
  DateTime? get dateStarted => _dateStarted;
  set dateStarted(DateTime? val) => _dateStarted = val;

  bool hasDateStarted() => _dateStarted != null;

  // "dateCompleted" field.
  DateTime? _dateCompleted;
  DateTime? get dateCompleted => _dateCompleted;
  set dateCompleted(DateTime? val) => _dateCompleted = val;

  bool hasDateCompleted() => _dateCompleted != null;

  // "d21Status" field.
  D21Status? _d21Status;
  D21Status get d21Status => _d21Status ?? D21Status.closed;
  set d21Status(D21Status? val) => _d21Status = val;

  bool hasD21Status() => _d21Status != null;

  // "isD21Completed" field.
  bool? _isD21Completed;
  bool get isD21Completed => _isD21Completed ?? false;
  set isD21Completed(bool? val) => _isD21Completed = val;

  bool hasIsD21Completed() => _isD21Completed != null;

  // "listaBrasoes" field.
  List<D21BrasaoModelStruct>? _listaBrasoes;
  List<D21BrasaoModelStruct> get listaBrasoes => _listaBrasoes ?? const [];
  set listaBrasoes(List<D21BrasaoModelStruct>? val) => _listaBrasoes = val;

  void updateListaBrasoes(Function(List<D21BrasaoModelStruct>) updateFn) {
    updateFn(_listaBrasoes ??= []);
  }

  bool hasListaBrasoes() => _listaBrasoes != null;

  static D21ModelStruct fromMap(Map<String, dynamic> data) => D21ModelStruct(
        title: data['title'] as String?,
        description: data['description'] as String?,
        d21Meditations: getStructList(
          data['d21_meditations'],
          D21MeditationModelStruct.fromMap,
        ),
        etapasCompletadas: castToType<int>(data['etapasCompletadas']),
        etapaAtual: castToType<int>(data['etapaAtual']),
        diasCompletados: castToType<int>(data['diasCompletados']),
        diaAtual: castToType<int>(data['diaAtual']),
        dateStarted: data['dateStarted'] as DateTime?,
        dateCompleted: data['dateCompleted'] as DateTime?,
        d21Status: data['d21Status'] is D21Status
            ? data['d21Status']
            : deserializeEnum<D21Status>(data['d21Status']),
        isD21Completed: data['isD21Completed'] as bool?,
        listaBrasoes: getStructList(
          data['listaBrasoes'],
          D21BrasaoModelStruct.fromMap,
        ),
      );

  static D21ModelStruct? maybeFromMap(dynamic data) =>
      data is Map ? D21ModelStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'title': _title,
        'description': _description,
        'd21_meditations': _d21Meditations?.map((e) => e.toMap()).toList(),
        'etapasCompletadas': _etapasCompletadas,
        'etapaAtual': _etapaAtual,
        'diasCompletados': _diasCompletados,
        'diaAtual': _diaAtual,
        'dateStarted': _dateStarted,
        'dateCompleted': _dateCompleted,
        'd21Status': _d21Status?.serialize(),
        'isD21Completed': _isD21Completed,
        'listaBrasoes': _listaBrasoes?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'd21_meditations': serializeParam(
          _d21Meditations,
          ParamType.DataStruct,
          isList: true,
        ),
        'etapasCompletadas': serializeParam(
          _etapasCompletadas,
          ParamType.int,
        ),
        'etapaAtual': serializeParam(
          _etapaAtual,
          ParamType.int,
        ),
        'diasCompletados': serializeParam(
          _diasCompletados,
          ParamType.int,
        ),
        'diaAtual': serializeParam(
          _diaAtual,
          ParamType.int,
        ),
        'dateStarted': serializeParam(
          _dateStarted,
          ParamType.DateTime,
        ),
        'dateCompleted': serializeParam(
          _dateCompleted,
          ParamType.DateTime,
        ),
        'd21Status': serializeParam(
          _d21Status,
          ParamType.Enum,
        ),
        'isD21Completed': serializeParam(
          _isD21Completed,
          ParamType.bool,
        ),
        'listaBrasoes': serializeParam(
          _listaBrasoes,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static D21ModelStruct fromSerializableMap(Map<String, dynamic> data) =>
      D21ModelStruct(
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
        d21Meditations: deserializeStructParam<D21MeditationModelStruct>(
          data['d21_meditations'],
          ParamType.DataStruct,
          true,
          structBuilder: D21MeditationModelStruct.fromSerializableMap,
        ),
        etapasCompletadas: deserializeParam(
          data['etapasCompletadas'],
          ParamType.int,
          false,
        ),
        etapaAtual: deserializeParam(
          data['etapaAtual'],
          ParamType.int,
          false,
        ),
        diasCompletados: deserializeParam(
          data['diasCompletados'],
          ParamType.int,
          false,
        ),
        diaAtual: deserializeParam(
          data['diaAtual'],
          ParamType.int,
          false,
        ),
        dateStarted: deserializeParam(
          data['dateStarted'],
          ParamType.DateTime,
          false,
        ),
        dateCompleted: deserializeParam(
          data['dateCompleted'],
          ParamType.DateTime,
          false,
        ),
        d21Status: deserializeParam<D21Status>(
          data['d21Status'],
          ParamType.Enum,
          false,
        ),
        isD21Completed: deserializeParam(
          data['isD21Completed'],
          ParamType.bool,
          false,
        ),
        listaBrasoes: deserializeStructParam<D21BrasaoModelStruct>(
          data['listaBrasoes'],
          ParamType.DataStruct,
          true,
          structBuilder: D21BrasaoModelStruct.fromSerializableMap,
        ),
      );

  static D21ModelStruct fromAlgoliaData(Map<String, dynamic> data) =>
      D21ModelStruct(
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
        d21Meditations: convertAlgoliaParam<D21MeditationModelStruct>(
          data['d21_meditations'],
          ParamType.DataStruct,
          true,
          structBuilder: D21MeditationModelStruct.fromAlgoliaData,
        ),
        etapasCompletadas: convertAlgoliaParam(
          data['etapasCompletadas'],
          ParamType.int,
          false,
        ),
        etapaAtual: convertAlgoliaParam(
          data['etapaAtual'],
          ParamType.int,
          false,
        ),
        diasCompletados: convertAlgoliaParam(
          data['diasCompletados'],
          ParamType.int,
          false,
        ),
        diaAtual: convertAlgoliaParam(
          data['diaAtual'],
          ParamType.int,
          false,
        ),
        dateStarted: convertAlgoliaParam(
          data['dateStarted'],
          ParamType.DateTime,
          false,
        ),
        dateCompleted: convertAlgoliaParam(
          data['dateCompleted'],
          ParamType.DateTime,
          false,
        ),
        d21Status: convertAlgoliaParam<D21Status>(
          data['d21Status'],
          ParamType.Enum,
          false,
        ),
        isD21Completed: convertAlgoliaParam(
          data['isD21Completed'],
          ParamType.bool,
          false,
        ),
        listaBrasoes: convertAlgoliaParam<D21BrasaoModelStruct>(
          data['listaBrasoes'],
          ParamType.DataStruct,
          true,
          structBuilder: D21BrasaoModelStruct.fromAlgoliaData,
        ),
        firestoreUtilData: const FirestoreUtilData(
          clearUnsetFields: false,
          create: true,
        ),
      );

  @override
  String toString() => 'D21ModelStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is D21ModelStruct &&
        title == other.title &&
        description == other.description &&
        listEquality.equals(d21Meditations, other.d21Meditations) &&
        etapasCompletadas == other.etapasCompletadas &&
        etapaAtual == other.etapaAtual &&
        diasCompletados == other.diasCompletados &&
        diaAtual == other.diaAtual &&
        dateStarted == other.dateStarted &&
        dateCompleted == other.dateCompleted &&
        d21Status == other.d21Status &&
        isD21Completed == other.isD21Completed &&
        listEquality.equals(listaBrasoes, other.listaBrasoes);
  }

  @override
  int get hashCode => const ListEquality().hash([
        title,
        description,
        d21Meditations,
        etapasCompletadas,
        etapaAtual,
        diasCompletados,
        diaAtual,
        dateStarted,
        dateCompleted,
        d21Status,
        isD21Completed,
        listaBrasoes
      ]);
}

D21ModelStruct createD21ModelStruct({
  String? title,
  String? description,
  int? etapasCompletadas,
  int? etapaAtual,
  int? diasCompletados,
  int? diaAtual,
  DateTime? dateStarted,
  DateTime? dateCompleted,
  D21Status? d21Status,
  bool? isD21Completed,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    D21ModelStruct(
      title: title,
      description: description,
      etapasCompletadas: etapasCompletadas,
      etapaAtual: etapaAtual,
      diasCompletados: diasCompletados,
      diaAtual: diaAtual,
      dateStarted: dateStarted,
      dateCompleted: dateCompleted,
      d21Status: d21Status,
      isD21Completed: isD21Completed,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

D21ModelStruct? updateD21ModelStruct(
  D21ModelStruct? d21Model, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    d21Model
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addD21ModelStructData(
  Map<String, dynamic> firestoreData,
  D21ModelStruct? d21Model,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (d21Model == null) {
    return;
  }
  if (d21Model.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && d21Model.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final d21ModelData = getD21ModelFirestoreData(d21Model, forFieldValue);
  final nestedData = d21ModelData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = d21Model.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getD21ModelFirestoreData(
  D21ModelStruct? d21Model, [
  bool forFieldValue = false,
]) {
  if (d21Model == null) {
    return {};
  }
  final firestoreData = mapToFirestore(d21Model.toMap());

  // Add any Firestore field values
  d21Model.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getD21ModelListFirestoreData(
  List<D21ModelStruct>? d21Models,
) =>
    d21Models?.map((e) => getD21ModelFirestoreData(e, true)).toList() ?? [];
