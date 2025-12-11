import 'package:flutter/material.dart';

import 'package:medita_bk/domain/models/ead/notificacao_ead_model.dart';
import 'package:medita_bk/data/models/firebase/notification_model.dart';

/// Modelo unificado que representa notificações de ambas as collections
/// Funciona como um adapter para NotificacaoEadModel e NotificationModel
class UnifiedNotification {
  final String id;
  final String titulo;
  final String conteudo;
  final DateTime dataCriacao;
  final bool lido;
  final String tipo;
  final NotificationSource source;
  
  // Dados originais para navegação
  final dynamic originalData;

  const UnifiedNotification({
    required this.id,
    required this.titulo,
    required this.conteudo,
    required this.dataCriacao,
    required this.lido,
    required this.tipo,
    required this.source,
    this.originalData,
  });

  /// Cria a partir de NotificacaoEadModel (collection: notificacoes_ead)
  factory UnifiedNotification.fromEad(NotificacaoEadModel notificacao) {
    return UnifiedNotification(
      id: notificacao.id,
      titulo: notificacao.titulo,
      conteudo: notificacao.conteudo,
      dataCriacao: notificacao.dataCriacao,
      lido: notificacao.lido,
      tipo: notificacao.tipo.label,
      source: NotificationSource.ead,
      originalData: notificacao,
    );
  }

  /// Cria a partir de NotificationModel (collection: notifications)
  factory UnifiedNotification.fromLegacy(
    NotificationModel notificacao, {
    bool lido = false,
  }) {
    return UnifiedNotification(
      id: notificacao.id,
      titulo: notificacao.title,
      conteudo: notificacao.content,
      dataCriacao: notificacao.sendDate ?? DateTime.now(),
      lido: lido, // Agora aceita estado de leitura via user_states
      tipo: notificacao.type,
      source: NotificationSource.legacy,
      originalData: notificacao,
    );
  }

  /// Retorna o ícone apropriado baseado no tipo e origem
  IconData get icon {
    // Se for EAD, usa o ícone específico do tipo
    if (source == NotificationSource.ead && originalData is NotificacaoEadModel) {
      return (originalData as NotificacaoEadModel).tipo.icon;
    }
    
    // Para notificações legadas, usa ícones genéricos
    switch (tipo.toLowerCase()) {
      case 'enviada':
      case 'agendada':
        return Icons.notifications_active;
      default:
        return Icons.notifications;
    }
  }

  /// Retorna a cor apropriada baseada no tipo e origem
  Color get color {
    // Se for EAD, usa a cor específica do tipo
    if (source == NotificationSource.ead && originalData is NotificacaoEadModel) {
      return (originalData as NotificacaoEadModel).tipo.color;
    }
    
    // Para notificações legadas, usa cor padrão
    return Colors.blue;
  }

  /// Retorna tempo desde criação formatado
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

  /// Badge/tag mostrando a origem (útil para debug)
  String get sourceLabel {
    switch (source) {
      case NotificationSource.ead:
        return 'EAD';
      case NotificationSource.legacy:
        return 'Meditações';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UnifiedNotification && 
           other.id == id && 
           other.source == source;
  }

  @override
  int get hashCode => id.hashCode ^ source.hashCode;
}

/// Origem da notificação
enum NotificationSource {
  ead,      // Collection: notificacoes_ead (Cursos EAD)
  legacy,   // Collection: notifications (Meditações/Geral)
}

