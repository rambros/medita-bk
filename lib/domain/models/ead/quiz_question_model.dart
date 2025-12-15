import 'package:cloud_firestore/cloud_firestore.dart';

/// Tipo de pergunta do quiz
enum TipoPergunta {
  verdadeiroFalso,   // Duas opções fixas: Verdadeiro/Falso
  multiplaEscolha,   // 4-6 opções customizáveis, 1 correta
  multiplasRespostas // 4-6 opções customizáveis, N corretas
}

/// Model para uma opção de resposta do quiz
class QuizOpcaoModel {
  final String id;
  final String texto;
  final bool isCorreta;
  final int ordem;

  const QuizOpcaoModel({
    required this.id,
    required this.texto,
    this.isCorreta = false,
    this.ordem = 0,
  });

  factory QuizOpcaoModel.fromMap(Map<String, dynamic> map, [String? id]) {
    return QuizOpcaoModel(
      id: id ?? map['id'] as String? ?? '',
      texto: map['texto'] as String? ?? '',
      isCorreta: map['isCorreta'] as bool? ?? false,
      ordem: map['ordem'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'texto': texto,
      'isCorreta': isCorreta,
      'ordem': ordem,
    };
  }

  QuizOpcaoModel copyWith({
    String? id,
    String? texto,
    bool? isCorreta,
    int? ordem,
  }) {
    return QuizOpcaoModel(
      id: id ?? this.id,
      texto: texto ?? this.texto,
      isCorreta: isCorreta ?? this.isCorreta,
      ordem: ordem ?? this.ordem,
    );
  }

  @override
  String toString() => 'QuizOpcaoModel(id: $id, texto: $texto, correta: $isCorreta)';
}

/// Model para uma pergunta do quiz
class QuizQuestionModel {
  final String id;
  final String pergunta;
  final TipoPergunta tipo;
  final List<QuizOpcaoModel> opcoes;
  final int ordem;
  final String? explicacao; // Explicação mostrada após responder
  final int pontos;

  const QuizQuestionModel({
    required this.id,
    required this.pergunta,
    this.tipo = TipoPergunta.multiplaEscolha,
    this.opcoes = const [],
    this.ordem = 0,
    this.explicacao,
    this.pontos = 1,
  });

  factory QuizQuestionModel.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>? ?? {};
    return QuizQuestionModel.fromMap(map, doc.id);
  }

  factory QuizQuestionModel.fromMap(Map<String, dynamic> map, [String? id]) {
    final opcoesData = map['opcoes'] as List<dynamic>? ?? [];
    final tipoStr = map['tipo'] as String? ?? 'multipla_escolha';

    return QuizQuestionModel(
      id: id ?? map['id'] as String? ?? '',
      pergunta: map['pergunta'] as String? ?? '',
      tipo: _parseTipoPergunta(tipoStr),
      opcoes: opcoesData.asMap().entries.map((entry) {
        final opcaoMap = entry.value as Map<String, dynamic>;
        return QuizOpcaoModel.fromMap(opcaoMap, opcaoMap['id'] ?? 'opcao_${entry.key}');
      }).toList(),
      ordem: map['ordem'] as int? ?? 0,
      explicacao: map['explicacao'] as String?,
      pontos: map['pontos'] as int? ?? 1,
    );
  }

  static TipoPergunta _parseTipoPergunta(String tipoStr) {
    switch (tipoStr) {
      case 'verdadeiro_falso':
        return TipoPergunta.verdadeiroFalso;
      case 'multipla_escolha':
        return TipoPergunta.multiplaEscolha;
      case 'multiplas_respostas':
        return TipoPergunta.multiplasRespostas;
      default:
        return TipoPergunta.multiplaEscolha;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pergunta': pergunta,
      'tipo': _tipoToString(tipo),
      'opcoes': opcoes.map((o) => o.toMap()).toList(),
      'ordem': ordem,
      'explicacao': explicacao,
      'pontos': pontos,
    };
  }

  static String _tipoToString(TipoPergunta tipo) {
    switch (tipo) {
      case TipoPergunta.verdadeiroFalso:
        return 'verdadeiro_falso';
      case TipoPergunta.multiplaEscolha:
        return 'multipla_escolha';
      case TipoPergunta.multiplasRespostas:
        return 'multiplas_respostas';
    }
  }

