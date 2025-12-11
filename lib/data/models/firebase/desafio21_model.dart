import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:medita_bk/core/structs/d21_etapa_model_struct.dart';
import 'package:medita_bk/core/structs/d21_model_struct.dart';
import 'package:medita_bk/core/structs/util/firestore_util.dart';

/// Pure Dart model for Desafio21 template documents
class Desafio21Model extends Equatable {
  final String id;
  final String description;
  final String title;
  final D21ModelStruct desafio21Data;
  final List<D21EtapaModelStruct> listaEtapasMandalas;
  final int docId;

  const Desafio21Model({
    required this.id,
    required this.description,
    required this.title,
    required this.desafio21Data,
    required this.listaEtapasMandalas,
    required this.docId,
  });

  Desafio21Model copyWith({
    String? id,
    String? description,
    String? title,
    D21ModelStruct? desafio21Data,
    List<D21EtapaModelStruct>? listaEtapasMandalas,
    int? docId,
  }) {
    return Desafio21Model(
      id: id ?? this.id,
      description: description ?? this.description,
      title: title ?? this.title,
      desafio21Data: desafio21Data ?? this.desafio21Data,
      listaEtapasMandalas: listaEtapasMandalas ?? this.listaEtapasMandalas,
      docId: docId ?? this.docId,
    );
  }

  factory Desafio21Model.fromFirestore(DocumentSnapshot doc) {
    final rawData = doc.data() as Map<String, dynamic>? ?? {};
    final data = mapFromFirestore(Map<String, dynamic>.from(rawData));

    final desafioData = data['desafio21'] ?? data['desafio21Data'] ?? {};

    return Desafio21Model(
      id: doc.id,
      description: (data['description'] as String?) ?? '',
      title: (data['title'] as String?) ?? '',
      desafio21Data: desafioData is D21ModelStruct
          ? desafioData
          : D21ModelStruct.maybeFromMap(Map<String, dynamic>.from(desafioData)) ?? D21ModelStruct(),
      listaEtapasMandalas: (data['listaEtapasMandalas'] as List<dynamic>?)
              ?.map((e) {
                if (e is D21EtapaModelStruct) return e;
                if (e is Map<String, dynamic>) {
                  return D21EtapaModelStruct.maybeFromMap(e) ?? D21EtapaModelStruct();
                }
                return D21EtapaModelStruct();
              }).toList() ??
          const [],
      docId: (data['docId'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    final data = <String, dynamic>{
      'description': description,
      'title': title,
      'desafio21': desafio21Data.toMap(),
      'listaEtapasMandalas': listaEtapasMandalas.map((e) => e.toMap()).toList(),
      'docId': docId,
    };
    return mapToFirestore(data);
  }

  @override
  List<Object?> get props => [id, description, title, desafio21Data, listaEtapasMandalas, docId];
}
