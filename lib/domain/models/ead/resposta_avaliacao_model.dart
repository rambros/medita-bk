import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo para resposta de avaliação do aluno
class RespostaAvaliacaoModel {
  final String inscricaoId;
  final String cursoId;
  final String usuarioId;
  final String usuarioNome;
  final String usuarioEmail;
  final Map<String, dynamic> respostas; // perguntaId -> resposta
  final DateTime? dataPreenchimento;
  final int tempoPreenchimentoSegundos;
  final int versaoAvaliacao;

  const RespostaAvaliacaoModel({
    required this.inscricaoId,
    required this.cursoId,
    required this.usuarioId,
    required this.usuarioNome,
    required this.usuarioEmail,
    this.respostas = const {},
    this.dataPreenchimento,
    this.tempoPreenchimentoSegundos = 0,
    this.versaoAvaliacao = 1,
  });

  factory RespostaAvaliacaoModel.criar({
    required String inscricaoId,
    required String cursoId,
    required String usuarioId,
    required String usuarioNome,
    required String usuarioEmail,
    required Map<String, dynamic> respostas,
    required int tempoPreenchimentoSegundos,
    int versaoAvaliacao = 1,
  }) {
    return RespostaAvaliacaoModel(
      inscricaoId: inscricaoId,
      cursoId: cursoId,
      usuarioId: usuarioId,
      usuarioNome: usuarioNome,
      usuarioEmail: usuarioEmail,
      respostas: respostas,
      dataPreenchimento: DateTime.now(),
      tempoPreenchimentoSegundos: tempoPreenchimentoSegundos,
      versaoAvaliacao: versaoAvaliacao,
    );
  }

  factory RespostaAvaliacaoModel.fromMap(Map<String, dynamic> map, String id) {
    return RespostaAvaliacaoModel(
      inscricaoId: id,
      cursoId: map['cursoId'] as String? ?? '',
      usuarioId: map['usuarioId'] as String? ?? '',
      usuarioNome: map['usuarioNome'] as String? ?? '',
      usuarioEmail: map['usuarioEmail'] as String? ?? '',
      respostas: Map<String, dynamic>.from(map['respostas'] as Map<String, dynamic>? ?? {}),
      dataPreenchimento: _parseTimestamp(map['dataPreenchimento']),
      tempoPreenchimentoSegundos: map['tempoPreenchimentoSegundos'] as int? ?? 0,
      versaoAvaliacao: map['versaoAvaliacao'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'inscricaoId': inscricaoId,
      'cursoId': cursoId,
      'usuarioId': usuarioId,
      'usuarioNome': usuarioNome,
      'usuarioEmail': usuarioEmail,
      'respostas': respostas,
      'dataPreenchimento': dataPreenchimento ?? FieldValue.serverTimestamp(),
      'tempoPreenchimentoSegundos': tempoPreenchimentoSegundos,
      'versaoAvaliacao': versaoAvaliacao,
    };
  }

  /// Retorna resposta de uma pergunta específica
  dynamic getResposta(String perguntaId) {
    return respostas[perguntaId];
  }

  /// Verifica se uma pergunta foi respondida
  bool isRespondida(String perguntaId) {
    final resposta = respostas[perguntaId];
    if (resposta == null) return false;
    if (resposta is String) return resposta.trim().isNotEmpty;
    return true;
  }

  /// Total de perguntas respondidas
  int get totalRespondidas => respostas.length;

  /// Tempo formatado (ex: "3min 20s")
  String get tempoFormatado {
    final minutos = tempoPreenchimentoSegundos ~/ 60;
    final segundos = tempoPreenchimentoSegundos % 60;
    if (minutos > 0) {
      return '${minutos}min ${segundos}s';
    }
    return '${segundos}s';
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  RespostaAvaliacaoModel copyWith({
    String? inscricaoId,
    String? cursoId,
    String? usuarioId,
    String? usuarioNome,
    String? usuarioEmail,
    Map<String, dynamic>? respostas,
    DateTime? dataPreenchimento,
    int? tempoPreenchimentoSegundos,
    int? versaoAvaliacao,
  }) {
    return RespostaAvaliacaoModel(
      inscricaoId: inscricaoId ?? this.inscricaoId,
      cursoId: cursoId ?? this.cursoId,
      usuarioId: usuarioId ?? this.usuarioId,
      usuarioNome: usuarioNome ?? this.usuarioNome,
      usuarioEmail: usuarioEmail ?? this.usuarioEmail,
      respostas: respostas ?? this.respostas,
      dataPreenchimento: dataPreenchimento ?? this.dataPreenchimento,
      tempoPreenchimentoSegundos: tempoPreenchimentoSegundos ?? this.tempoPreenchimentoSegundos,
      versaoAvaliacao: versaoAvaliacao ?? this.versaoAvaliacao,
    );
  }

  @override
  String toString() => 'RespostaAvaliacaoModel(inscricaoId: $inscricaoId, respostas: ${respostas.length})';
}
