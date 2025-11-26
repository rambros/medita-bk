// ignore_for_file: unnecessary_getters_setters
import '/utils/algolia_serialization_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/core/structs/util/firestore_util.dart';

import '/ui/core/flutter_flow/flutter_flow_util.dart';

class AlarmTimeStruct extends FFFirebaseStruct {
  AlarmTimeStruct({
    int? key,
    String? showTime,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _key = key,
        _showTime = showTime,
        super(firestoreUtilData);

  // "key" field.
  int? _key;
  int get key => _key ?? 0;
  set key(int? val) => _key = val;

  void incrementKey(int amount) => key = key + amount;

  bool hasKey() => _key != null;

  // "showTime" field.
  String? _showTime;
  String get showTime => _showTime ?? '';
  set showTime(String? val) => _showTime = val;

  bool hasShowTime() => _showTime != null;

  static AlarmTimeStruct fromMap(Map<String, dynamic> data) => AlarmTimeStruct(
        key: castToType<int>(data['key']),
        showTime: data['showTime'] as String?,
      );

  static AlarmTimeStruct? maybeFromMap(dynamic data) =>
      data is Map ? AlarmTimeStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'key': _key,
        'showTime': _showTime,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'key': serializeParam(
          _key,
          ParamType.int,
        ),
        'showTime': serializeParam(
          _showTime,
          ParamType.String,
        ),
      }.withoutNulls;

  static AlarmTimeStruct fromSerializableMap(Map<String, dynamic> data) => AlarmTimeStruct(
        key: deserializeParam(
          data['key'],
          ParamType.int,
          false,
        ),
        showTime: deserializeParam(
          data['showTime'],
          ParamType.String,
          false,
        ),
      );

  static AlarmTimeStruct fromAlgoliaData(Map<String, dynamic> data) => AlarmTimeStruct(
        key: convertAlgoliaParam(
          data['key'],
          ParamType.int,
          false,
        ),
        showTime: convertAlgoliaParam(
          data['showTime'],
          ParamType.String,
          false,
        ),
        firestoreUtilData: const FirestoreUtilData(
          clearUnsetFields: false,
          create: true,
        ),
      );

  @override
  String toString() => 'AlarmTimeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AlarmTimeStruct && key == other.key && showTime == other.showTime;
  }

  @override
  int get hashCode => const ListEquality().hash([key, showTime]);
}

AlarmTimeStruct createAlarmTimeStruct({
  int? key,
  String? showTime,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    AlarmTimeStruct(
      key: key,
      showTime: showTime,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

AlarmTimeStruct? updateAlarmTimeStruct(
  AlarmTimeStruct? alarmTime, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    alarmTime
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addAlarmTimeStructData(
  Map<String, dynamic> firestoreData,
  AlarmTimeStruct? alarmTime,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (alarmTime == null) {
    return;
  }
  if (alarmTime.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue && alarmTime.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final alarmTimeData = getAlarmTimeFirestoreData(alarmTime, forFieldValue);
  final nestedData = alarmTimeData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = alarmTime.firestoreUtilData.create || clearFields;
  firestoreData.addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAlarmTimeFirestoreData(
  AlarmTimeStruct? alarmTime, [
  bool forFieldValue = false,
]) {
  if (alarmTime == null) {
    return {};
  }
  final firestoreData = mapToFirestore(alarmTime.toMap());

  // Add any Firestore field values
  alarmTime.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAlarmTimeListFirestoreData(
  List<AlarmTimeStruct>? alarmTimes,
) =>
    alarmTimes?.map((e) => getAlarmTimeFirestoreData(e, true)).toList() ?? [];
