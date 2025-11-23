// ignore_for_file: unnecessary_getters_setters
import '/backend/algolia/serialization_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class D21MandalaModelStruct extends FFFirebaseStruct {
  D21MandalaModelStruct({
    int? diaCompletado,
    String? mandalaUrl,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _diaCompletado = diaCompletado,
        _mandalaUrl = mandalaUrl,
        super(firestoreUtilData);

  // "diaCompletado" field.
  int? _diaCompletado;
  int get diaCompletado => _diaCompletado ?? 0;
  set diaCompletado(int? val) => _diaCompletado = val;

  void incrementDiaCompletado(int amount) =>
      diaCompletado = diaCompletado + amount;

  bool hasDiaCompletado() => _diaCompletado != null;

  // "mandala_url" field.
  String? _mandalaUrl;
  String get mandalaUrl => _mandalaUrl ?? '';
  set mandalaUrl(String? val) => _mandalaUrl = val;

  bool hasMandalaUrl() => _mandalaUrl != null;

  static D21MandalaModelStruct fromMap(Map<String, dynamic> data) =>
      D21MandalaModelStruct(
        diaCompletado: castToType<int>(data['diaCompletado']),
        mandalaUrl: data['mandala_url'] as String?,
      );

  static D21MandalaModelStruct? maybeFromMap(dynamic data) => data is Map
      ? D21MandalaModelStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'diaCompletado': _diaCompletado,
        'mandala_url': _mandalaUrl,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'diaCompletado': serializeParam(
          _diaCompletado,
          ParamType.int,
        ),
        'mandala_url': serializeParam(
          _mandalaUrl,
          ParamType.String,
        ),
      }.withoutNulls;

  static D21MandalaModelStruct fromSerializableMap(Map<String, dynamic> data) =>
      D21MandalaModelStruct(
        diaCompletado: deserializeParam(
          data['diaCompletado'],
          ParamType.int,
          false,
        ),
        mandalaUrl: deserializeParam(
          data['mandala_url'],
          ParamType.String,
          false,
        ),
      );

  static D21MandalaModelStruct fromAlgoliaData(Map<String, dynamic> data) =>
      D21MandalaModelStruct(
        diaCompletado: convertAlgoliaParam(
          data['diaCompletado'],
          ParamType.int,
          false,
        ),
        mandalaUrl: convertAlgoliaParam(
          data['mandala_url'],
          ParamType.String,
          false,
        ),
        firestoreUtilData: const FirestoreUtilData(
          clearUnsetFields: false,
          create: true,
        ),
      );

  @override
  String toString() => 'D21MandalaModelStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is D21MandalaModelStruct &&
        diaCompletado == other.diaCompletado &&
        mandalaUrl == other.mandalaUrl;
  }

  @override
  int get hashCode => const ListEquality().hash([diaCompletado, mandalaUrl]);
}

D21MandalaModelStruct createD21MandalaModelStruct({
  int? diaCompletado,
  String? mandalaUrl,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    D21MandalaModelStruct(
      diaCompletado: diaCompletado,
      mandalaUrl: mandalaUrl,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

D21MandalaModelStruct? updateD21MandalaModelStruct(
  D21MandalaModelStruct? d21MandalaModel, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    d21MandalaModel
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addD21MandalaModelStructData(
  Map<String, dynamic> firestoreData,
  D21MandalaModelStruct? d21MandalaModel,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (d21MandalaModel == null) {
    return;
  }
  if (d21MandalaModel.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && d21MandalaModel.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final d21MandalaModelData =
      getD21MandalaModelFirestoreData(d21MandalaModel, forFieldValue);
  final nestedData =
      d21MandalaModelData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = d21MandalaModel.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getD21MandalaModelFirestoreData(
  D21MandalaModelStruct? d21MandalaModel, [
  bool forFieldValue = false,
]) {
  if (d21MandalaModel == null) {
    return {};
  }
  final firestoreData = mapToFirestore(d21MandalaModel.toMap());

  // Add any Firestore field values
  d21MandalaModel.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getD21MandalaModelListFirestoreData(
  List<D21MandalaModelStruct>? d21MandalaModels,
) =>
    d21MandalaModels
        ?.map((e) => getD21MandalaModelFirestoreData(e, true))
        .toList() ??
    [];
