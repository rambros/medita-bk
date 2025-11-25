import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';

class Desafio21Record extends FirestoreRecord {
  Desafio21Record._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "desafio21Data" field.
  D21ModelStruct? _desafio21Data;
  D21ModelStruct get desafio21Data => _desafio21Data ?? D21ModelStruct();
  bool hasDesafio21Data() => _desafio21Data != null;

  // "listaEtapasMandalas" field.
  List<D21EtapaModelStruct>? _listaEtapasMandalas;
  List<D21EtapaModelStruct> get listaEtapasMandalas =>
      _listaEtapasMandalas ?? const [];
  bool hasListaEtapasMandalas() => _listaEtapasMandalas != null;

  // "docId" field.
  int? _docId;
  int get docId => _docId ?? 0;
  bool hasDocId() => _docId != null;

  void _initializeFields() {
    _description = snapshotData['description'] as String?;
    _title = snapshotData['title'] as String?;
    _desafio21Data = snapshotData['desafio21Data'] is D21ModelStruct
        ? snapshotData['desafio21Data']
        : D21ModelStruct.maybeFromMap(snapshotData['desafio21Data']);
    _listaEtapasMandalas = getStructList(
      snapshotData['listaEtapasMandalas'],
      D21EtapaModelStruct.fromMap,
    );
    _docId = castToType<int>(snapshotData['docId']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('desafio21');

  static Stream<Desafio21Record> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => Desafio21Record.fromSnapshot(s));

  static Future<Desafio21Record> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => Desafio21Record.fromSnapshot(s));

  static Desafio21Record fromSnapshot(DocumentSnapshot snapshot) =>
      Desafio21Record._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static Desafio21Record getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      Desafio21Record._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'Desafio21Record(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is Desafio21Record &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createDesafio21RecordData({
  String? description,
  String? title,
  D21ModelStruct? desafio21Data,
  int? docId,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'description': description,
      'title': title,
      'desafio21Data': D21ModelStruct().toMap(),
      'docId': docId,
    }.withoutNulls,
  );

  // Handle nested data for "desafio21Data" field.
  addD21ModelStructData(firestoreData, desafio21Data, 'desafio21Data');

  return firestoreData;
}

class Desafio21RecordDocumentEquality implements Equality<Desafio21Record> {
  const Desafio21RecordDocumentEquality();

  @override
  bool equals(Desafio21Record? e1, Desafio21Record? e2) {
    const listEquality = ListEquality();
    return e1?.description == e2?.description &&
        e1?.title == e2?.title &&
        e1?.desafio21Data == e2?.desafio21Data &&
        listEquality.equals(e1?.listaEtapasMandalas, e2?.listaEtapasMandalas) &&
        e1?.docId == e2?.docId;
  }

  @override
  int hash(Desafio21Record? e) => const ListEquality().hash([
        e?.description,
        e?.title,
        e?.desafio21Data,
        e?.listaEtapasMandalas,
        e?.docId
      ]);

  @override
  bool isValidKey(Object? o) => o is Desafio21Record;
}
