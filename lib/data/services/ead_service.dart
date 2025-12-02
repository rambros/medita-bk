import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../domain/models/ead/index.dart';

/// Service para acesso ao Firebase do módulo EAD
/// Responsável por operações de leitura/escrita no Firestore
class EadService {
  final FirebaseFirestore _firestore;

  EadService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // === Collections ===

  CollectionReference<Map<String, dynamic>> get _cursosCollection =>
      _firestore.collection('cursos');

  CollectionReference<Map<String, dynamic>> get _inscricoesCollection =>
      _firestore.collection('inscricoes_cursos');

  CollectionReference<Map<String, dynamic>> _aulasCollection(String cursoId) =>
      _cursosCollection.doc(cursoId).collection('aulas');

  CollectionReference<Map<String, dynamic>> _topicosCollection(
    String cursoId,
    String aulaId,
  ) =>
      _aulasCollection(cursoId).doc(aulaId).collection('topicos');

  // === Cursos ===

  /// Busca todos os cursos publicados
  Future<List<CursoModel>> getCursosPublicados() async {
    final snapshot = await _cursosCollection
        .where('status', isEqualTo: 'publicado')
        .orderBy('ordem')
        .get();

    return snapshot.docs.map((doc) => CursoModel.fromFirestore(doc)).toList();
  }

  /// Busca um curso pelo ID
  Future<CursoModel?> getCursoById(String cursoId) async {
    final doc = await _cursosCollection.doc(cursoId).get();
    if (!doc.exists) return null;
    return CursoModel.fromFirestore(doc);
  }

