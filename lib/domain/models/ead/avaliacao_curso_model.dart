import 'package:cloud_firestore/cloud_firestore.dart';
import 'pergunta_avaliacao_model.dart';

/// Modelo para a avaliação completa de um curso
/// Compatível com o modelo do Web Admin
/// A avaliação é armazenada como subcampo do documento do curso (1 leitura, mais performático)
class AvaliacaoCursoModel {
  final String titulo;
  final String? descricao;
  final bool obrigatoria;
  final int versao;
  final List<PerguntaAvaliacaoModel> perguntas;
  final DateTime? dataCriacao;
  final DateTime? dataAtualizacao;

  const AvaliacaoCursoModel({
    this.titulo = 'Avaliação do Curso',
    this.descricao = 'Sua opinião é muito importante para nós!',
    this.obrigatoria = false,
    this.versao = 1,
    this.perguntas = const [],
    this.dataCriacao,
    this.dataAtualizacao,
  });

  factory AvaliacaoCursoModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const AvaliacaoCursoModel();

    // Converter perguntas do mapa (compatível com formato do Admin)
    final perguntasList = map['perguntas'] as List<dynamic>? ?? [];
    final perguntas = perguntasList
        .asMap()
        .entries
        .map((entry) => PerguntaAvaliacaoModel.fromMap(
              entry.value as Map<String, dynamic>,
              entry.key.toString(), // Usar índice como ID temporário
            ))
        .toList();

    return AvaliacaoCursoModel(
      titulo: map['titulo'] as String? ?? 'Avaliação do Curso',
      descricao: map['descricao'] as String?,
      obrigatoria: map['obrigatoria'] as bool? ?? false,
      versao: map['versao'] as int? ?? 1,
      perguntas: perguntas,
      dataCriacao: _parseTimestamp(map['dataCriacao']),
      dataAtualizacao: _parseTimestamp(map['dataAtualizacao']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      if (descricao != null) 'descricao': descricao,
      'obrigatoria': obrigatoria,
      'versao': versao,
      'perguntas': perguntas.map((p) => p.toMap()).toList(),
      if (dataCriacao != null) 'dataCriacao': dataCriacao,
      if (dataAtualizacao != null) 'dataAtualizacao': dataAtualizacao,
    };
  }

  /// Retorna lista de perguntas ordenadas
  List<PerguntaAvaliacaoModel> get perguntasOrdenadas {
    final lista = List<PerguntaAvaliacaoModel>.from(perguntas);
    lista.sort((a, b) => a.ordem.compareTo(b.ordem));
    return lista;
  }

  /// Retorna apenas perguntas obrigatórias
  List<PerguntaAvaliacaoModel> get perguntasObrigatorias {
    return perguntas.where((p) => p.obrigatoria).toList();
  }

  /// Verifica se tem perguntas
  bool get hasPerguntas => perguntas.isNotEmpty;

  /// Total de perguntas
  int get totalPerguntas => perguntas.length;

  /// Total de perguntas obrigatórias
  int get totalObrigatorias => perguntasObrigatorias.length;

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  AvaliacaoCursoModel copyWith({
    String? titulo,
    String? descricao,
    bool? obrigatoria,
    int? versao,
    List<PerguntaAvaliacaoModel>? perguntas,
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
  }) {
    return AvaliacaoCursoModel(
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      obrigatoria: obrigatoria ?? this.obrigatoria,
      versao: versao ?? this.versao,
      perguntas: perguntas ?? this.perguntas,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }

  @override
  String toString() => 'AvaliacaoCursoModel(titulo: $titulo, perguntas: ${perguntas.length})';
}
