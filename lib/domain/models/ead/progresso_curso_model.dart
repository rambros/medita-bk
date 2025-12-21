import 'package:cloud_firestore/cloud_firestore.dart';

/// Model para progresso do aluno no curso
/// Compatível com ProgressoCursoModel do Web Admin
class ProgressoCursoModel {
  final List<String> aulasCompletas;
  final List<String> topicosCompletos;
  final String? ultimoTopicoId;
  final String? ultimaAulaId;
  final DateTime? ultimoAcesso;
  final double percentualConcluido;

  const ProgressoCursoModel({
    this.aulasCompletas = const [],
    this.topicosCompletos = const [],
    this.ultimoTopicoId,
    this.ultimaAulaId,
    this.ultimoAcesso,
    this.percentualConcluido = 0,
  });

  factory ProgressoCursoModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const ProgressoCursoModel();

    return ProgressoCursoModel(
      aulasCompletas: _parseStringList(map['aulasCompletas']),
      topicosCompletos: _parseStringList(map['topicosCompletos']),
      ultimoTopicoId: map['ultimoTopico'] as String? ?? map['ultimoTopicoId'] as String?,
      ultimaAulaId: map['ultimaAulaId'] as String?,
      ultimoAcesso: _parseTimestamp(map['ultimoAcesso']),
      percentualConcluido: (map['percentualConcluido'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'aulasCompletas': aulasCompletas,
      'topicosCompletos': topicosCompletos,
      'ultimoTopico': ultimoTopicoId,
      'ultimaAulaId': ultimaAulaId,
      'ultimoAcesso': ultimoAcesso,
      'percentualConcluido': percentualConcluido,
    };
  }

  ProgressoCursoModel copyWith({
    List<String>? aulasCompletas,
    List<String>? topicosCompletos,
    String? ultimoTopicoId,
    String? ultimaAulaId,
    DateTime? ultimoAcesso,
    double? percentualConcluido,
  }) {
    return ProgressoCursoModel(
      aulasCompletas: aulasCompletas ?? this.aulasCompletas,
      topicosCompletos: topicosCompletos ?? this.topicosCompletos,
      ultimoTopicoId: ultimoTopicoId ?? this.ultimoTopicoId,
      ultimaAulaId: ultimaAulaId ?? this.ultimaAulaId,
      ultimoAcesso: ultimoAcesso ?? this.ultimoAcesso,
      percentualConcluido: percentualConcluido ?? this.percentualConcluido,
    );
  }

  // === Métodos de verificação ===

  /// Verifica se uma aula está completa
  bool isAulaCompleta(String aulaId) => aulasCompletas.contains(aulaId);

  /// Verifica se um tópico está completo
  bool isTopicoCompleto(String topicoId) => topicosCompletos.contains(topicoId);

  /// Retorna o percentual formatado
  String get percentualFormatado => '${percentualConcluido.toStringAsFixed(0)}%';

  /// Número de tópicos completos
  int get totalTopicosCompletos => topicosCompletos.length;

  /// Número de aulas completas
  int get totalAulasCompletas => aulasCompletas.length;

  /// Verifica se tem algum progresso (completos ou apenas acesso)
  bool get hasProgresso => topicosCompletos.isNotEmpty || ultimoTopicoId != null;

  /// Verifica se concluiu 100%
  bool get isConcluido => percentualConcluido >= 100;

  // === Métodos para atualização ===

  /// Adiciona um tópico como completo
  ProgressoCursoModel adicionarTopicoCompleto(String topicoId) {
    if (topicosCompletos.contains(topicoId)) return this;
    return copyWith(
      topicosCompletos: [...topicosCompletos, topicoId],
      ultimoAcesso: DateTime.now(),
    );
  }

  /// Remove um tópico da lista de completos
  ProgressoCursoModel removerTopicoCompleto(String topicoId) {
    if (!topicosCompletos.contains(topicoId)) return this;
    return copyWith(
      topicosCompletos: topicosCompletos.where((id) => id != topicoId).toList(),
      ultimoAcesso: DateTime.now(),
    );
  }

  /// Adiciona uma aula como completa
  ProgressoCursoModel adicionarAulaCompleta(String aulaId) {
    if (aulasCompletas.contains(aulaId)) return this;
    return copyWith(
      aulasCompletas: [...aulasCompletas, aulaId],
      ultimoAcesso: DateTime.now(),
    );
  }

  /// Atualiza o último tópico acessado
  ProgressoCursoModel atualizarUltimoAcesso(String topicoId, String aulaId) {
    return copyWith(
      ultimoTopicoId: topicoId,
      ultimaAulaId: aulaId,
      ultimoAcesso: DateTime.now(),
    );
  }

  // === Helpers estáticos ===

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  @override
  String toString() => 'ProgressoCursoModel(percentual: $percentualConcluido%)';
}
