import 'package:cloud_firestore/cloud_firestore.dart';

class FaqModel {
  final String id;
  final String pergunta;
  final String resposta;
  final String secao;
  final int ordem;
  final bool ativo;
  final DateTime? criadoEm;

  const FaqModel({
    required this.id,
    required this.pergunta,
    required this.resposta,
    required this.secao,
    this.ordem = 0,
    this.ativo = true,
    this.criadoEm,
  });

  factory FaqModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return FaqModel(
      id: doc.id,
      pergunta: data['pergunta'] as String? ?? '',
      resposta: data['resposta'] as String? ?? '',
      secao: data['secao'] as String? ?? '',
      ordem: data['ordem'] as int? ?? 0,
      ativo: data['ativo'] as bool? ?? true,
      criadoEm: _parseTimestamp(data['criadoEm']),
    );
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    try {
      return (value as Timestamp).toDate();
    } catch (_) {
      return null;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FaqModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
