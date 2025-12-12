/// Modelo de Notificação do módulo EAD
/// Para notificações de tickets, discussões e comunicação
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Tipos de notificação do EAD
enum TipoNotificacaoEad {
  // Tickets
  ticketCriado('ticket_criado', 'Nova Solicitação'),
  ticketRespondido('ticket_respondido', 'Resposta na Solicitação'),
  ticketResolvido('ticket_resolvido', 'Solicitação Resolvida'),
  ticketFechado('ticket_fechado', 'Solicitação Fechada'),

  // Discussões
  discussaoCriada('discussao_criada', 'Nova Pergunta'),
  discussaoRespondida('discussao_respondida', 'Resposta na sua Pergunta'),
  discussaoResolvida('discussao_resolvida', 'Pergunta Resolvida'),
  respostaCurtida('resposta_curtida', 'Sua Resposta foi Curtida'),
  respostaMarcadaSolucao('resposta_marcada_solucao', 'Resposta Marcada como Solução'),

  // Cursos EAD (ead_push_notifications)
  cursoGeral('curso_geral', 'Notificação de Curso'),
  cursoNovo('curso_novo', 'Novo Curso Disponível'),
  moduloLancado('modulo_lancado', 'Novo Módulo'),
  certificadoDisponivel('certificado_disponivel', 'Certificado Disponível'),
  prazoProximo('prazo_proximo', 'Prazo se Aproximando');

  final String value;
  final String label;
  const TipoNotificacaoEad(this.value, this.label);

  static TipoNotificacaoEad fromString(String? value) {
    return TipoNotificacaoEad.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TipoNotificacaoEad.cursoGeral, // Padrão para notificações de curso
    );
  }

  IconData get icon {
    switch (this) {
      case TipoNotificacaoEad.ticketCriado:
        return Icons.confirmation_number_outlined;
      case TipoNotificacaoEad.ticketRespondido:
        return Icons.reply;
      case TipoNotificacaoEad.ticketResolvido:
        return Icons.check_circle_outline;
      case TipoNotificacaoEad.ticketFechado:
        return Icons.lock_outline;
      case TipoNotificacaoEad.discussaoCriada:
        return Icons.forum_outlined;
      case TipoNotificacaoEad.discussaoRespondida:
        return Icons.chat_bubble_outline;
      case TipoNotificacaoEad.discussaoResolvida:
        return Icons.verified_outlined;
      case TipoNotificacaoEad.respostaCurtida:
        return Icons.thumb_up_outlined;
      case TipoNotificacaoEad.respostaMarcadaSolucao:
        return Icons.star_outline;
      // Cursos EAD
      case TipoNotificacaoEad.cursoGeral:
      case TipoNotificacaoEad.cursoNovo:
      case TipoNotificacaoEad.moduloLancado:
      case TipoNotificacaoEad.certificadoDisponivel:
      case TipoNotificacaoEad.prazoProximo:
        return Icons.school_outlined;
    }
  }

  Color get color {
    switch (this) {
      case TipoNotificacaoEad.ticketCriado:
        return Colors.blue;
      case TipoNotificacaoEad.ticketRespondido:
        return Colors.orange;
      case TipoNotificacaoEad.ticketResolvido:
        return Colors.green;
      case TipoNotificacaoEad.ticketFechado:
        return Colors.grey;
      case TipoNotificacaoEad.discussaoCriada:
        return Colors.purple;
      case TipoNotificacaoEad.discussaoRespondida:
        return Colors.teal;
      case TipoNotificacaoEad.discussaoResolvida:
        return Colors.green;
      case TipoNotificacaoEad.respostaCurtida:
        return Colors.pink;
      case TipoNotificacaoEad.respostaMarcadaSolucao:
        return Colors.amber;
      // Cursos EAD
      case TipoNotificacaoEad.cursoGeral:
      case TipoNotificacaoEad.cursoNovo:
      case TipoNotificacaoEad.moduloLancado:
      case TipoNotificacaoEad.certificadoDisponivel:
      case TipoNotificacaoEad.prazoProximo:
        return Colors.deepPurple;
    }
  }

  /// Se é relacionado a ticket
  bool get isTicket => value.startsWith('ticket_');

  /// Se é relacionado a discussão
  bool get isDiscussao => value.startsWith('discussao_') || value.startsWith('resposta_');

  /// Se é relacionado a curso EAD
  bool get isCurso => value.startsWith('curso_') ||
                       value.startsWith('modulo_') ||
                       value.startsWith('certificado_') ||
                       value.startsWith('prazo_') ||
                       value == 'push' ||  // Web admin salva como "push"
                       value == 'email' ||  // Compatibilidade com web admin
                       value == 'whatsapp';  // Compatibilidade com web admin
}

