import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'comunicacao_enums.dart';

/// Modelo de Ticket para Mobile
/// Versão simplificada do TicketModel do Web Admin
class TicketModel {
  final String id;
  final int numero;
  final String titulo;
  final String descricao;
  final CategoriaTicket categoria;
  final PrioridadeTicket prioridade;
  final StatusTicket status;
  
  // Informações do usuário (aluno)
  final String usuarioId;
  final String usuarioNome;
  final String? usuarioEmail;
  
  // Informações do curso (opcional)
  final String? cursoId;
  final String? cursoTitulo;
  
  // Atribuição (quem está resolvendo)
  final String? atribuidoPara;
  final String? atribuidoNome;
  
  // Datas
  final DateTime dataCriacao;
  final DateTime dataAtualizacao;
  final DateTime? dataFechamento;
  
  // Contadores
  final int totalMensagens;

  // Privacidade
  final bool isPrivada;

  const TicketModel({
    required this.id,
    required this.numero,
    required this.titulo,
    required this.descricao,
    required this.categoria,
    required this.prioridade,
    required this.status,
    required this.usuarioId,
    required this.usuarioNome,
    this.usuarioEmail,
    this.cursoId,
    this.cursoTitulo,
    this.atribuidoPara,
    this.atribuidoNome,
    required this.dataCriacao,
    required this.dataAtualizacao,
    this.dataFechamento,
    this.totalMensagens = 0,
    this.isPrivada = true, // Default: privado
  });

  factory TicketModel.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>? ?? {};
    return TicketModel.fromMap(map, doc.id);
  }

  factory TicketModel.fromMap(Map<String, dynamic> map, String id) {
    return TicketModel(
      id: id,
      numero: _parseInt(map['numero']),
      titulo: map['titulo'] as String? ?? '',
      descricao: map['descricao'] as String? ?? '',
      categoria: CategoriaTicket.fromString(map['categoria'] as String?),
      prioridade: PrioridadeTicket.fromString(map['prioridade'] as String?),
      status: StatusTicket.fromString(map['status'] as String?),
      usuarioId: map['usuarioId'] as String? ?? '',
      usuarioNome: map['usuarioNome'] as String? ?? '',
      usuarioEmail: map['usuarioEmail'] as String?,
      cursoId: map['cursoId'] as String?,
      cursoTitulo: map['cursoTitulo'] as String?,
      atribuidoPara: map['atribuidoPara'] as String?,
      atribuidoNome: map['atribuidoNome'] as String?,
      dataCriacao: _parseTimestamp(map['dataCriacao']),
      dataAtualizacao: _parseTimestamp(map['dataAtualizacao']),
      dataFechamento: _parseTimestamp(map['dataFechamento'], allowNull: true),
      totalMensagens: _parseInt(map['totalMensagens']),
      isPrivada: map['isPrivada'] as bool? ?? true, // Default: privado
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'numero': numero,
      'titulo': titulo,
      'descricao': descricao,
      'categoria': categoria.name,
      'prioridade': prioridade.name,
      'status': status.name,
      'usuarioId': usuarioId,
      'usuarioNome': usuarioNome,
      if (usuarioEmail != null) 'usuarioEmail': usuarioEmail,
      if (cursoId != null) 'cursoId': cursoId,
      if (cursoTitulo != null) 'cursoTitulo': cursoTitulo,
      if (atribuidoPara != null) 'atribuidoPara': atribuidoPara,
      if (atribuidoNome != null) 'atribuidoNome': atribuidoNome,
      'dataCriacao': Timestamp.fromDate(dataCriacao),
      'dataAtualizacao': Timestamp.fromDate(dataAtualizacao),
      if (dataFechamento != null) 'dataFechamento': Timestamp.fromDate(dataFechamento!),
      'totalMensagens': totalMensagens,
      'isPrivada': isPrivada,
    };
  }

  /// Parse int com fallback para 0
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  /// Parse timestamp com fallback
  static DateTime _parseTimestamp(dynamic value, {bool allowNull = false}) {
    if (value == null) {
      return allowNull ? DateTime.now() : DateTime.now();
    }
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

  /// Verifica se o ticket está aberto
  bool get isAberto => !status.isFechado;

  /// Verifica se o ticket está atribuído
  bool get isAtribuido => atribuidoPara != null && atribuidoPara!.isNotEmpty;

  /// Verifica se o ticket tem mensagens não lidas
  bool get temMensagensNovas => totalMensagens > 1;

  /// Texto do status para exibição
  String get statusTexto => status.label;

  /// Cor do status
  Color get statusColor => status.color;

  /// Ícone do status
  IconData get statusIcon => status.icon;

  /// Tempo desde criação (formatado)
  String get tempoDesde {
    final diferenca = DateTime.now().difference(dataCriacao);
    if (diferenca.inDays > 0) {
      return '${diferenca.inDays} dia${diferenca.inDays > 1 ? 's' : ''} atrás';
    } else if (diferenca.inHours > 0) {
      return '${diferenca.inHours} hora${diferenca.inHours > 1 ? 's' : ''} atrás';
    } else if (diferenca.inMinutes > 0) {
      return '${diferenca.inMinutes} minuto${diferenca.inMinutes > 1 ? 's' : ''} atrás';
    } else {
      return 'Agora';
    }
  }

  TicketModel copyWith({
    String? id,
    int? numero,
    String? titulo,
    String? descricao,
    CategoriaTicket? categoria,
    PrioridadeTicket? prioridade,
    StatusTicket? status,
    String? usuarioId,
    String? usuarioNome,
    String? usuarioEmail,
    String? cursoId,
    String? cursoTitulo,
    String? atribuidoPara,
    String? atribuidoNome,
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
    DateTime? dataFechamento,
    int? totalMensagens,
    bool? isPrivada,
  }) {
    return TicketModel(
      id: id ?? this.id,
      numero: numero ?? this.numero,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      categoria: categoria ?? this.categoria,
      prioridade: prioridade ?? this.prioridade,
      status: status ?? this.status,
      usuarioId: usuarioId ?? this.usuarioId,
      usuarioNome: usuarioNome ?? this.usuarioNome,
      usuarioEmail: usuarioEmail ?? this.usuarioEmail,
      cursoId: cursoId ?? this.cursoId,
      cursoTitulo: cursoTitulo ?? this.cursoTitulo,
      atribuidoPara: atribuidoPara ?? this.atribuidoPara,
      atribuidoNome: atribuidoNome ?? this.atribuidoNome,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
      dataFechamento: dataFechamento ?? this.dataFechamento,
      totalMensagens: totalMensagens ?? this.totalMensagens,
      isPrivada: isPrivada ?? this.isPrivada,
    );
  }
}
