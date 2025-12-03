import 'package:cloud_firestore/cloud_firestore.dart';
import 'comunicacao_enums.dart';

/// Modelo de Anexo de Mensagem
class AnexoModel {
  final String url;
  final String nome;
  final String tipo; // 'imagem', 'documento', etc
  final int? tamanho;

  const AnexoModel({
    required this.url,
    required this.nome,
    required this.tipo,
    this.tamanho,
  });

  factory AnexoModel.fromMap(Map<String, dynamic> map) {
    return AnexoModel(
      url: map['url'] as String? ?? '',
      nome: map['nome'] as String? ?? '',
      tipo: map['tipo'] as String? ?? 'imagem',
      tamanho: map['tamanho'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'nome': nome,
      'tipo': tipo,
      if (tamanho != null) 'tamanho': tamanho,
    };
  }
}

/// Modelo de Mensagem do Ticket
class TicketMensagemModel {
  final String id;
  final String ticketId;
  final String conteudo;
  final String autorId;
  final String autorNome;
  final TipoAutor autorTipo;
  final DateTime dataCriacao;
  final List<AnexoModel> anexos;

  const TicketMensagemModel({
    required this.id,
    required this.ticketId,
    required this.conteudo,
    required this.autorId,
    required this.autorNome,
    required this.autorTipo,
    required this.dataCriacao,
    this.anexos = const [],
  });

  factory TicketMensagemModel.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>? ?? {};
    return TicketMensagemModel.fromMap(map, doc.id);
  }

  factory TicketMensagemModel.fromMap(Map<String, dynamic> map, String id) {
    return TicketMensagemModel(
      id: id,
      ticketId: map['ticketId'] as String? ?? '',
      conteudo: map['conteudo'] as String? ?? '',
      autorId: map['autorId'] as String? ?? '',
      autorNome: map['autorNome'] as String? ?? '',
      autorTipo: TipoAutor.fromString(map['autorTipo'] as String?),
      dataCriacao: _parseTimestamp(map['dataCriacao']),
      anexos: _parseAnexos(map['anexos']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ticketId': ticketId,
      'conteudo': conteudo,
      'autorId': autorId,
      'autorNome': autorNome,
      'autorTipo': autorTipo.name,
      'dataCriacao': Timestamp.fromDate(dataCriacao),
      'anexos': anexos.map((a) => a.toMap()).toList(),
    };
  }

  /// Parse timestamp com fallback para DateTime.now()
  static DateTime _parseTimestamp(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  /// Parse lista de anexos
  static List<AnexoModel> _parseAnexos(dynamic value) {
    if (value == null) return [];
    if (value is! List) return [];
    return value
        .whereType<Map<String, dynamic>>()
        .map((map) => AnexoModel.fromMap(map))
        .toList();
  }

  /// Indica se a mensagem é do aluno (usuário logado)
  bool isFromAluno() => autorTipo == TipoAutor.aluno;

  /// Indica se a mensagem é do suporte/admin
  bool isFromSuporte() => 
      autorTipo == TipoAutor.admin || 
      autorTipo == TipoAutor.professor ||
      autorTipo == TipoAutor.sistema;

  TicketMensagemModel copyWith({
    String? id,
    String? ticketId,
    String? conteudo,
    String? autorId,
    String? autorNome,
    TipoAutor? autorTipo,
    DateTime? dataCriacao,
    List<AnexoModel>? anexos,
  }) {
    return TicketMensagemModel(
      id: id ?? this.id,
      ticketId: ticketId ?? this.ticketId,
      conteudo: conteudo ?? this.conteudo,
      autorId: autorId ?? this.autorId,
      autorNome: autorNome ?? this.autorNome,
      autorTipo: autorTipo ?? this.autorTipo,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      anexos: anexos ?? this.anexos,
    );
  }
}
