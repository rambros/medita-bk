// ignore_for_file: unnecessary_getters_setters
import '/utils/algolia_serialization_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/core/structs/util/firestore_util.dart';

import '/ui/core/flutter_flow/flutter_flow_util.dart';

class MeditationLogStruct extends FFFirebaseStruct {
  MeditationLogStruct({
    int? duration,
    DateTime? date,
    String? type,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _duration = duration,
        _date = date,
        _type = type,
        super(firestoreUtilData);

  // "duration" field.
  int? _duration;
  int get duration => _duration ?? 0;
  set duration(int? val) => _duration = val;

  void incrementDuration(int amount) => duration = duration + amount;

  bool hasDuration() => _duration != null;

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  set date(DateTime? val) => _date = val;

  bool hasDate() => _date != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  set type(String? val) => _type = val;

  bool hasType() => _type != null;

  static MeditationLogStruct fromMap(Map<String, dynamic> data) => MeditationLogStruct(
        duration: castToType<int>(data['duration']),
        date: data['date'] as DateTime?,
        type: data['type'] as String?,
      );

  static MeditationLogStruct? maybeFromMap(dynamic data) =>
      data is Map ? MeditationLogStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'duration': _duration,
        'date': _date,
        'type': _type,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'duration': serializeParam(
          _duration,
          ParamType.int,
        ),
        'date': serializeParam(
          _date,
          ParamType.DateTime,
        ),
        'type': serializeParam(
          _type,
          ParamType.String,
        ),
      }.withoutNulls;

  static MeditationLogStruct fromSerializableMap(Map<String, dynamic> data) => MeditationLogStruct(
        duration: deserializeParam(
          data['duration'],
          ParamType.int,
          false,
        ),
        date: deserializeParam(
          data['date'],
          ParamType.DateTime,
          false,
        ),
        type: deserializeParam(
          data['type'],
          ParamType.String,
          false,
        ),
      );

  static MeditationLogStruct fromAlgoliaData(Map<String, dynamic> data) => MeditationLogStruct(
        duration: convertAlgoliaParam(
          data['duration'],
          ParamType.int,
          false,
        ),
        date: convertAlgoliaParam(
          data['date'],
          ParamType.DateTime,
          false,
        ),
        type: convertAlgoliaParam(
          data['type'],
          ParamType.String,
          false,
        ),
        firestoreUtilData: const FirestoreUtilData(
          clearUnsetFields: false,
          create: true,
        ),
      );

  @override
  String toString() => 'MeditationLogStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MeditationLogStruct && duration == other.duration && date == other.date && type == other.type;
  }

  @override
  int get hashCode => const ListEquality().hash([duration, date, type]);
}

MeditationLogStruct createMeditationLogStruct({
  int? duration,
  DateTime? date,
  String? type,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    MeditationLogStruct(
      duration: duration,
      date: date,
      type: type,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

MeditationLogStruct? updateMeditationLogStruct(
  MeditationLogStruct? meditationLog, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    meditationLog
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addMeditationLogStructData(
  Map<String, dynamic> firestoreData,
  MeditationLogStruct? meditationLog,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (meditationLog == null) {
    return;
  }
  if (meditationLog.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue && meditationLog.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final meditationLogData = getMeditationLogFirestoreData(meditationLog, forFieldValue);
  final nestedData = meditationLogData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = meditationLog.firestoreUtilData.create || clearFields;
  firestoreData.addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getMeditationLogFirestoreData(
  MeditationLogStruct? meditationLog, [
  bool forFieldValue = false,
]) {
  if (meditationLog == null) {
    return {};
  }
  final firestoreData = mapToFirestore(meditationLog.toMap());

  // Add any Firestore field values
  meditationLog.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getMeditationLogListFirestoreData(
  List<MeditationLogStruct>? meditationLogs,
) =>
    meditationLogs?.map((e) => getMeditationLogFirestoreData(e, true)).toList() ?? [];
