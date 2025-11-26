// ignore_for_file: unnecessary_getters_setters
import '/utils/algolia_serialization_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/core/structs/util/firestore_util.dart';

import '/ui/core/flutter_flow/flutter_flow_util.dart';

class D21BrasaoModelStruct extends FFFirebaseStruct {
  D21BrasaoModelStruct({
    String? nome,
    String? header,
    String? descricao,
    String? brasaoUrl,
    String? premio,
    String? pdfUrl,
    String? pdfFilename,
    String? textoConquistaBrasao,
    String? ebookImageUrl,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _nome = nome,
        _header = header,
        _descricao = descricao,
        _brasaoUrl = brasaoUrl,
        _premio = premio,
        _pdfUrl = pdfUrl,
        _pdfFilename = pdfFilename,
        _textoConquistaBrasao = textoConquistaBrasao,
        _ebookImageUrl = ebookImageUrl,
        super(firestoreUtilData);

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "header" field.
  String? _header;
  String get header => _header ?? '';
  set header(String? val) => _header = val;

  bool hasHeader() => _header != null;

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  set descricao(String? val) => _descricao = val;

  bool hasDescricao() => _descricao != null;

  // "brasao_url" field.
  String? _brasaoUrl;
  String get brasaoUrl => _brasaoUrl ?? '';
  set brasaoUrl(String? val) => _brasaoUrl = val;

  bool hasBrasaoUrl() => _brasaoUrl != null;

  // "premio" field.
  String? _premio;
  String get premio => _premio ?? '';
  set premio(String? val) => _premio = val;

  bool hasPremio() => _premio != null;

  // "pdf_url" field.
  String? _pdfUrl;
  String get pdfUrl => _pdfUrl ?? '';
  set pdfUrl(String? val) => _pdfUrl = val;

  bool hasPdfUrl() => _pdfUrl != null;

  // "pdf_filename" field.
  String? _pdfFilename;
  String get pdfFilename => _pdfFilename ?? '';
  set pdfFilename(String? val) => _pdfFilename = val;

  bool hasPdfFilename() => _pdfFilename != null;

  // "texto_conquista_brasao" field.
  String? _textoConquistaBrasao;
  String get textoConquistaBrasao => _textoConquistaBrasao ?? '';
  set textoConquistaBrasao(String? val) => _textoConquistaBrasao = val;

  bool hasTextoConquistaBrasao() => _textoConquistaBrasao != null;

  // "ebook_image_url" field.
  String? _ebookImageUrl;
  String get ebookImageUrl => _ebookImageUrl ?? '';
  set ebookImageUrl(String? val) => _ebookImageUrl = val;

  bool hasEbookImageUrl() => _ebookImageUrl != null;

  static D21BrasaoModelStruct fromMap(Map<String, dynamic> data) => D21BrasaoModelStruct(
        nome: data['nome'] as String?,
        header: data['header'] as String?,
        descricao: data['descricao'] as String?,
        brasaoUrl: data['brasao_url'] as String?,
        premio: data['premio'] as String?,
        pdfUrl: data['pdf_url'] as String?,
        pdfFilename: data['pdf_filename'] as String?,
        textoConquistaBrasao: data['texto_conquista_brasao'] as String?,
        ebookImageUrl: data['ebook_image_url'] as String?,
      );

  static D21BrasaoModelStruct? maybeFromMap(dynamic data) =>
      data is Map ? D21BrasaoModelStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'nome': _nome,
        'header': _header,
        'descricao': _descricao,
        'brasao_url': _brasaoUrl,
        'premio': _premio,
        'pdf_url': _pdfUrl,
        'pdf_filename': _pdfFilename,
        'texto_conquista_brasao': _textoConquistaBrasao,
        'ebook_image_url': _ebookImageUrl,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'header': serializeParam(
          _header,
          ParamType.String,
        ),
        'descricao': serializeParam(
          _descricao,
          ParamType.String,
        ),
        'brasao_url': serializeParam(
          _brasaoUrl,
          ParamType.String,
        ),
        'premio': serializeParam(
          _premio,
          ParamType.String,
        ),
        'pdf_url': serializeParam(
          _pdfUrl,
          ParamType.String,
        ),
        'pdf_filename': serializeParam(
          _pdfFilename,
          ParamType.String,
        ),
        'texto_conquista_brasao': serializeParam(
          _textoConquistaBrasao,
          ParamType.String,
        ),
        'ebook_image_url': serializeParam(
          _ebookImageUrl,
          ParamType.String,
        ),
      }.withoutNulls;

  static D21BrasaoModelStruct fromSerializableMap(Map<String, dynamic> data) => D21BrasaoModelStruct(
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        header: deserializeParam(
          data['header'],
          ParamType.String,
          false,
        ),
        descricao: deserializeParam(
          data['descricao'],
          ParamType.String,
          false,
        ),
        brasaoUrl: deserializeParam(
          data['brasao_url'],
          ParamType.String,
          false,
        ),
        premio: deserializeParam(
          data['premio'],
          ParamType.String,
          false,
        ),
        pdfUrl: deserializeParam(
          data['pdf_url'],
          ParamType.String,
          false,
        ),
        pdfFilename: deserializeParam(
          data['pdf_filename'],
          ParamType.String,
          false,
        ),
        textoConquistaBrasao: deserializeParam(
          data['texto_conquista_brasao'],
          ParamType.String,
          false,
        ),
        ebookImageUrl: deserializeParam(
          data['ebook_image_url'],
          ParamType.String,
          false,
        ),
      );

  static D21BrasaoModelStruct fromAlgoliaData(Map<String, dynamic> data) => D21BrasaoModelStruct(
        nome: convertAlgoliaParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        header: convertAlgoliaParam(
          data['header'],
          ParamType.String,
          false,
        ),
        descricao: convertAlgoliaParam(
          data['descricao'],
          ParamType.String,
          false,
        ),
        brasaoUrl: convertAlgoliaParam(
          data['brasao_url'],
          ParamType.String,
          false,
        ),
        premio: convertAlgoliaParam(
          data['premio'],
          ParamType.String,
          false,
        ),
        pdfUrl: convertAlgoliaParam(
          data['pdf_url'],
          ParamType.String,
          false,
        ),
        pdfFilename: convertAlgoliaParam(
          data['pdf_filename'],
          ParamType.String,
          false,
        ),
        textoConquistaBrasao: convertAlgoliaParam(
          data['texto_conquista_brasao'],
          ParamType.String,
          false,
        ),
        ebookImageUrl: convertAlgoliaParam(
          data['ebook_image_url'],
          ParamType.String,
          false,
        ),
        firestoreUtilData: const FirestoreUtilData(
          clearUnsetFields: false,
          create: true,
        ),
      );

  @override
  String toString() => 'D21BrasaoModelStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is D21BrasaoModelStruct &&
        nome == other.nome &&
        header == other.header &&
        descricao == other.descricao &&
        brasaoUrl == other.brasaoUrl &&
        premio == other.premio &&
        pdfUrl == other.pdfUrl &&
        pdfFilename == other.pdfFilename &&
        textoConquistaBrasao == other.textoConquistaBrasao &&
        ebookImageUrl == other.ebookImageUrl;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([nome, header, descricao, brasaoUrl, premio, pdfUrl, pdfFilename, textoConquistaBrasao, ebookImageUrl]);
}

D21BrasaoModelStruct createD21BrasaoModelStruct({
  String? nome,
  String? header,
  String? descricao,
  String? brasaoUrl,
  String? premio,
  String? pdfUrl,
  String? pdfFilename,
  String? textoConquistaBrasao,
  String? ebookImageUrl,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    D21BrasaoModelStruct(
      nome: nome,
      header: header,
      descricao: descricao,
      brasaoUrl: brasaoUrl,
      premio: premio,
      pdfUrl: pdfUrl,
      pdfFilename: pdfFilename,
      textoConquistaBrasao: textoConquistaBrasao,
      ebookImageUrl: ebookImageUrl,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

D21BrasaoModelStruct? updateD21BrasaoModelStruct(
  D21BrasaoModelStruct? d21BrasaoModel, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    d21BrasaoModel
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addD21BrasaoModelStructData(
  Map<String, dynamic> firestoreData,
  D21BrasaoModelStruct? d21BrasaoModel,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (d21BrasaoModel == null) {
    return;
  }
  if (d21BrasaoModel.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue && d21BrasaoModel.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final d21BrasaoModelData = getD21BrasaoModelFirestoreData(d21BrasaoModel, forFieldValue);
  final nestedData = d21BrasaoModelData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = d21BrasaoModel.firestoreUtilData.create || clearFields;
  firestoreData.addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getD21BrasaoModelFirestoreData(
  D21BrasaoModelStruct? d21BrasaoModel, [
  bool forFieldValue = false,
]) {
  if (d21BrasaoModel == null) {
    return {};
  }
  final firestoreData = mapToFirestore(d21BrasaoModel.toMap());

  // Add any Firestore field values
  d21BrasaoModel.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getD21BrasaoModelListFirestoreData(
  List<D21BrasaoModelStruct>? d21BrasaoModels,
) =>
    d21BrasaoModels?.map((e) => getD21BrasaoModelFirestoreData(e, true)).toList() ?? [];
