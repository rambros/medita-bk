/// Enums para o módulo EAD Mobile
/// Compatíveis com os enums do Web Admin
library;

import 'package:flutter/material.dart';

/// Enum para tipos de conteúdo de tópico
enum TipoConteudoTopico {
  video,
  audio,
  texto,
  quiz;

  static TipoConteudoTopico fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'video':
        return TipoConteudoTopico.video;
      case 'audio':
        return TipoConteudoTopico.audio;
      case 'texto':
        return TipoConteudoTopico.texto;
      case 'quiz':
        return TipoConteudoTopico.quiz;
      default:
        return TipoConteudoTopico.texto;
    }
  }

  String get label {
    switch (this) {
      case TipoConteudoTopico.video:
        return 'Vídeo';
      case TipoConteudoTopico.audio:
        return 'Áudio';
      case TipoConteudoTopico.texto:
        return 'Texto';
      case TipoConteudoTopico.quiz:
        return 'Quiz';
    }
  }

  IconData get icon {
    switch (this) {
      case TipoConteudoTopico.video:
        return Icons.play_circle_outline;
      case TipoConteudoTopico.audio:
        return Icons.audiotrack;
      case TipoConteudoTopico.texto:
        return Icons.article_outlined;
      case TipoConteudoTopico.quiz:
        return Icons.quiz_outlined;
    }
  }
}

/// Enum para status do curso
enum StatusCurso {
  rascunho,
  publicado,
  arquivado;

  static StatusCurso fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'publicado':
        return StatusCurso.publicado;
      case 'arquivado':
        return StatusCurso.arquivado;
      case 'rascunho':
      default:
        return StatusCurso.rascunho;
    }
  }

  String get label {
    switch (this) {
      case StatusCurso.rascunho:
        return 'Rascunho';
      case StatusCurso.publicado:
        return 'Publicado';
      case StatusCurso.arquivado:
        return 'Arquivado';
    }
  }

  Color get color {
    switch (this) {
      case StatusCurso.rascunho:
        return Colors.orange;
      case StatusCurso.publicado:
        return Colors.green;
      case StatusCurso.arquivado:
        return Colors.grey;
    }
  }
}

/// Enum para status de inscrição
enum StatusInscricao {
  ativo,
  pausado,
  concluido,
  cancelado;

  static StatusInscricao fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'pausado':
        return StatusInscricao.pausado;
      case 'concluido':
        return StatusInscricao.concluido;
      case 'cancelado':
        return StatusInscricao.cancelado;
      case 'ativo':
      default:
        return StatusInscricao.ativo;
    }
  }

  String get label {
    switch (this) {
      case StatusInscricao.ativo:
        return 'Em andamento';
      case StatusInscricao.pausado:
        return 'Pausado';
      case StatusInscricao.concluido:
        return 'Concluído';
      case StatusInscricao.cancelado:
        return 'Cancelado';
    }
  }

  Color get color {
    switch (this) {
      case StatusInscricao.ativo:
        return Colors.blue;
      case StatusInscricao.pausado:
        return Colors.orange;
      case StatusInscricao.concluido:
        return Colors.green;
      case StatusInscricao.cancelado:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case StatusInscricao.ativo:
        return Icons.play_circle;
      case StatusInscricao.pausado:
        return Icons.pause_circle;
      case StatusInscricao.concluido:
        return Icons.check_circle;
      case StatusInscricao.cancelado:
        return Icons.cancel;
    }
  }
}
