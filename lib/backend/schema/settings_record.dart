import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';

class SettingsRecord extends FirestoreRecord {
  SettingsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "habilitaDesafio21" field.
  bool? _habilitaDesafio21;
  bool get habilitaDesafio21 => _habilitaDesafio21 ?? false;
  bool hasHabilitaDesafio21() => _habilitaDesafio21 != null;

  // "diaInicioDesafio21" field.
  DateTime? _diaInicioDesafio21;
  DateTime? get diaInicioDesafio21 => _diaInicioDesafio21;
  bool hasDiaInicioDesafio21() => _diaInicioDesafio21 != null;

  void _initializeFields() {
    _habilitaDesafio21 = snapshotData['habilitaDesafio21'] as bool?;
    _diaInicioDesafio21 = snapshotData['diaInicioDesafio21'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('settings');

  static Stream<SettingsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SettingsRecord.fromSnapshot(s));

  static Future<SettingsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SettingsRecord.fromSnapshot(s));

  static SettingsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SettingsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SettingsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SettingsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SettingsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SettingsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSettingsRecordData({
  bool? habilitaDesafio21,
  DateTime? diaInicioDesafio21,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'habilitaDesafio21': habilitaDesafio21,
      'diaInicioDesafio21': diaInicioDesafio21,
    }.withoutNulls,
  );

  return firestoreData;
}

class SettingsRecordDocumentEquality implements Equality<SettingsRecord> {
  const SettingsRecordDocumentEquality();

  @override
  bool equals(SettingsRecord? e1, SettingsRecord? e2) {
    return e1?.habilitaDesafio21 == e2?.habilitaDesafio21 &&
        e1?.diaInicioDesafio21 == e2?.diaInicioDesafio21;
  }

  @override
  int hash(SettingsRecord? e) =>
      const ListEquality().hash([e?.habilitaDesafio21, e?.diaInicioDesafio21]);

  @override
  bool isValidKey(Object? o) => o is SettingsRecord;
}
