// ignore_for_file: unnecessary_getters_setters
import '/utils/algolia_serialization_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/core/structs/util/firestore_util.dart';

import 'index.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';

class SearchedMessagesStruct extends FFFirebaseStruct {
  SearchedMessagesStruct({
    String? search,
    List<MensagemStruct>? result,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _search = search,
        _result = result,
        super(firestoreUtilData);

  // "search" field.
  String? _search;
  String get search => _search ?? '';
  set search(String? val) => _search = val;

  bool hasSearch() => _search != null;

  // "result" field.
  List<MensagemStruct>? _result;
  List<MensagemStruct> get result => _result ?? const [];
  set result(List<MensagemStruct>? val) => _result = val;

  void updateResult(Function(List<MensagemStruct>) updateFn) {
    updateFn(_result ??= []);
  }

  bool hasResult() => _result != null;

  static SearchedMessagesStruct fromMap(Map<String, dynamic> data) => SearchedMessagesStruct(
        search: data['search'] as String?,
        result: getStructList(
          data['result'],
          MensagemStruct.fromMap,
        ),
      );

  static SearchedMessagesStruct? maybeFromMap(dynamic data) =>
      data is Map ? SearchedMessagesStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'search': _search,
        'result': _result?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'search': serializeParam(
          _search,
          ParamType.String,
        ),
        'result': serializeParam(
          _result,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static SearchedMessagesStruct fromSerializableMap(Map<String, dynamic> data) => SearchedMessagesStruct(
        search: deserializeParam(
          data['search'],
          ParamType.String,
          false,
        ),
        result: deserializeStructParam<MensagemStruct>(
          data['result'],
          ParamType.DataStruct,
          true,
          structBuilder: MensagemStruct.fromSerializableMap,
        ),
      );

  static SearchedMessagesStruct fromAlgoliaData(Map<String, dynamic> data) => SearchedMessagesStruct(
        search: convertAlgoliaParam(
          data['search'],
          ParamType.String,
          false,
        ),
        result: convertAlgoliaParam<MensagemStruct>(
          data['result'],
          ParamType.DataStruct,
          true,
          structBuilder: MensagemStruct.fromAlgoliaData,
        ),
        firestoreUtilData: const FirestoreUtilData(
          clearUnsetFields: false,
          create: true,
        ),
      );

  @override
  String toString() => 'SearchedMessagesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is SearchedMessagesStruct && search == other.search && listEquality.equals(result, other.result);
  }

  @override
  int get hashCode => const ListEquality().hash([search, result]);
}

SearchedMessagesStruct createSearchedMessagesStruct({
  String? search,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    SearchedMessagesStruct(
      search: search,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

SearchedMessagesStruct? updateSearchedMessagesStruct(
  SearchedMessagesStruct? searchedMessages, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    searchedMessages
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addSearchedMessagesStructData(
  Map<String, dynamic> firestoreData,
  SearchedMessagesStruct? searchedMessages,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (searchedMessages == null) {
    return;
  }
  if (searchedMessages.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue && searchedMessages.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final searchedMessagesData = getSearchedMessagesFirestoreData(searchedMessages, forFieldValue);
  final nestedData = searchedMessagesData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = searchedMessages.firestoreUtilData.create || clearFields;
  firestoreData.addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getSearchedMessagesFirestoreData(
  SearchedMessagesStruct? searchedMessages, [
  bool forFieldValue = false,
]) {
  if (searchedMessages == null) {
    return {};
  }
  final firestoreData = mapToFirestore(searchedMessages.toMap());

  // Add any Firestore field values
  searchedMessages.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getSearchedMessagesListFirestoreData(
  List<SearchedMessagesStruct>? searchedMessagess,
) =>
    searchedMessagess?.map((e) => getSearchedMessagesFirestoreData(e, true)).toList() ?? [];