/// Modelo de Notificação EAD
class NotificacaoEadModel {
  final String id;
  final String titulo;
  final String conteudo;
  final TipoNotificacaoEad tipo;
  final String? relatedType; // 'ticket', 'discussao', 'resposta'
  final String? relatedId;
  final String destinatarioId;
  final String? remetenteId;
  final String? remetenteNome;
  final DateTime dataCriacao;
  final bool lido;
  final Map<String, dynamic>? dados; // Dados adicionais para navegação

  const NotificacaoEadModel({
    required this.id,
    required this.titulo,
    required this.conteudo,
    required this.tipo,
    this.relatedType,
    this.relatedId,
    required this.destinatarioId,
    this.remetenteId,
    this.remetenteNome,
    required this.dataCriacao,
    this.lido = false,
    this.dados,
  });

  factory NotificacaoEadModel.fromMap(Map<String, dynamic> map, String docId) {
    DateTime parseDate(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      return DateTime.now();
    }

    return NotificacaoEadModel(
      id: docId,
      titulo: map['titulo'] as String? ?? '',
      conteudo: map['conteudo'] as String? ?? '',
      tipo: TipoNotificacaoEad.fromString(map['tipo'] as String?),
      relatedType: map['relatedType'] as String?,
      relatedId: map['relatedId'] as String?,
      destinatarioId: map['destinatarioId'] as String? ?? '',
      remetenteId: map['remetenteId'] as String?,
      remetenteNome: map['remetenteNome'] as String?,
      dataCriacao: parseDate(map['dataCriacao']),
      lido: map['lido'] as bool? ?? false,
      dados: map['dados'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'conteudo': conteudo,
      'tipo': tipo.value,
      'relatedType': relatedType,
      'relatedId': relatedId,
      'destinatarioId': destinatarioId,
      'remetenteId': remetenteId,
      'remetenteNome': remetenteNome,
      'dataCriacao': Timestamp.fromDate(dataCriacao),
      'lido': lido,
      if (dados != null) 'dados': dados,
    };
  }

  NotificacaoEadModel copyWith({
    String? id,
    String? titulo,
    String? conteudo,
    TipoNotificacaoEad? tipo,
    String? relatedType,
    String? relatedId,
    String? destinatarioId,
    String? remetenteId,
    String? remetenteNome,
    DateTime? dataCriacao,
    bool? lido,
    Map<String, dynamic>? dados,
  }) {
    return NotificacaoEadModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      conteudo: conteudo ?? this.conteudo,
      tipo: tipo ?? this.tipo,
      relatedType: relatedType ?? this.relatedType,
      relatedId: relatedId ?? this.relatedId,
      destinatarioId: destinatarioId ?? this.destinatarioId,
      remetenteId: remetenteId ?? this.remetenteId,
      remetenteNome: remetenteNome ?? this.remetenteNome,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      lido: lido ?? this.lido,
      dados: dados ?? this.dados,
    );
  }

  /// Retorna tempo desde a criação formatado
  String get tempoDesde {
    final agora = DateTime.now();
    final diferenca = agora.difference(dataCriacao);

    if (diferenca.inMinutes < 1) {
      return 'Agora';
    } else if (diferenca.inMinutes < 60) {
      return '${diferenca.inMinutes}min';
    } else if (diferenca.inHours < 24) {
      return '${diferenca.inHours}h';
    } else if (diferenca.inDays < 7) {
      return '${diferenca.inDays}d';
    } else {
      final semanas = (diferenca.inDays / 7).floor();
      return '${semanas}sem';
    }
  }

  @override
  String toString() =>
      'NotificacaoEadModel(id: $id, tipo: ${tipo.label}, lido: $lido)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificacaoEadModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Modelo de contadores de notificações
class ContadorNotificacoesEad {
  final int ticketsNaoLidos;
  final int discussoesNaoLidas;
  final int totalNaoLidas;
  final DateTime? ultimaAtualizacao;

  const ContadorNotificacoesEad({
    this.ticketsNaoLidos = 0,
    this.discussoesNaoLidas = 0,
    this.totalNaoLidas = 0,
    this.ultimaAtualizacao,
  });

  factory ContadorNotificacoesEad.fromMap(Map<String, dynamic> map) {
    return ContadorNotificacoesEad(
      ticketsNaoLidos: map['ticketsNaoLidos'] as int? ?? 0,
      discussoesNaoLidas: map['discussoesNaoLidas'] as int? ?? 0,
      totalNaoLidas: map['totalNaoLidas'] as int? ?? 0,
      ultimaAtualizacao: map['ultimaAtualizacao'] != null
          ? (map['ultimaAtualizacao'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ticketsNaoLidos': ticketsNaoLidos,
      'discussoesNaoLidas': discussoesNaoLidas,
      'totalNaoLidas': totalNaoLidas,
      'ultimaAtualizacao': ultimaAtualizacao != null
          ? Timestamp.fromDate(ultimaAtualizacao!)
          : FieldValue.serverTimestamp(),
    };
  }

  bool get temNotificacoes => totalNaoLidas > 0;
}
