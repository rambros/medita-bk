/// Enum unificado de tipos de notificação
/// Usado tanto pelo mobile quanto pelo web admin
///
/// Este enum substitui os antigos:
/// - TipoNotificacaoEad (mobile e web eram diferentes)
/// - Elimina necessidade de compatibilidade entre sistemas
library;

import 'package:flutter/material.dart';

enum TipoNotificacao {
  // === TICKETS ===
  ticketCriado('ticket_criado', 'Novo Ticket', 'ticket'),
  ticketRespondido('ticket_respondido', 'Resposta no Ticket', 'ticket'),
  ticketResolvido('ticket_resolvido', 'Ticket Resolvido', 'ticket'),
  ticketFechado('ticket_fechado', 'Ticket Fechado', 'ticket'),

  // === DISCUSSÕES ===
  discussaoCriada('discussao_criada', 'Nova Discussão', 'discussao'),
  discussaoRespondida('discussao_respondida', 'Resposta na Discussão', 'discussao'),
  discussaoResolvida('discussao_resolvida', 'Discussão Resolvida', 'discussao'),
  respostaCurtida('resposta_curtida', 'Sua Resposta foi Curtida', 'discussao'),
  respostaSolucao('resposta_solucao', 'Resposta Marcada como Solução', 'discussao'),

  // === CURSOS ===
  cursoGeral('curso_geral', 'Notificação de Curso', 'curso'),
  cursoNovo('curso_novo', 'Novo Curso Disponível', 'curso'),
  moduloNovo('modulo_novo', 'Novo Módulo Disponível', 'curso'),
  certificadoDisponivel('certificado_disponivel', 'Certificado Disponível', 'curso'),
  prazoProximo('prazo_proximo', 'Prazo se Aproximando', 'curso'),
  cursoAtualizado('curso_atualizado', 'Curso Atualizado', 'curso'),

  // === SISTEMA ===
  sistemaGeral('sistema_geral', 'Notificação do Sistema', 'sistema');

  final String value;
  final String label;
  final String categoria;

  const TipoNotificacao(this.value, this.label, this.categoria);

  /// Converte string para enum
  static TipoNotificacao fromString(String? value) {
    if (value == null || value.isEmpty) {
      return TipoNotificacao.sistemaGeral;
    }

    // Compatibilidade com tipos salvos pelo web admin
    // Web admin salva notificações de cursos EAD como 'push', 'email' ou 'whatsapp'
    if (value == 'push' || value == 'email' || value == 'whatsapp') {
      return TipoNotificacao.cursoGeral;
    }

    return TipoNotificacao.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TipoNotificacao.sistemaGeral,
    );
  }

  /// Retorna o ícone apropriado para o tipo
  IconData get icon {
    switch (this) {
      // Tickets - ícone de ticket
      case TipoNotificacao.ticketCriado:
      case TipoNotificacao.ticketRespondido:
      case TipoNotificacao.ticketResolvido:
      case TipoNotificacao.ticketFechado:
        return Icons.confirmation_number_outlined;

      // Discussões - ícone de perguntas/forum
      case TipoNotificacao.discussaoCriada:
      case TipoNotificacao.discussaoRespondida:
      case TipoNotificacao.discussaoResolvida:
      case TipoNotificacao.respostaCurtida:
      case TipoNotificacao.respostaSolucao:
        return Icons.question_answer_outlined;

      // Cursos (EAD) - ícone de escola
      case TipoNotificacao.cursoGeral:
      case TipoNotificacao.cursoNovo:
      case TipoNotificacao.moduloNovo:
      case TipoNotificacao.certificadoDisponivel:
      case TipoNotificacao.prazoProximo:
      case TipoNotificacao.cursoAtualizado:
        return Icons.school_outlined;

      // Sistema - ícone de sino/notificação
      case TipoNotificacao.sistemaGeral:
        return Icons.notifications_outlined;
    }
  }

  /// Retorna a cor específica do tipo
  Color get color {
    switch (this) {
      // Tickets
      case TipoNotificacao.ticketCriado:
        return Colors.blue;
      case TipoNotificacao.ticketRespondido:
        return Colors.orange;
      case TipoNotificacao.ticketResolvido:
        return Colors.green;
      case TipoNotificacao.ticketFechado:
        return Colors.grey;

      // Discussões
      case TipoNotificacao.discussaoCriada:
        return Colors.purple;
      case TipoNotificacao.discussaoRespondida:
        return Colors.teal;
      case TipoNotificacao.discussaoResolvida:
        return Colors.green;
      case TipoNotificacao.respostaCurtida:
        return Colors.pink;
      case TipoNotificacao.respostaSolucao:
        return Colors.amber;

      // Cursos - todos roxo escuro
      case TipoNotificacao.cursoGeral:
      case TipoNotificacao.cursoNovo:
      case TipoNotificacao.moduloNovo:
      case TipoNotificacao.certificadoDisponivel:
      case TipoNotificacao.prazoProximo:
      case TipoNotificacao.cursoAtualizado:
        return Colors.deepPurple;

      // Sistema
      case TipoNotificacao.sistemaGeral:
        return Colors.blue;
    }
  }

  /// Retorna a cor do badge baseada na categoria
  Color get badgeColor {
    switch (categoria) {
      case 'ticket':
        return Colors.orange;
      case 'discussao':
        return Colors.purple;
      case 'curso':
        return Colors.deepPurple;
      case 'sistema':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  /// Label do badge (categoria formatada)
  String get badgeLabel {
    switch (categoria) {
      case 'ticket':
        return 'Suporte';
      case 'discussao':
        return 'Perguntas';
      case 'curso':
        return 'Cursos';
      case 'sistema':
        return 'Geral';
      default:
        return 'Geral';
    }
  }

  /// Se é um tipo de ticket
  bool get isTicket => categoria == 'ticket';

  /// Se é um tipo de discussão
  bool get isDiscussao => categoria == 'discussao';

  /// Se é um tipo de curso
  bool get isCurso => categoria == 'curso';

  /// Se é um tipo de sistema
  bool get isSistema => categoria == 'sistema';
}