  QuizQuestionModel copyWith({
    String? id,
    String? pergunta,
    TipoPergunta? tipo,
    List<QuizOpcaoModel>? opcoes,
    int? ordem,
    String? explicacao,
    int? pontos,
  }) {
    return QuizQuestionModel(
      id: id ?? this.id,
      pergunta: pergunta ?? this.pergunta,
      tipo: tipo ?? this.tipo,
      opcoes: opcoes ?? this.opcoes,
      ordem: ordem ?? this.ordem,
      explicacao: explicacao ?? this.explicacao,
      pontos: pontos ?? this.pontos,
    );
  }

  // === Getters úteis ===

  bool get isVerdadeiroFalso => tipo == TipoPergunta.verdadeiroFalso;
  bool get isMultiplaEscolha => tipo == TipoPergunta.multiplaEscolha;
  bool get isMultiplasRespostas => tipo == TipoPergunta.multiplasRespostas;

  /// Retorna a opção correta (para múltipla escolha ou V/F)
  QuizOpcaoModel? get opcaoCorreta {
    try {
      return opcoes.firstWhere((o) => o.isCorreta);
    } catch (_) {
      return null;
    }
  }

  /// Retorna todas as opções corretas (para múltiplas respostas)
  List<QuizOpcaoModel> get opcoesCorretas {
    return opcoes.where((o) => o.isCorreta).toList();
  }

  /// Retorna o índice da opção correta
  int get indiceCorreto {
    return opcoes.indexWhere((o) => o.isCorreta);
  }

  /// Verifica se uma opção está correta
  bool isOpcaoCorreta(String opcaoId) {
    return opcoes.any((o) => o.id == opcaoId && o.isCorreta);
  }

  /// Verifica se um conjunto de opções está correto (all-or-nothing para múltiplas respostas)
  bool isRespostaCorreta(Set<String> opcaoIds) {
    if (isMultiplasRespostas) {
      // Múltiplas respostas: deve marcar TODAS as corretas E nenhuma incorreta
      final opcoesCorretasIds = opcoesCorretas.map((o) => o.id).toSet();
      return opcaoIds.length == opcoesCorretasIds.length &&
          opcaoIds.every((id) => opcoesCorretasIds.contains(id));
    } else {
      // Múltipla escolha ou V/F: deve marcar a única correta
      if (opcaoIds.length != 1) return false;
      return isOpcaoCorreta(opcaoIds.first);
    }
  }

  /// Número de opções
  int get totalOpcoes => opcoes.length;

  /// Verifica se tem explicação
  bool get hasExplicacao => explicacao?.isNotEmpty ?? false;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuizQuestionModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'QuizQuestionModel(id: $id, pergunta: $pergunta)';
}

/// Model para resultado do quiz do aluno
class QuizResultadoModel {
  final String topicoId;
  final int totalPerguntas;
  final int acertos;
  final double nota; // 0 a 100
  final DateTime dataRealizacao;
  final Map<String, String> respostas; // perguntaId -> opcaoId escolhida

  const QuizResultadoModel({
    required this.topicoId,
    required this.totalPerguntas,
    required this.acertos,
    required this.nota,
    required this.dataRealizacao,
    this.respostas = const {},
  });

  factory QuizResultadoModel.fromMap(Map<String, dynamic> map) {
    return QuizResultadoModel(
      topicoId: map['topicoId'] as String? ?? '',
      totalPerguntas: map['totalPerguntas'] as int? ?? 0,
      acertos: map['acertos'] as int? ?? 0,
      nota: (map['nota'] as num?)?.toDouble() ?? 0,
      dataRealizacao: _parseTimestamp(map['dataRealizacao']) ?? DateTime.now(),
      respostas: Map<String, String>.from(map['respostas'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'topicoId': topicoId,
      'totalPerguntas': totalPerguntas,
      'acertos': acertos,
      'nota': nota,
      'dataRealizacao': dataRealizacao,
      'respostas': respostas,
    };
  }

  // === Getters úteis ===

  /// Percentual de acertos
  double get percentualAcertos {
    if (totalPerguntas == 0) return 0;
    return (acertos / totalPerguntas) * 100;
  }

  /// Nota formatada
  String get notaFormatada => nota.toStringAsFixed(1);

  /// Verifica se passou (nota >= 70)
  bool get aprovado => nota >= 70;

  /// Número de erros
  int get erros => totalPerguntas - acertos;

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  @override
  String toString() => 'QuizResultadoModel(nota: $nota, acertos: $acertos/$totalPerguntas)';
}
