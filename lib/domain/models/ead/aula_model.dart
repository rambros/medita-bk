import 'package:cloud_firestore/cloud_firestore.dart';

import 'topico_model.dart';

/// Model para Aula no Mobile
/// Representa uma unidade/módulo de ensino dentro de um curso
/// Equivalente a "Section" no lib_sample
class AulaModel {
  final String id;
  final String titulo;
  final String? descricao;
  final int ordem;
  final int totalTopicos;
  final String? duracaoEstimada;
  final DateTime? dataCriacao;

  // Lista de tópicos (carregada sob demanda)
  final List<TopicoModel> topicos;

  // Campo auxiliar (não persistido)
  final String? cursoId;

  const AulaModel({
    required this.id,
    required this.titulo,
    this.descricao,
    this.ordem = 0,
    this.totalTopicos = 0,
    this.duracaoEstimada,
    this.dataCriacao,
    this.topicos = const [],
    this.cursoId,
  });

  factory AulaModel.fromFirestore(DocumentSnapshot doc, {String? cursoId}) {
    final map = doc.data() as Map<String, dynamic>? ?? {};
    return AulaModel.fromMap(map, doc.id, cursoId: cursoId);
  }

  factory AulaModel.fromMap(Map<String, dynamic> map, String id, {String? cursoId}) {
    return AulaModel(
      id: id,
      titulo: map['titulo'] as String? ?? '',
      descricao: map['descricao'] as String?,
      ordem: _parseInt(map['ordem']),
      totalTopicos: _parseInt(map['totalTopicos']),
      duracaoEstimada: map['duracaoEstimada'] as String?,
      dataCriacao: _parseTimestamp(map['dataCriacao']),
      cursoId: cursoId,
      // Tópicos são carregados separadamente
      topicos: const [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'ordem': ordem,
      'totalTopicos': totalTopicos,
      'duracaoEstimada': duracaoEstimada,
      'dataCriacao': dataCriacao,
    };
  }

  AulaModel copyWith({
    String? id,
    String? titulo,
    String? descricao,
    int? ordem,
    int? totalTopicos,
    String? duracaoEstimada,
    DateTime? dataCriacao,
    List<TopicoModel>? topicos,
    String? cursoId,
  }) {
    return AulaModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      ordem: ordem ?? this.ordem,
      totalTopicos: totalTopicos ?? this.totalTopicos,
      duracaoEstimada: duracaoEstimada ?? this.duracaoEstimada,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      topicos: topicos ?? this.topicos,
      cursoId: cursoId ?? this.cursoId,
    );
  }

  // === Getters úteis ===

  /// Retorna o número real de tópicos se carregados, senão o contador
  int get numeroTopicos => topicos.isNotEmpty ? topicos.length : totalTopicos;

  /// Verifica se a aula tem conteúdo
  bool get hasContent => numeroTopicos > 0;

  /// Calcula a duração total dos tópicos (se disponível)
  int get duracaoTotalSegundos {
    return topicos.fold(0, (total, topico) {
      return total + (topico.duracao ?? 0);
    });
  }

  /// Retorna a duração total formatada
  String get duracaoTotalFormatada {
    final total = duracaoTotalSegundos;
    if (total == 0) return duracaoEstimada ?? '';
    final minutos = total ~/ 60;
    final segundos = total % 60;
    if (minutos >= 60) {
      final horas = minutos ~/ 60;
      final mins = minutos % 60;
      return '${horas}h ${mins}min';
    }
    return '$minutos:${segundos.toString().padLeft(2, '0')}';
  }

  // === Helpers estáticos ===

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AulaModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AulaModel(id: $id, titulo: $titulo, topicos: ${topicos.length})';
}
