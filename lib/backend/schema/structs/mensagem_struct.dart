// ignore_for_file: unnecessary_getters_setters
import '/backend/algolia/serialization_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/ui/core/flutter_flow/flutter_flow_util.dart';

class MensagemStruct extends FFFirebaseStruct {
  MensagemStruct({
    int? id,
    String? title,
    String? mensagem,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _title = title,
        _mensagem = mensagem,
        super(firestoreUtilData);

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "mensagem" field.
  String? _mensagem;
  String get mensagem => _mensagem ?? '';
  set mensagem(String? val) => _mensagem = val;

  bool hasMensagem() => _mensagem != null;

  static MensagemStruct fromMap(Map<String, dynamic> data) => MensagemStruct(
        id: castToType<int>(data['id']),
        title: data['title'] as String?,
        mensagem: data['mensagem'] as String?,
      );

  static MensagemStruct? maybeFromMap(dynamic data) =>
      data is Map ? MensagemStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'title': _title,
        'mensagem': _mensagem,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'mensagem': serializeParam(
          _mensagem,
          ParamType.String,
        ),
      }.withoutNulls;

  static MensagemStruct fromSerializableMap(Map<String, dynamic> data) =>
      MensagemStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        mensagem: deserializeParam(
          data['mensagem'],
          ParamType.String,
          false,
        ),
      );

  static MensagemStruct fromAlgoliaData(Map<String, dynamic> data) =>
      MensagemStruct(
        id: convertAlgoliaParam(
          data['id'],
          ParamType.int,
          false,
        ),
        title: convertAlgoliaParam(
          data['title'],
          ParamType.String,
          false,
        ),
        mensagem: convertAlgoliaParam(
          data['mensagem'],
          ParamType.String,
          false,
        ),
        firestoreUtilData: const FirestoreUtilData(
          clearUnsetFields: false,
          create: true,
        ),
      );

  @override
  String toString() => 'MensagemStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MensagemStruct &&
        id == other.id &&
        title == other.title &&
        mensagem == other.mensagem;
  }

  @override
  int get hashCode => const ListEquality().hash([id, title, mensagem]);
}

MensagemStruct createMensagemStruct({
  int? id,
  String? title,
  String? mensagem,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    MensagemStruct(
      id: id,
      title: title,
      mensagem: mensagem,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

MensagemStruct? updateMensagemStruct(
  MensagemStruct? mensagemStruct, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    mensagemStruct
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addMensagemStructData(
  Map<String, dynamic> firestoreData,
  MensagemStruct? mensagemStruct,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (mensagemStruct == null) {
    return;
  }
  if (mensagemStruct.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && mensagemStruct.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final mensagemStructData =
      getMensagemFirestoreData(mensagemStruct, forFieldValue);
  final nestedData =
      mensagemStructData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = mensagemStruct.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getMensagemFirestoreData(
  MensagemStruct? mensagemStruct, [
  bool forFieldValue = false,
]) {
  if (mensagemStruct == null) {
    return {};
  }
  final firestoreData = mapToFirestore(mensagemStruct.toMap());

  // Add any Firestore field values
  mensagemStruct.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getMensagemListFirestoreData(
  List<MensagemStruct>? mensagemStructs,
) =>
    mensagemStructs?.map((e) => getMensagemFirestoreData(e, true)).toList() ??
    [];
