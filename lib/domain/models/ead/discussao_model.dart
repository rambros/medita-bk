/// Modelo de Discussão (Q&A) do módulo EAD
/// Compatível com a estrutura do Web Admin
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'comunicacao_enums.dart';

class DiscussaoModel {
  final String id;
  final String cursoId;
  final String cursoTitulo;
  final String? aulaId;
  final String? aulaTitulo;
  final String? topicoId;
  final String? topicoTitulo;
  final String titulo;
  final String conteudo;
  final String autorId;
  final String autorNome;
  final String? autorFoto;
  final TipoAutor autorTipo;
  final StatusDiscussao status;
  final bool isPrivada;
  final bool isPinned;
  final bool isDestaque;
  final DateTime dataCriacao;
  final DateTime dataAtualizacao;
  final int totalRespostas;
  final List<String> tags;

  // Campos de fechamento
  final String? fechadaPor;
  final DateTime? dataFechamento;

  const DiscussaoModel({
    required this.id,
    required this.cursoId,
    required this.cursoTitulo,
    this.aulaId,
    this.aulaTitulo,
    this.topicoId,
    this.topicoTitulo,
    required this.titulo,
    required this.conteudo,
    required this.autorId,
    required this.autorNome,
    this.autorFoto,
    required this.autorTipo,
    required this.status,
    this.isPrivada = false,
    this.isPinned = false,
    this.isDestaque = false,
    required this.dataCriacao,
    required this.dataAtualizacao,
    this.totalRespostas = 0,
    this.tags = const [],
    this.fechadaPor,
    this.dataFechamento,
  });

  factory DiscussaoModel.fromMap(Map<String, dynamic> map, String docId) {
    DateTime parseDate(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      return DateTime.now();
    }

    return DiscussaoModel(
      id: docId,
      cursoId: map['cursoId'] as String? ?? '',
      cursoTitulo: map['cursoTitulo'] as String? ?? '',
      aulaId: map['aulaId'] as String?,
      aulaTitulo: map['aulaTitulo'] as String?,
      topicoId: map['topicoId'] as String?,
      topicoTitulo: map['topicoTitulo'] as String?,
      titulo: map['titulo'] as String? ?? '',
      conteudo: map['conteudo'] as String? ?? '',
      autorId: map['autorId'] as String? ?? '',
      autorNome: map['autorNome'] as String? ?? 'Usuário',
      autorFoto: map['autorFoto'] as String?,
      autorTipo: TipoAutor.fromString(map['autorTipo'] as String?),
      status: StatusDiscussao.fromString(map['status'] as String?),
      isPrivada: map['isPrivada'] as bool? ?? false,
      isPinned: map['isPinned'] as bool? ?? false,
      isDestaque: map['isDestaque'] as bool? ?? false,
      dataCriacao: parseDate(map['dataCriacao']),
      dataAtualizacao: parseDate(map['dataAtualizacao']),
      totalRespostas: map['totalRespostas'] as int? ?? 0,
      tags: (map['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      fechadaPor: map['fechadaPor'] as String?,
      dataFechamento: map['dataFechamento'] != null ? parseDate(map['dataFechamento']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cursoId': cursoId,
      'cursoTitulo': cursoTitulo,
      'aulaId': aulaId,
      'aulaTitulo': aulaTitulo,
      'topicoId': topicoId,
      'topicoTitulo': topicoTitulo,
      'titulo': titulo,
      'conteudo': conteudo,
      'autorId': autorId,
      'autorNome': autorNome,
      'autorFoto': autorFoto,
      'autorTipo': autorTipo.name,
      'status': status.name,
      'isPrivada': isPrivada,
      'isPinned': isPinned,
      'isDestaque': isDestaque,
      'dataCriacao': Timestamp.fromDate(dataCriacao),
      'dataAtualizacao': Timestamp.fromDate(dataAtualizacao),
      'totalRespostas': totalRespostas,
      'tags': tags,
      if (fechadaPor != null) 'fechadaPor': fechadaPor,
      if (dataFechamento != null) 'dataFechamento': Timestamp.fromDate(dataFechamento!),
    };
  }

  DiscussaoModel copyWith({
    String? id,
    String? cursoId,
    String? cursoTitulo,
    String? aulaId,
    String? aulaTitulo,
    String? topicoId,
    String? topicoTitulo,
    String? titulo,
    String? conteudo,
    String? autorId,
    String? autorNome,
    String? autorFoto,
    TipoAutor? autorTipo,
    StatusDiscussao? status,
    bool? isPrivada,
    bool? isPinned,
    bool? isDestaque,
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
    int? totalRespostas,
    List<String>? tags,
    String? fechadaPor,
    DateTime? dataFechamento,
  }) {
    return DiscussaoModel(
      id: id ?? this.id,
      cursoId: cursoId ?? this.cursoId,
      cursoTitulo: cursoTitulo ?? this.cursoTitulo,
      aulaId: aulaId ?? this.aulaId,
      aulaTitulo: aulaTitulo ?? this.aulaTitulo,
      topicoId: topicoId ?? this.topicoId,
      topicoTitulo: topicoTitulo ?? this.topicoTitulo,
      titulo: titulo ?? this.titulo,
      conteudo: conteudo ?? this.conteudo,
      autorId: autorId ?? this.autorId,
      autorNome: autorNome ?? this.autorNome,
      autorFoto: autorFoto ?? this.autorFoto,
      autorTipo: autorTipo ?? this.autorTipo,
      status: status ?? this.status,
      isPrivada: isPrivada ?? this.isPrivada,
      isPinned: isPinned ?? this.isPinned,
      isDestaque: isDestaque ?? this.isDestaque,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
      totalRespostas: totalRespostas ?? this.totalRespostas,
      tags: tags ?? this.tags,
      fechadaPor: fechadaPor ?? this.fechadaPor,
      dataFechamento: dataFechamento ?? this.dataFechamento,
    );
  }

  /// Verifica se a discussão foi criada pelo usuário
  bool isMinhaDiscussao(String usuarioId) => autorId == usuarioId;

  /// Verifica se tem respostas
  bool get temRespostas => totalRespostas > 0;

  /// Verifica se está aberta para novas respostas
  bool get podeResponder => !status.isFechada;

  /// Verifica se o usuário pode fechar a discussão
  bool podeFechar(String usuarioId) => isMinhaDiscussao(usuarioId) && !status.isFechada;

  /// Verifica se o usuário pode reabrir a discussão
  bool podeReabrir(String usuarioId) => isMinhaDiscussao(usuarioId) && status.isFechada;

  /// Retorna o contexto da discussão (Curso > Aula > Tópico)
  String get contexto {
    final partes = <String>[cursoTitulo];
    if (aulaTitulo != null && aulaTitulo!.isNotEmpty) {
      partes.add(aulaTitulo!);
    }
    if (topicoTitulo != null && topicoTitulo!.isNotEmpty) {
      partes.add(topicoTitulo!);
    }
    return partes.join(' > ');
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
    } else if (diferenca.inDays < 30) {
      final semanas = (diferenca.inDays / 7).floor();
      return '${semanas}sem';
    } else {
      final meses = (diferenca.inDays / 30).floor();
      return '${meses}m';
    }
  }

  @override
  String toString() => 'DiscussaoModel(id: $id, titulo: $titulo, status: ${status.label})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DiscussaoModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
