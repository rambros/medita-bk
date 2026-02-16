import 'package:cloud_firestore/cloud_firestore.dart';

import 'ead_enums.dart';
import 'progresso_curso_model.dart';

/// Model para Inscrição em Curso
/// Representa a matrícula de um aluno em um curso específico
/// Compatível com InscricaoCursoModel do Web Admin
class InscricaoCursoModel {
  final String id; // Formato: {cursoId}_{usuarioId}
  final String cursoId;
  final String cursoTitulo;
  final String? cursoImagem;
  final String usuarioId;
  final String usuarioNome;
  final String usuarioEmail;
  final String? usuarioFoto;
  final DateTime? dataInscricao;
  final StatusInscricao status;
  final ProgressoCursoModel progresso;
  final DateTime? dataConclusao;
  final bool certificadoGerado;

  // Campos extras para o mobile (calculados)
  final int totalTopicos;
  final int totalAulas;

  // Campos de avaliação
  final bool avaliacaoPreenchida;
  final DateTime? dataAvaliacaoPreenchida;

  const InscricaoCursoModel({
    required this.id,
    required this.cursoId,
    required this.cursoTitulo,
    this.cursoImagem,
    required this.usuarioId,
    required this.usuarioNome,
    required this.usuarioEmail,
    this.usuarioFoto,
    this.dataInscricao,
    this.status = StatusInscricao.ativo,
    this.progresso = const ProgressoCursoModel(),
    this.dataConclusao,
    this.certificadoGerado = false,
    this.totalTopicos = 0,
    this.totalAulas = 0,
    this.avaliacaoPreenchida = false,
    this.dataAvaliacaoPreenchida,
  });

  /// Cria uma nova inscrição para o usuário atual
  factory InscricaoCursoModel.criar({
    required String cursoId,
    required String cursoTitulo,
    String? cursoImagem,
    required String usuarioId,
    required String usuarioNome,
    required String usuarioEmail,
    String? usuarioFoto,
    int totalTopicos = 0,
    int totalAulas = 0,
  }) {
    return InscricaoCursoModel(
      id: '${cursoId}_$usuarioId',
      cursoId: cursoId,
      cursoTitulo: cursoTitulo,
      cursoImagem: cursoImagem,
      usuarioId: usuarioId,
      usuarioNome: usuarioNome,
      usuarioEmail: usuarioEmail,
      usuarioFoto: usuarioFoto,
      dataInscricao: DateTime.now(),
      status: StatusInscricao.ativo,
      totalTopicos: totalTopicos,
      totalAulas: totalAulas,
    );
  }