  /// Stream de cursos publicados
  Stream<List<CursoModel>> streamCursosPublicados() {
    return _cursosCollection
        .where('status', isEqualTo: 'publicado')
        .orderBy('ordem')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => CursoModel.fromFirestore(doc)).toList());
  }

  // === Aulas ===

  /// Busca todas as aulas de um curso
  Future<List<AulaModel>> getAulasByCurso(String cursoId) async {
    final snapshot =
        await _aulasCollection(cursoId).orderBy('ordem').get();

    return snapshot.docs
        .map((doc) => AulaModel.fromFirestore(doc, cursoId: cursoId))
        .toList();
  }

  /// Stream de aulas de um curso
  Stream<List<AulaModel>> streamAulasByCurso(String cursoId) {
    return _aulasCollection(cursoId).orderBy('ordem').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => AulaModel.fromFirestore(doc, cursoId: cursoId))
            .toList());
  }

  // === Tópicos ===

  /// Busca todos os tópicos de uma aula
  Future<List<TopicoModel>> getTopicosByAula(
    String cursoId,
    String aulaId,
  ) async {
    final snapshot =
        await _topicosCollection(cursoId, aulaId).orderBy('ordem').get();

    return snapshot.docs
        .map((doc) =>
            TopicoModel.fromFirestore(doc, cursoId: cursoId, aulaId: aulaId))
        .toList();
  }

  /// Busca um tópico específico
  Future<TopicoModel?> getTopicoById(
    String cursoId,
    String aulaId,
    String topicoId,
  ) async {
    final doc =
        await _topicosCollection(cursoId, aulaId).doc(topicoId).get();

    if (!doc.exists) return null;
    return TopicoModel.fromFirestore(doc, cursoId: cursoId, aulaId: aulaId);
  }

  /// Stream de tópicos de uma aula
  Stream<List<TopicoModel>> streamTopicosByAula(
    String cursoId,
    String aulaId,
  ) {
    return _topicosCollection(cursoId, aulaId).orderBy('ordem').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) =>
                TopicoModel.fromFirestore(doc, cursoId: cursoId, aulaId: aulaId))
            .toList());
  }

  /// Busca todos os tópicos de um curso (todas as aulas)
  Future<List<TopicoModel>> getTodosTopicosCurso(String cursoId) async {
    final aulas = await getAulasByCurso(cursoId);
    final todosTopicos = <TopicoModel>[];

    for (final aula in aulas) {
      final topicos = await getTopicosByAula(cursoId, aula.id);
      todosTopicos.addAll(topicos);
    }

    return todosTopicos;
  }

  // === Inscrições ===

  /// Busca a inscrição de um usuário em um curso
  Future<InscricaoCursoModel?> getInscricao(
    String cursoId,
    String usuarioId,
  ) async {
    final inscricaoId = InscricaoCursoModel.gerarId(cursoId, usuarioId);
    debugPrint('EadService.getInscricao: Buscando inscricao $inscricaoId');
    final doc = await _inscricoesCollection.doc(inscricaoId).get();

    if (!doc.exists) {
      debugPrint('EadService.getInscricao: Inscricao nao encontrada');
      return null;
    }
    final inscricao = InscricaoCursoModel.fromFirestore(doc);
    debugPrint('EadService.getInscricao: topicosCompletos=${inscricao.progresso.topicosCompletos}');
    debugPrint('EadService.getInscricao: percentual=${inscricao.progresso.percentualConcluido}');
    return inscricao;
  }

  /// Busca todas as inscrições de um usuário
  Future<List<InscricaoCursoModel>> getInscricoesByUsuario(
    String usuarioId,
  ) async {
    final snapshot = await _inscricoesCollection
        .where('usuarioId', isEqualTo: usuarioId)
        .orderBy('dataInscricao', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => InscricaoCursoModel.fromFirestore(doc))
        .toList();
  }

  /// Busca inscrições ativas de um usuário
  Future<List<InscricaoCursoModel>> getInscricoesAtivasByUsuario(
    String usuarioId,
  ) async {
    final snapshot = await _inscricoesCollection
        .where('usuarioId', isEqualTo: usuarioId)
        .where('status', isEqualTo: 'ativo')
        .orderBy('dataInscricao', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => InscricaoCursoModel.fromFirestore(doc))
        .toList();
  }

  /// Stream de inscrições de um usuário
  Stream<List<InscricaoCursoModel>> streamInscricoesByUsuario(
    String usuarioId,
  ) {
    return _inscricoesCollection
        .where('usuarioId', isEqualTo: usuarioId)
        .orderBy('dataInscricao', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => InscricaoCursoModel.fromFirestore(doc))
            .toList());
  }

  /// Cria uma nova inscrição
  Future<void> criarInscricao(InscricaoCursoModel inscricao) async {
    await _inscricoesCollection.doc(inscricao.id).set(inscricao.toMap());
  }

  /// Atualiza uma inscrição existente
  Future<void> atualizarInscricao(InscricaoCursoModel inscricao) async {
    await _inscricoesCollection.doc(inscricao.id).update(inscricao.toMap());
  }

  /// Atualiza apenas o progresso de uma inscrição
  Future<void> atualizarProgresso(
    String inscricaoId,
    ProgressoCursoModel progresso,
  ) async {
    debugPrint('EadService.atualizarProgresso: inscricaoId=$inscricaoId');
    debugPrint('EadService.atualizarProgresso: topicosCompletos=${progresso.topicosCompletos}');
    debugPrint('EadService.atualizarProgresso: percentual=${progresso.percentualConcluido}');
    await _inscricoesCollection.doc(inscricaoId).update({
      'progresso': progresso.toMap(),
    });
    debugPrint('EadService.atualizarProgresso: Salvo com sucesso!');
  }

  /// Atualiza status da inscrição
  Future<void> atualizarStatusInscricao(
    String inscricaoId,
    StatusInscricao status, {
    DateTime? dataConclusao,
  }) async {
    final data = <String, dynamic>{
      'status': status.name,
    };

    if (dataConclusao != null) {
      data['dataConclusao'] = dataConclusao;
    }

    await _inscricoesCollection.doc(inscricaoId).update(data);
  }

  /// Cancela uma inscrição
  Future<void> cancelarInscricao(String inscricaoId) async {
    await atualizarStatusInscricao(inscricaoId, StatusInscricao.cancelado);
  }

  // === Quiz ===

  /// Busca questões do quiz de um tópico
  Future<List<QuizQuestionModel>> getQuizByTopico(
    String cursoId,
    String aulaId,
    String topicoId,
  ) async {
    final topicoDoc =
        await _topicosCollection(cursoId, aulaId).doc(topicoId).get();

    if (!topicoDoc.exists) return [];

    final data = topicoDoc.data();
    final quizData = data?['quiz'] as List<dynamic>? ?? [];

    return quizData
        .asMap()
        .entries
        .map((entry) => QuizQuestionModel.fromMap(
              entry.value as Map<String, dynamic>,
              'question_${entry.key}',
            ))
        .toList();
  }

  // === Helpers ===

  /// Verifica se um usuário está inscrito em um curso
  Future<bool> isInscrito(String cursoId, String usuarioId) async {
    final inscricao = await getInscricao(cursoId, usuarioId);
    return inscricao != null && inscricao.isAtivo;
  }

  /// Conta total de inscritos em um curso
  Future<int> contarInscritosCurso(String cursoId) async {
    final snapshot = await _inscricoesCollection
        .where('cursoId', isEqualTo: cursoId)
        .where('status', isEqualTo: 'ativo')
        .count()
        .get();

    return snapshot.count ?? 0;
  }
}
