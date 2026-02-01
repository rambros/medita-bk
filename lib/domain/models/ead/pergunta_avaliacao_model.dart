import 'avaliacao_enums.dart';

/// Modelo para uma pergunta de avaliação
/// Compatível com o modelo do Web Admin
class PerguntaAvaliacaoModel {
  final String id;
  final String texto;
  final TipoPerguntaAvaliacao tipo;
  final bool obrigatoria;
  final int ordem;
  final List<String>? opcoes; // Para múltipla escolha
  final String? descricao; // Texto de ajuda opcional (compatibilidade com Admin)

  const PerguntaAvaliacaoModel({
    required this.id,
    required this.texto,
    required this.tipo,
    this.obrigatoria = false,
    this.ordem = 0,
    this.opcoes,
    this.descricao,
  });

  /// Factory que aceita ID como parâmetro separado (compatível com Admin)
  factory PerguntaAvaliacaoModel.fromMap(Map<String, dynamic> map, String id) {
    return PerguntaAvaliacaoModel(
      id: id,
      texto: map['texto'] as String? ?? '',
      tipo: TipoPerguntaAvaliacao.fromString(map['tipo'] as String?),
      obrigatoria: map['obrigatoria'] as bool? ?? false,
      ordem: map['ordem'] as int? ?? 0,
      opcoes: map['opcoes'] != null ? List<String>.from(map['opcoes'] as List) : null,
      descricao: map['descricao'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'texto': texto,
      'tipo': tipo.name,
      'obrigatoria': obrigatoria,
      'ordem': ordem,
      if (opcoes != null) 'opcoes': opcoes,
      if (descricao != null) 'descricao': descricao,
    };
  }

  PerguntaAvaliacaoModel copyWith({
    String? id,
    String? texto,
    TipoPerguntaAvaliacao? tipo,
    bool? obrigatoria,
    int? ordem,
    List<String>? opcoes,
    String? descricao,
  }) {
    return PerguntaAvaliacaoModel(
      id: id ?? this.id,
      texto: texto ?? this.texto,
      tipo: tipo ?? this.tipo,
      obrigatoria: obrigatoria ?? this.obrigatoria,
      ordem: ordem ?? this.ordem,
      opcoes: opcoes ?? this.opcoes,
      descricao: descricao ?? this.descricao,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PerguntaAvaliacaoModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PerguntaAvaliacaoModel(id: $id, texto: $texto)';
}