  factory InscricaoCursoModel.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>? ?? {};
    return InscricaoCursoModel.fromMap(map, doc.id);
  }

  factory InscricaoCursoModel.fromMap(Map<String, dynamic> map, String id) {
    return InscricaoCursoModel(
      id: id,
      cursoId: map['cursoId'] as String? ?? '',
      cursoTitulo: map['cursoTitulo'] as String? ?? '',
      cursoImagem: map['cursoImagem'] as String?,
      usuarioId: map['usuarioId'] as String? ?? '',
      usuarioNome: map['usuarioNome'] as String? ?? '',
      usuarioEmail: map['usuarioEmail'] as String? ?? '',
      usuarioFoto: map['usuarioFoto'] as String?,
      dataInscricao: _parseTimestamp(map['dataInscricao']),
      status: StatusInscricao.fromString(map['status'] as String?),
      progresso: ProgressoCursoModel.fromMap(map['progresso'] as Map<String, dynamic>?),
      dataConclusao: _parseTimestamp(map['dataConclusao']),
      certificadoGerado: map['certificadoGerado'] as bool? ?? false,
      totalTopicos: map['totalTopicos'] as int? ?? 0,
      totalAulas: map['totalAulas'] as int? ?? 0,
      avaliacaoPreenchida: map['avaliacaoPreenchida'] as bool? ?? false,
      dataAvaliacaoPreenchida: _parseTimestamp(map['dataAvaliacaoPreenchida']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cursoId': cursoId,
      'cursoTitulo': cursoTitulo,
      'cursoImagem': cursoImagem,
      'usuarioId': usuarioId,
      'usuarioNome': usuarioNome,
      'usuarioEmail': usuarioEmail,
      'usuarioFoto': usuarioFoto,
      'dataInscricao': dataInscricao,
      'status': status.name,
      'progresso': progresso.toMap(),
      'dataConclusao': dataConclusao,
      'certificadoGerado': certificadoGerado,
      'totalTopicos': totalTopicos,
      'totalAulas': totalAulas,
      'avaliacaoPreenchida': avaliacaoPreenchida,
      'dataAvaliacaoPreenchida': dataAvaliacaoPreenchida,
      // Campos de busca
      'usuarioNomeSearch': usuarioNome.toLowerCase(),
      'usuarioEmailSearch': usuarioEmail.toLowerCase(),
      // Campos denormalizados para queries eficientes no web admin
      'totalAulasCompletas': progresso.aulasCompletas.length,
      'ultimoAcessoTimestamp': progresso.ultimoAcesso,
    };
  }

  InscricaoCursoModel copyWith({
    String? id,
    String? cursoId,
    String? cursoTitulo,
    String? cursoImagem,
    String? usuarioId,
    String? usuarioNome,
    String? usuarioEmail,
    String? usuarioFoto,
    DateTime? dataInscricao,
    StatusInscricao? status,
    ProgressoCursoModel? progresso,
    DateTime? dataConclusao,
    bool? certificadoGerado,
    int? totalTopicos,
    int? totalAulas,
    bool? avaliacaoPreenchida,
    DateTime? dataAvaliacaoPreenchida,
  }) {
    return InscricaoCursoModel(
      id: id ?? this.id,
      cursoId: cursoId ?? this.cursoId,
      cursoTitulo: cursoTitulo ?? this.cursoTitulo,
      cursoImagem: cursoImagem ?? this.cursoImagem,
      usuarioId: usuarioId ?? this.usuarioId,
      usuarioNome: usuarioNome ?? this.usuarioNome,
      usuarioEmail: usuarioEmail ?? this.usuarioEmail,
      usuarioFoto: usuarioFoto ?? this.usuarioFoto,
      dataInscricao: dataInscricao ?? this.dataInscricao,
      status: status ?? this.status,
      progresso: progresso ?? this.progresso,
      dataConclusao: dataConclusao ?? this.dataConclusao,
      certificadoGerado: certificadoGerado ?? this.certificadoGerado,
      totalTopicos: totalTopicos ?? this.totalTopicos,
      totalAulas: totalAulas ?? this.totalAulas,
      avaliacaoPreenchida: avaliacaoPreenchida ?? this.avaliacaoPreenchida,
      dataAvaliacaoPreenchida: dataAvaliacaoPreenchida ?? this.dataAvaliacaoPreenchida,
    );
  }

  // === Getters de status ===

  /// Verifica se a inscrição está ativa
  bool get isAtivo => status == StatusInscricao.ativo;

  /// Verifica se o curso foi concluído
  bool get isConcluido => status == StatusInscricao.concluido;

  /// Verifica se a inscrição está pausada
  bool get isPausado => status == StatusInscricao.pausado;

  /// Verifica se a inscrição foi cancelada
  bool get isCancelado => status == StatusInscricao.cancelado;

  // === Getters de progresso ===

  /// Percentual de conclusão
  double get percentualConcluido => progresso.percentualConcluido;

  /// Percentual formatado (ex: "75%")
  String get percentualFormatado => progresso.percentualFormatado;

  /// Número de tópicos concluídos
  int get topicosCompletos => progresso.totalTopicosCompletos;

  /// Verifica se há progresso
  bool get hasProgresso => progresso.hasProgresso;

  /// Calcula progresso baseado em tópicos
  double calcularProgresso() {
    if (totalTopicos == 0) return 0;
    return (progresso.totalTopicosCompletos / totalTopicos) * 100;
  }

  // === Getters auxiliares ===

  /// Retorna as iniciais do nome do usuário
  String get iniciais {
    final palavras = usuarioNome.split(' ').where((p) => p.isNotEmpty).toList();
    if (palavras.isEmpty) return 'U';
    if (palavras.length == 1) return palavras[0][0].toUpperCase();
    return '${palavras[0][0]}${palavras[1][0]}'.toUpperCase();
  }

  /// Calcula dias desde a inscrição
  int get diasDesdeInscricao {
    if (dataInscricao == null) return 0;
    return DateTime.now().difference(dataInscricao!).inDays;
  }

  /// Calcula dias desde o último acesso
  int? get diasDesdeUltimoAcesso {
    if (progresso.ultimoAcesso == null) return null;
    return DateTime.now().difference(progresso.ultimoAcesso!).inDays;
  }

  /// Texto do botão baseado no status
  String get textoBotaoAcao {
    if (!isAtivo) return 'Ver Curso';

    if (!progresso.hasProgresso) {
      return 'Iniciar Curso';
    } else if (progresso.isConcluido) {
      return 'Revisar Curso';
    } else {
      return 'Continuar Curso';
    }
  }

  // === Helpers estáticos ===

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  /// Gera o ID da inscrição baseado em cursoId e usuarioId
  static String gerarId(String cursoId, String usuarioId) {
    return '${cursoId}_$usuarioId';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InscricaoCursoModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'InscricaoCursoModel(id: $id, curso: $cursoTitulo, status: ${status.name})';
}
