/// Enums para o módulo de Comunicação Mobile
/// Compatíveis com os enums do Web Admin
library;

import 'package:flutter/material.dart';

/// Categoria do Ticket
enum CategoriaTicket {
  acesso('Acesso e Login'),
  conteudo('Conteúdo do Curso'),
  tecnico('Problema Técnico'),
  outro('Outro');

  final String label;
  const CategoriaTicket(this.label);

  static CategoriaTicket fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'acesso':
        return CategoriaTicket.acesso;
      case 'conteudo':
      case 'conteúdo':
        return CategoriaTicket.conteudo;
      case 'tecnico':
      case 'técnico':
        return CategoriaTicket.tecnico;
      case 'outro':
      default:
        return CategoriaTicket.outro;
    }
  }

  IconData get icon {
    switch (this) {
      case CategoriaTicket.acesso:
        return Icons.lock_outline;
      case CategoriaTicket.conteudo:
        return Icons.school_outlined;
      case CategoriaTicket.tecnico:
        return Icons.build_outlined;
      case CategoriaTicket.outro:
        return Icons.help_outline;
    }
  }

  Color get color {
    switch (this) {
      case CategoriaTicket.acesso:
        return Colors.red;
      case CategoriaTicket.conteudo:
        return Colors.blue;
      case CategoriaTicket.tecnico:
        return Colors.orange;
      case CategoriaTicket.outro:
        return Colors.grey;
    }
  }
}

/// Prioridade do Ticket
enum PrioridadeTicket {
  baixa('Baixa'),
  media('Média'),
  alta('Alta'),
  urgente('Urgente');

  final String label;
  const PrioridadeTicket(this.label);

  static PrioridadeTicket fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'baixa':
        return PrioridadeTicket.baixa;
      case 'media':
      case 'média':
        return PrioridadeTicket.media;
      case 'alta':
        return PrioridadeTicket.alta;
      case 'urgente':
        return PrioridadeTicket.urgente;
      default:
        return PrioridadeTicket.media;
    }
  }

  Color get color {
    switch (this) {
      case PrioridadeTicket.baixa:
        return Colors.grey;
      case PrioridadeTicket.media:
        return Colors.blue;
      case PrioridadeTicket.alta:
        return Colors.orange;
      case PrioridadeTicket.urgente:
        return Colors.red;
    }
  }

  int get ordem {
    switch (this) {
      case PrioridadeTicket.urgente:
        return 4;
      case PrioridadeTicket.alta:
        return 3;
      case PrioridadeTicket.media:
        return 2;
      case PrioridadeTicket.baixa:
        return 1;
    }
  }
}

/// Status do Ticket
enum StatusTicket {
  aberto('Aberto'),
  emAndamento('Em Andamento'),
  aguardandoResposta('Aguardando Resposta'),
  resolvido('Resolvido'),
  fechado('Fechado');

  final String label;
  const StatusTicket(this.label);

  static StatusTicket fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'aberto':
        return StatusTicket.aberto;
      case 'em_andamento':
      case 'emandamento':
        return StatusTicket.emAndamento;
      case 'aguardando_resposta':
      case 'aguardandoresposta':
        return StatusTicket.aguardandoResposta;
      case 'resolvido':
        return StatusTicket.resolvido;
      case 'fechado':
        return StatusTicket.fechado;
      default:
        return StatusTicket.aberto;
    }
  }

  Color get color {
    switch (this) {
      case StatusTicket.aberto:
        return Colors.blue;
      case StatusTicket.emAndamento:
        return Colors.orange;
      case StatusTicket.aguardandoResposta:
        return Colors.purple;
      case StatusTicket.resolvido:
        return Colors.green;
      case StatusTicket.fechado:
        return Colors.grey;
    }
  }

  IconData get icon {
    switch (this) {
      case StatusTicket.aberto:
        return Icons.new_releases;
      case StatusTicket.emAndamento:
        return Icons.pending;
      case StatusTicket.aguardandoResposta:
        return Icons.question_answer;
      case StatusTicket.resolvido:
        return Icons.check_circle;
      case StatusTicket.fechado:
        return Icons.cancel;
    }
  }

  bool get isFechado => this == StatusTicket.fechado || this == StatusTicket.resolvido;
}

/// Tipo do Autor
enum TipoAutor {
  aluno('Aluno'),
  professor('Professor'),
  admin('Admin'),
  sistema('Sistema');

  final String label;
  const TipoAutor(this.label);

  static TipoAutor fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'aluno':
        return TipoAutor.aluno;
      case 'professor':
        return TipoAutor.professor;
      case 'admin':
        return TipoAutor.admin;
      case 'sistema':
        return TipoAutor.sistema;
      default:
        return TipoAutor.aluno;
    }
  }

  Color get color {
    switch (this) {
      case TipoAutor.aluno:
        return Colors.blue;
      case TipoAutor.professor:
        return Colors.green;
      case TipoAutor.admin:
        return Colors.orange;
      case TipoAutor.sistema:
        return Colors.grey;
    }
  }

  IconData get icon {
    switch (this) {
      case TipoAutor.aluno:
        return Icons.person;
      case TipoAutor.professor:
        return Icons.school;
      case TipoAutor.admin:
        return Icons.admin_panel_settings;
      case TipoAutor.sistema:
        return Icons.computer;
    }
  }
}

/// Status da Discussão
enum StatusDiscussao {
  aberta('Aberta'),
  respondida('Respondida'),
  fechada('Fechada');

  final String label;
  const StatusDiscussao(this.label);

  static StatusDiscussao fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'aberta':
        return StatusDiscussao.aberta;
      case 'respondida':
        return StatusDiscussao.respondida;
      case 'resolvida': // Compatibilidade: converte resolvida para fechada
      case 'fechada':
        return StatusDiscussao.fechada;
      default:
        return StatusDiscussao.aberta;
    }
  }

  Color get color {
    switch (this) {
      case StatusDiscussao.aberta:
        return Colors.blue;
      case StatusDiscussao.respondida:
        return Colors.orange;
      case StatusDiscussao.fechada:
        return Colors.green;
    }
  }

  IconData get icon {
    switch (this) {
      case StatusDiscussao.aberta:
        return Icons.help_outline;
      case StatusDiscussao.respondida:
        return Icons.chat_bubble_outline;
      case StatusDiscussao.fechada:
        return Icons.check_circle;
    }
  }

  bool get isFechada => this == StatusDiscussao.fechada;
}
