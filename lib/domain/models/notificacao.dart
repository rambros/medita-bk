/// Modelo simplificado de Notificação
/// Substitui UnifiedNotification e elimina complexidade de 3 collections
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medita_bk/domain/models/tipo_notificacao.dart';
import 'package:medita_bk/domain/models/user_notification_state.dart';

/// Dados de navegação da notificação
class NavegacaoNotificacao {
  final String tipo; // 'ticket', 'discussao', 'curso'
  final String id;
  final Map<String, dynamic>? dados;

  const NavegacaoNotificacao({
    required this.tipo,
    required this.id,
    this.dados,
  });

  factory NavegacaoNotificacao.fromMap(Map<String, dynamic> map) {
    return NavegacaoNotificacao(
      tipo: map['tipo'] as String? ?? '',
      id: map['id'] as String? ?? '',
      dados: map['dados'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tipo': tipo,
      'id': id,
      if (dados != null) 'dados': dados,
    };
  }

  @override
  String toString() => 'NavegacaoNotificacao(tipo: $tipo, id: $id)';
}

/// Modelo de Notificação (única collection: notifications)
class Notificacao {
  final String id;
  final String titulo;
  final String conteudo;
  final String? imagemUrl;
  final TipoNotificacao tipo;
  final List<String> destinatarios;
  final NavegacaoNotificacao? navegacao;
  final DateTime dataCriacao;
  final DateTime? dataEnvio;
  final String status;

  // Estado do usuário (vem de subcollection user_states)
  final bool lido;
  final bool ocultado;
  final DateTime? dataLeitura;

  const Notificacao({
    required this.id,
    required this.titulo,
    required this.conteudo,
    this.imagemUrl,
    required this.tipo,
    required this.destinatarios,
    this.navegacao,
    required this.dataCriacao,
    this.dataEnvio,
    required this.status,
    this.lido = false,
    this.ocultado = false,
    this.dataLeitura,
  });

  /// Cria notificação a partir de documento do Firestore
  factory Notificacao.fromFirestore(
    DocumentSnapshot doc,
    UserNotificationState? userState,
  ) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return Notificacao(
      id: doc.id,
      titulo: data['titulo'] as String? ?? '',
      conteudo: data['conteudo'] as String? ?? '',
      imagemUrl: data['imagemUrl'] as String?,
      tipo: TipoNotificacao.fromString(data['tipo'] as String?),
      destinatarios: _parseDestinatarios(data['destinatarios']),
      navegacao: data['navegacao'] != null
          ? NavegacaoNotificacao.fromMap(
              data['navegacao'] as Map<String, dynamic>,
            )
          : null,
      dataCriacao: _parseTimestamp(data['dataCriacao']) ?? DateTime.now(),
      dataEnvio: _parseTimestamp(data['dataEnvio']),
      status: data['status'] as String? ?? 'enviada',
      lido: userState?.lido ?? false,
      ocultado: userState?.ocultado ?? false,
      dataLeitura: userState?.dataLeitura,
    );
  }

  /// Converte para Map (para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'conteudo': conteudo,
      if (imagemUrl != null) 'imagemUrl': imagemUrl,
      'tipo': tipo.value,
      'destinatarios': destinatarios,
      if (navegacao != null) 'navegacao': navegacao!.toMap(),
      'dataCriacao': Timestamp.fromDate(dataCriacao),
      if (dataEnvio != null) 'dataEnvio': Timestamp.fromDate(dataEnvio!),
      'status': status,
    };
  }

  /// Copia com alterações
  Notificacao copyWith({
    String? id,
    String? titulo,
    String? conteudo,
    String? imagemUrl,
    TipoNotificacao? tipo,
    List<String>? destinatarios,
    NavegacaoNotificacao? navegacao,
    DateTime? dataCriacao,
    DateTime? dataEnvio,
    String? status,
    bool? lido,
    bool? ocultado,
    DateTime? dataLeitura,
  }) {
    return Notificacao(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      conteudo: conteudo ?? this.conteudo,
      imagemUrl: imagemUrl ?? this.imagemUrl,
      tipo: tipo ?? this.tipo,
      destinatarios: destinatarios ?? this.destinatarios,
      navegacao: navegacao ?? this.navegacao,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataEnvio: dataEnvio ?? this.dataEnvio,
      status: status ?? this.status,
      lido: lido ?? this.lido,
      ocultado: ocultado ?? this.ocultado,
      dataLeitura: dataLeitura ?? this.dataLeitura,
    );
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Notificacao && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Notificacao(id: $id, tipo: ${tipo.label}, lido: $lido)';

  // === Helpers privados ===

  static List<String> _parseDestinatarios(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
