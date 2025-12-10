// ignore_for_file: unnecessary_getters_setters
import 'package:medita_b_k/utils/algolia_serialization_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:medita_b_k/core/structs/util/firestore_util.dart';

import 'index.dart';
import 'package:medita_b_k/ui/core/flutter_flow/flutter_flow_util.dart';

class D21EtapaModelStruct extends FFFirebaseStruct {
  D21EtapaModelStruct({
    int? etapa,
    int? diaiInicioEtapa,
    List<D21MandalaModelStruct>? listaMandalas,
    String? textoMandalaCompleta,
    String? textoCompartilharMandala,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _etapa = etapa,
        _diaiInicioEtapa = diaiInicioEtapa,
        _listaMandalas = listaMandalas,
        _textoMandalaCompleta = textoMandalaCompleta,
        _textoCompartilharMandala = textoCompartilharMandala,
        super(firestoreUtilData);

  // "etapa" field.
  int? _etapa;
  int get etapa => _etapa ?? 0;
  set etapa(int? val) => _etapa = val;

  void incrementEtapa(int amount) => etapa = etapa + amount;

  bool hasEtapa() => _etapa != null;

  // "diaiInicioEtapa" field.
  int? _diaiInicioEtapa;
  int get diaiInicioEtapa => _diaiInicioEtapa ?? 0;
  set diaiInicioEtapa(int? val) => _diaiInicioEtapa = val;

  void incrementDiaiInicioEtapa(int amount) => diaiInicioEtapa = diaiInicioEtapa + amount;

  bool hasDiaiInicioEtapa() => _diaiInicioEtapa != null;

  // "listaMandalas" field.
  List<D21MandalaModelStruct>? _listaMandalas;
  List<D21MandalaModelStruct> get listaMandalas => _listaMandalas ?? const [];
  set listaMandalas(List<D21MandalaModelStruct>? val) => _listaMandalas = val;

  void updateListaMandalas(Function(List<D21MandalaModelStruct>) updateFn) {
    updateFn(_listaMandalas ??= []);
  }

  bool hasListaMandalas() => _listaMandalas != null;

  // "textoMandalaCompleta" field.
  String? _textoMandalaCompleta;
  String get textoMandalaCompleta => _textoMandalaCompleta ?? '';
  set textoMandalaCompleta(String? val) => _textoMandalaCompleta = val;

  bool hasTextoMandalaCompleta() => _textoMandalaCompleta != null;

  // "textoCompartilharMandala" field.
  String? _textoCompartilharMandala;
  String get textoCompartilharMandala => _textoCompartilharMandala ?? '';
  set textoCompartilharMandala(String? val) => _textoCompartilharMandala = val;

  bool hasTextoCompartilharMandala() => _textoCompartilharMandala != null;

  static D21EtapaModelStruct fromMap(Map<String, dynamic> data) => D21EtapaModelStruct(
        etapa: castToType<int>(data['etapa']),
        diaiInicioEtapa: castToType<int>(data['diaiInicioEtapa']),
        listaMandalas: getStructList(
          data['listaMandalas'],
          D21MandalaModelStruct.fromMap,
        ),
        textoMandalaCompleta: data['textoMandalaCompleta'] as String?,
        textoCompartilharMandala: data['textoCompartilharMandala'] as String?,
      );

  static D21EtapaModelStruct? maybeFromMap(dynamic data) =>
      data is Map ? D21EtapaModelStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'etapa': _etapa,
        'diaiInicioEtapa': _diaiInicioEtapa,
        'listaMandalas': _listaMandalas?.map((e) => e.toMap()).toList(),
        'textoMandalaCompleta': _textoMandalaCompleta,
        'textoCompartilharMandala': _textoCompartilharMandala,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'etapa': serializeParam(
          _etapa,
          ParamType.int,
        ),
        'diaiInicioEtapa': serializeParam(
          _diaiInicioEtapa,
          ParamType.int,
        ),
        'listaMandalas': serializeParam(
          _listaMandalas,
          ParamType.DataStruct,
          isList: true,
        ),
        'textoMandalaCompleta': serializeParam(
          _textoMandalaCompleta,
          ParamType.String,
        ),
        'textoCompartilharMandala': serializeParam(
          _textoCompartilharMandala,
          ParamType.String,
        ),
      }.withoutNulls;

  static D21EtapaModelStruct fromSerializableMap(Map<String, dynamic> data) => D21EtapaModelStruct(
        etapa: deserializeParam(
          data['etapa'],
          ParamType.int,
          false,
        ),
        diaiInicioEtapa: deserializeParam(
          data['diaiInicioEtapa'],
          ParamType.int,
          false,
        ),
        listaMandalas: deserializeStructParam<D21MandalaModelStruct>(
          data['listaMandalas'],
          ParamType.DataStruct,
          true,
          structBuilder: D21MandalaModelStruct.fromSerializableMap,
        ),
        textoMandalaCompleta: deserializeParam(
          data['textoMandalaCompleta'],
          ParamType.String,
          false,
        ),
        textoCompartilharMandala: deserializeParam(
          data['textoCompartilharMandala'],
          ParamType.String,
          false,
        ),
      );

  static D21EtapaModelStruct fromAlgoliaData(Map<String, dynamic> data) => D21EtapaModelStruct(
        etapa: convertAlgoliaParam(
          data['etapa'],
          ParamType.int,
          false,
        ),
        diaiInicioEtapa: convertAlgoliaParam(
          data['diaiInicioEtapa'],
          ParamType.int,
          false,
        ),
        listaMandalas: convertAlgoliaParam<D21MandalaModelStruct>(
          data['listaMandalas'],
          ParamType.DataStruct,
          true,
          structBuilder: D21MandalaModelStruct.fromAlgoliaData,
        ),
        textoMandalaCompleta: convertAlgoliaParam(
          data['textoMandalaCompleta'],
          ParamType.String,
          false,
        ),
        textoCompartilharMandala: convertAlgoliaParam(
          data['textoCompartilharMandala'],
          ParamType.String,
          false,
        ),
        firestoreUtilData: const FirestoreUtilData(
          clearUnsetFields: false,
          create: true,
        ),
      );

  @override
  String toString() => 'D21EtapaModelStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is D21EtapaModelStruct &&
        etapa == other.etapa &&
        diaiInicioEtapa == other.diaiInicioEtapa &&
        listEquality.equals(listaMandalas, other.listaMandalas) &&
        textoMandalaCompleta == other.textoMandalaCompleta &&
        textoCompartilharMandala == other.textoCompartilharMandala;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([etapa, diaiInicioEtapa, listaMandalas, textoMandalaCompleta, textoCompartilharMandala]);
}

D21EtapaModelStruct createD21EtapaModelStruct({
  int? etapa,
  int? diaiInicioEtapa,
  String? textoMandalaCompleta,
  String? textoCompartilharMandala,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    D21EtapaModelStruct(
      etapa: etapa,
      diaiInicioEtapa: diaiInicioEtapa,
      textoMandalaCompleta: textoMandalaCompleta,
      textoCompartilharMandala: textoCompartilharMandala,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

D21EtapaModelStruct? updateD21EtapaModelStruct(
  D21EtapaModelStruct? d21EtapaModel, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    d21EtapaModel
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addD21EtapaModelStructData(
  Map<String, dynamic> firestoreData,
  D21EtapaModelStruct? d21EtapaModel,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (d21EtapaModel == null) {
    return;
  }
  if (d21EtapaModel.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue && d21EtapaModel.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final d21EtapaModelData = getD21EtapaModelFirestoreData(d21EtapaModel, forFieldValue);
  final nestedData = d21EtapaModelData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = d21EtapaModel.firestoreUtilData.create || clearFields;
  firestoreData.addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getD21EtapaModelFirestoreData(
  D21EtapaModelStruct? d21EtapaModel, [
  bool forFieldValue = false,
]) {
  if (d21EtapaModel == null) {
    return {};
  }
  final firestoreData = mapToFirestore(d21EtapaModel.toMap());

  // Add any Firestore field values
  d21EtapaModel.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getD21EtapaModelListFirestoreData(
  List<D21EtapaModelStruct>? d21EtapaModels,
) =>
    d21EtapaModels?.map((e) => getD21EtapaModelFirestoreData(e, true)).toList() ?? [];
