import 'package:cloud_firestore/cloud_firestore.dart';

import 'ead_enums.dart';
import 'autor_curso_model.dart';
import 'avaliacao_curso_model.dart';

/// Model para Curso no Mobile
/// Versão simplificada do CursoCompletoModel do Web Admin
class CursoModel {
  final String id;
  final String titulo;
  final String descricaoCurta;
  final String? descricao; // HTML
  final String? imagemCapa;
  final String? videoPreview;
  final StatusCurso status;
  final int ordem;
  final DateTime? dataCriacao;
  final DateTime? dataPublicacao;
  final AutorCursoModel? autor;
  final int totalAulas;
  final int totalTopicos;
  final String? duracaoEstimada;
  final List<String> tags;
  final List<String> objetivos;
  final List<String> requisitos;

  // Avaliação
  final bool requerAvaliacao;
  final bool notificarAvaliacao;
  final List<String> emailsNotificacao;
  final AvaliacaoCursoModel? avaliacao;

  const CursoModel({
    required this.id,
    required this.titulo,
    this.descricaoCurta = '',
    this.descricao,
    this.imagemCapa,
    this.videoPreview,
    this.status = StatusCurso.publicado,
    this.ordem = 0,
    this.dataCriacao,
    this.dataPublicacao,
    this.autor,
    this.totalAulas = 0,
    this.totalTopicos = 0,
    this.duracaoEstimada,
    this.tags = const [],
    this.objetivos = const [],
    this.requisitos = const [],
    this.requerAvaliacao = false,
    this.notificarAvaliacao = false,
    this.emailsNotificacao = const [],
    this.avaliacao,
  });

  factory CursoModel.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>? ?? {};
    return CursoModel.fromMap(map, doc.id);
  }

  factory CursoModel.fromMap(Map<String, dynamic> map, String id) {
    return CursoModel(
      id: id,
      titulo: map['titulo'] as String? ?? '',
      descricaoCurta: map['descricaoCurta'] as String? ?? '',
      descricao: map['descricao'] as String?,
      imagemCapa: map['imagemCapa'] as String?,
      videoPreview: map['videoPreview'] as String?,
      status: StatusCurso.fromString(map['status'] as String?),
      ordem: _parseInt(map['ordem']),
      dataCriacao: _parseTimestamp(map['dataCriacao']),
      dataPublicacao: _parseTimestamp(map['dataPublicacao']),
      autor: map['autor'] != null ? AutorCursoModel.fromMap(map['autor'] as Map<String, dynamic>) : null,
      totalAulas: _parseInt(map['totalAulas']),
      totalTopicos: _parseInt(map['totalTopicos']),
      duracaoEstimada: map['duracaoEstimada'] as String?,
      tags: _parseStringList(map['tags']),
      objetivos: _parseStringList(map['objetivos']),
      requisitos: _parseStringList(map['requisitos']),
      requerAvaliacao: map['requerAvaliacao'] as bool? ?? false,
      notificarAvaliacao: map['notificarAvaliacao'] as bool? ?? false,
      emailsNotificacao: _parseStringList(map['emailsNotificacao']),
      avaliacao: map['avaliacao'] != null
          ? AvaliacaoCursoModel.fromMap(map['avaliacao'] as Map<String, dynamic>?)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descricaoCurta': descricaoCurta,
      'descricao': descricao,
      'imagemCapa': imagemCapa,
      'videoPreview': videoPreview,
      'status': status.name,
      'ordem': ordem,
      'dataCriacao': dataCriacao,
      'dataPublicacao': dataPublicacao,
      'autor': autor?.toMap(),
      'totalAulas': totalAulas,
      'totalTopicos': totalTopicos,
      'duracaoEstimada': duracaoEstimada,
      'tags': tags,
      'objetivos': objetivos,
      'requisitos': requisitos,
      'requerAvaliacao': requerAvaliacao,
      'notificarAvaliacao': notificarAvaliacao,
      'emailsNotificacao': emailsNotificacao,
      'avaliacao': avaliacao?.toMap(),
    };
  }

  CursoModel copyWith({
    String? id,
    String? titulo,
    String? descricaoCurta,
    String? descricao,
    String? imagemCapa,
    String? videoPreview,
    StatusCurso? status,
    int? ordem,
    DateTime? dataCriacao,
    DateTime? dataPublicacao,
    AutorCursoModel? autor,
    int? totalAulas,
    int? totalTopicos,
    String? duracaoEstimada,
    List<String>? tags,
    List<String>? objetivos,
    List<String>? requisitos,
    bool? requerAvaliacao,
    bool? notificarAvaliacao,
    List<String>? emailsNotificacao,
    AvaliacaoCursoModel? avaliacao,
  }) {
    return CursoModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricaoCurta: descricaoCurta ?? this.descricaoCurta,
      descricao: descricao ?? this.descricao,
      imagemCapa: imagemCapa ?? this.imagemCapa,
      videoPreview: videoPreview ?? this.videoPreview,
      status: status ?? this.status,
      ordem: ordem ?? this.ordem,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataPublicacao: dataPublicacao ?? this.dataPublicacao,
      autor: autor ?? this.autor,
      totalAulas: totalAulas ?? this.totalAulas,
      totalTopicos: totalTopicos ?? this.totalTopicos,
      duracaoEstimada: duracaoEstimada ?? this.duracaoEstimada,
      tags: tags ?? this.tags,
      objetivos: objetivos ?? this.objetivos,
      requisitos: requisitos ?? this.requisitos,
      requerAvaliacao: requerAvaliacao ?? this.requerAvaliacao,
      notificarAvaliacao: notificarAvaliacao ?? this.notificarAvaliacao,
      emailsNotificacao: emailsNotificacao ?? this.emailsNotificacao,
      avaliacao: avaliacao ?? this.avaliacao,
    );
  }

  // === Getters úteis ===

  /// Verifica se o curso está publicado
  bool get isPublicado => status == StatusCurso.publicado;

  /// Verifica se o curso tem imagem de capa
  bool get hasImagem => imagemCapa?.isNotEmpty ?? false;

  /// Verifica se o curso tem vídeo preview
  bool get hasVideoPreview => videoPreview?.isNotEmpty ?? false;

  /// Verifica se o curso tem conteúdo
  bool get hasContent => totalAulas > 0 || totalTopicos > 0;

  /// Retorna as iniciais do título para avatar placeholder
  String get iniciais {
    final palavras = titulo.split(' ').where((p) => p.isNotEmpty).toList();
    if (palavras.isEmpty) return 'C';
    if (palavras.length == 1) return palavras[0][0].toUpperCase();
    return '${palavras[0][0]}${palavras[1][0]}'.toUpperCase();
  }

  /// Nome do autor ou 'Autor desconhecido'
  String get nomeAutor => autor?.nome ?? 'Autor desconhecido';

  // === Helpers estáticos ===

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CursoModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CursoModel(id: $id, titulo: $titulo)';
}
