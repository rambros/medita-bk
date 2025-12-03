/// Modelo de Resposta de Discussão (Q&A) do módulo EAD
/// Compatível com a estrutura do Web Admin
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'comunicacao_enums.dart';

class RespostaDiscussaoModel {
  final String id;
  final String discussaoId;
  final String conteudo;
  final String autorId;
  final String autorNome;
  final String? autorFoto;
  final TipoAutor autorTipo;
  final bool isSolucao;
  final int likes;
  final List<String> likedBy;
  final DateTime dataCriacao;
  final DateTime? dataAtualizacao;

  const RespostaDiscussaoModel({
    required this.id,
    required this.discussaoId,
    required this.conteudo,
    required this.autorId,
    required this.autorNome,
    this.autorFoto,
    required this.autorTipo,
    this.isSolucao = false,
    this.likes = 0,
    this.likedBy = const [],
    required this.dataCriacao,
    this.dataAtualizacao,
  });

  factory RespostaDiscussaoModel.fromMap(Map<String, dynamic> map, String docId) {
    DateTime parseDate(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      return DateTime.now();
    }

    DateTime? parseDateNullable(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      return null;
    }

    return RespostaDiscussaoModel(
      id: docId,
      discussaoId: map['discussaoId'] as String? ?? '',
      conteudo: map['conteudo'] as String? ?? '',
      autorId: map['autorId'] as String? ?? '',
      autorNome: map['autorNome'] as String? ?? 'Usuário',
      autorFoto: map['autorFoto'] as String?,
      autorTipo: TipoAutor.fromString(map['autorTipo'] as String?),
      isSolucao: map['isSolucao'] as bool? ?? map['isResposta'] as bool? ?? false,
      likes: map['likes'] as int? ?? 0,
      likedBy: (map['likedBy'] as List<dynamic>?)?.cast<String>() ?? [],
      dataCriacao: parseDate(map['dataCriacao']),
      dataAtualizacao: parseDateNullable(map['dataAtualizacao']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'discussaoId': discussaoId,
      'conteudo': conteudo,
      'autorId': autorId,
      'autorNome': autorNome,
      'autorFoto': autorFoto,
      'autorTipo': autorTipo.name,
      'isSolucao': isSolucao,
      'isResposta': isSolucao, // Compatibilidade com Web Admin
      'likes': likes,
      'likedBy': likedBy,
      'dataCriacao': Timestamp.fromDate(dataCriacao),
      if (dataAtualizacao != null) 'dataAtualizacao': Timestamp.fromDate(dataAtualizacao!),
    };
  }

  RespostaDiscussaoModel copyWith({
    String? id,
    String? discussaoId,
    String? conteudo,
    String? autorId,
    String? autorNome,
    String? autorFoto,
    TipoAutor? autorTipo,
    bool? isSolucao,
    int? likes,
    List<String>? likedBy,
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
  }) {
    return RespostaDiscussaoModel(
      id: id ?? this.id,
      discussaoId: discussaoId ?? this.discussaoId,
      conteudo: conteudo ?? this.conteudo,
      autorId: autorId ?? this.autorId,
      autorNome: autorNome ?? this.autorNome,
      autorFoto: autorFoto ?? this.autorFoto,
      autorTipo: autorTipo ?? this.autorTipo,
      isSolucao: isSolucao ?? this.isSolucao,
      likes: likes ?? this.likes,
      likedBy: likedBy ?? this.likedBy,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }

  /// Verifica se a resposta foi criada pelo usuário
  bool isMinhaResposta(String usuarioId) => autorId == usuarioId;

  /// Verifica se o usuário curtiu esta resposta
  bool curtidoPor(String usuarioId) => likedBy.contains(usuarioId);

  /// Verifica se é resposta de professor ou admin
  bool get isRespostaProfissional =>
      autorTipo == TipoAutor.professor || autorTipo == TipoAutor.admin;

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
    } else if (diferenca.inDays < 30) {
      final semanas = (diferenca.inDays / 7).floor();
      return '${semanas}sem';
    } else {
      final meses = (diferenca.inDays / 30).floor();
      return '${meses}m';
    }
  }

  @override
  String toString() =>
      'RespostaDiscussaoModel(id: $id, isSolucao: $isSolucao, likes: $likes)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RespostaDiscussaoModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
