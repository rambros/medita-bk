import 'package:cloud_firestore/cloud_firestore.dart';

import 'ead_enums.dart';

/// Model para conteúdo de um tópico
class ConteudoTopicoModel {
  final String? url;
  final int? duracao; // Em segundos
  final String? thumbnail;
  final String? htmlContent;

  const ConteudoTopicoModel({
    this.url,
    this.duracao,
    this.thumbnail,
    this.htmlContent,
  });

  factory ConteudoTopicoModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const ConteudoTopicoModel();

    return ConteudoTopicoModel(
      url: map['url'] as String?,
      duracao: _parseInt(map['duracao']),
      thumbnail: map['thumbnail'] as String?,
      htmlContent: map['htmlContent'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (url != null) 'url': url,
      if (duracao != null) 'duracao': duracao,
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (htmlContent != null) 'htmlContent': htmlContent,
    };
  }

  ConteudoTopicoModel copyWith({
    String? url,
    int? duracao,
    String? thumbnail,
    String? htmlContent,
  }) {
    return ConteudoTopicoModel(
      url: url ?? this.url,
      duracao: duracao ?? this.duracao,
      thumbnail: thumbnail ?? this.thumbnail,
      htmlContent: htmlContent ?? this.htmlContent,
    );
  }

  /// Retorna a duração formatada (ex: "5:30")
  String get duracaoFormatada {
    if (duracao == null || duracao == 0) return '';
    final minutos = duracao! ~/ 60;
    final segundos = duracao! % 60;
    return '$minutos:${segundos.toString().padLeft(2, '0')}';
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  @override
  String toString() => 'ConteudoTopicoModel(url: $url, duracao: $duracao)';
}

/// Model para Tópico no Mobile
/// Representa um item de conteúdo dentro de uma aula
/// Equivalente a "Lesson" no lib_sample
class TopicoModel {
  final String id;
  final String titulo;
  final String? descricao;
  final int ordem;
  final TipoConteudoTopico tipo;
  final ConteudoTopicoModel conteudo;
  final DateTime? dataCriacao;

  // Campos auxiliares (não persistidos)
  final String? aulaId;
  final String? cursoId;

  const TopicoModel({
    required this.id,
    required this.titulo,
    this.descricao,
    this.ordem = 0,
    this.tipo = TipoConteudoTopico.texto,
    this.conteudo = const ConteudoTopicoModel(),
    this.dataCriacao,
    this.aulaId,
    this.cursoId,
  });

  factory TopicoModel.fromFirestore(
    DocumentSnapshot doc, {
    String? aulaId,
    String? cursoId,
  }) {
    final map = doc.data() as Map<String, dynamic>? ?? {};
    return TopicoModel.fromMap(map, doc.id, aulaId: aulaId, cursoId: cursoId);
  }

  factory TopicoModel.fromMap(
    Map<String, dynamic> map,
    String id, {
    String? aulaId,
    String? cursoId,
  }) {
    return TopicoModel(
      id: id,
      titulo: map['titulo'] as String? ?? '',
      descricao: map['descricao'] as String?,
      ordem: _parseInt(map['ordem']) ?? 0,
      tipo: TipoConteudoTopico.fromString(map['tipo'] as String?),
      conteudo: ConteudoTopicoModel.fromMap(
        map['conteudo'] as Map<String, dynamic>?,
      ),
      dataCriacao: _parseTimestamp(map['dataCriacao']),
      aulaId: aulaId,
      cursoId: cursoId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'ordem': ordem,
      'tipo': tipo.name,
      'conteudo': conteudo.toMap(),
      'dataCriacao': dataCriacao,
    };
  }

  TopicoModel copyWith({
    String? id,
    String? titulo,
    String? descricao,
    int? ordem,
    TipoConteudoTopico? tipo,
    ConteudoTopicoModel? conteudo,
    DateTime? dataCriacao,
    String? aulaId,
    String? cursoId,
  }) {
    return TopicoModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      ordem: ordem ?? this.ordem,
      tipo: tipo ?? this.tipo,
      conteudo: conteudo ?? this.conteudo,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      aulaId: aulaId ?? this.aulaId,
      cursoId: cursoId ?? this.cursoId,
    );
  }

  // === Getters úteis ===

  /// URL do conteúdo (vídeo, áudio)
  String? get url => conteudo.url;

  /// Duração em segundos
  int? get duracao => conteudo.duracao;

  /// Duração formatada (ex: "5:30")
  String get duracaoFormatada => conteudo.duracaoFormatada;

  /// Conteúdo HTML (para tipo texto)
  String? get htmlContent => conteudo.htmlContent;

  /// Thumbnail do vídeo
  String? get thumbnail => conteudo.thumbnail;

  /// Verifica se é um vídeo
  bool get isVideo => tipo == TipoConteudoTopico.video;

  /// Verifica se é um áudio
  bool get isAudio => tipo == TipoConteudoTopico.audio;

  /// Verifica se é texto
  bool get isTexto => tipo == TipoConteudoTopico.texto;

  /// Verifica se é quiz
  bool get isQuiz => tipo == TipoConteudoTopico.quiz;

  /// Verifica se é PDF
  bool get isPdf => tipo == TipoConteudoTopico.pdf;

  /// Verifica se o tópico tem conteúdo válido
  bool get hasContent {
    switch (tipo) {
      case TipoConteudoTopico.video:
      case TipoConteudoTopico.audio:
      case TipoConteudoTopico.pdf:
        return conteudo.url?.isNotEmpty ?? false;
      case TipoConteudoTopico.texto:
        return conteudo.htmlContent?.isNotEmpty ?? false;
      case TipoConteudoTopico.quiz:
        return true; // Quiz sempre tem conteúdo (perguntas)
    }
  }

  /// Verifica se é um vídeo do YouTube
  bool get isYouTubeVideo {
    if (!isVideo || url == null) return false;
    return url!.contains('youtube.com') || url!.contains('youtu.be');
  }

  /// Extrai o ID do vídeo do YouTube
  String? get youtubeVideoId {
    if (!isYouTubeVideo || url == null) return null;

    final uri = Uri.tryParse(url!);
    if (uri == null) return null;

    // Formato: https://www.youtube.com/watch?v=VIDEO_ID
    if (uri.host.contains('youtube.com')) {
      return uri.queryParameters['v'];
    }

    // Formato: https://youtu.be/VIDEO_ID
    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    }

    return null;
  }

  // === Helpers estáticos ===

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TopicoModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'TopicoModel(id: $id, titulo: $titulo, tipo: ${tipo.name})';
}
