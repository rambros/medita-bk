import '../services/ead_service.dart';
import '../../domain/models/ead/index.dart';

/// Repository para o módulo EAD
/// Camada de abstração entre Service e ViewModels
/// Responsável por lógica de negócio e cache
/// Implementado como Singleton para compartilhar cache entre ViewModels
class EadRepository {
  // Singleton instance
  static final EadRepository _instance = EadRepository._internal();

  factory EadRepository() => _instance;

  EadRepository._internal() : _service = EadService();

  final EadService _service;

  // === Cache local (opcional, pode ser expandido) ===

  final Map<String, CursoModel> _cursosCache = {};
  final Map<String, List<AulaModel>> _aulasCache = {};
  final Map<String, InscricaoCursoModel> _inscricoesCache = {};

  // === Cursos ===

  /// Busca todos os cursos disponíveis (publicados)
  Future<List<CursoModel>> getCursosDisponiveis({bool forceRefresh = false}) async {
    if (!forceRefresh && _cursosCache.isNotEmpty) {
      return _cursosCache.values.toList();
    }

    final cursos = await _service.getCursosPublicados();

    // Atualiza cache
    _cursosCache.clear();
    for (final curso in cursos) {
      _cursosCache[curso.id] = curso;
    }

    return cursos;
  }

  /// Busca um curso pelo ID
  Future<CursoModel?> getCursoById(String cursoId) async {
    // Verifica cache primeiro
    if (_cursosCache.containsKey(cursoId)) {
      return _cursosCache[cursoId];
    }

    final curso = await _service.getCursoById(cursoId);

    if (curso != null) {
      _cursosCache[cursoId] = curso;
    }

    return curso;
  }

  /// Stream de cursos disponíveis
  Stream<List<CursoModel>> streamCursosDisponiveis() {
    return _service.streamCursosPublicados();
  }

  // === Aulas ===

  /// Busca todas as aulas de um curso
  Future<List<AulaModel>> getAulasByCurso(String cursoId) async {
    // Verifica cache
    if (_aulasCache.containsKey(cursoId)) {
      return _aulasCache[cursoId]!;
    }

    final aulas = await _service.getAulasByCurso(cursoId);
    _aulasCache[cursoId] = aulas;

    return aulas;
  }

  /// Busca aulas com tópicos carregados
  Future<List<AulaModel>> getAulasComTopicos(String cursoId) async {
    final aulas = await getAulasByCurso(cursoId);
    final aulasComTopicos = <AulaModel>[];

    for (final aula in aulas) {
      final topicos = await getTopicosByAula(cursoId, aula.id);
      aulasComTopicos.add(aula.copyWith(topicos: topicos));
    }

    return aulasComTopicos;
  }

  /// Stream de aulas
  Stream<List<AulaModel>> streamAulasByCurso(String cursoId) {
    return _service.streamAulasByCurso(cursoId);
  }

  // === Tópicos ===

  /// Busca todos os tópicos de uma aula
  Future<List<TopicoModel>> getTopicosByAula(
    String cursoId,
    String aulaId,
  ) async {
    return await _service.getTopicosByAula(cursoId, aulaId);
  }

  /// Busca um tópico específico
  Future<TopicoModel?> getTopicoById(
    String cursoId,
    String aulaId,
    String topicoId,
  ) async {
    return await _service.getTopicoById(cursoId, aulaId, topicoId);
  }

  /// Busca todos os tópicos de um curso
  Future<List<TopicoModel>> getTodosTopicosCurso(String cursoId) async {
    return await _service.getTodosTopicosCurso(cursoId);
  }

  /// Stream de tópicos
  Stream<List<TopicoModel>> streamTopicosByAula(
    String cursoId,
    String aulaId,
  ) {
    return _service.streamTopicosByAula(cursoId, aulaId);
  }

  // === Inscrições ===

  /// Busca a inscrição do usuário em um curso
  Future<InscricaoCursoModel?> getInscricao(
    String cursoId,
    String usuarioId, {
    bool forceRefresh = false,
  }) async {
    final cacheKey = InscricaoCursoModel.gerarId(cursoId, usuarioId);

    if (!forceRefresh && _inscricoesCache.containsKey(cacheKey)) {
      return _inscricoesCache[cacheKey];
    }

    final inscricao = await _service.getInscricao(cursoId, usuarioId);

    if (inscricao != null) {
      _inscricoesCache[cacheKey] = inscricao;
    } else {
      _inscricoesCache.remove(cacheKey);
    }

    return inscricao;
  }

  /// Busca todas as inscrições de um usuário
  Future<List<InscricaoCursoModel>> getMeusInscritos(String usuarioId) async {
    return await _service.getInscricoesByUsuario(usuarioId);
  }

  /// Busca inscrições ativas de um usuário
  Future<List<InscricaoCursoModel>> getMeusInscritosAtivos(
    String usuarioId,
  ) async {
    return await _service.getInscricoesAtivasByUsuario(usuarioId);
  }

  /// Stream de inscrições do usuário
  Stream<List<InscricaoCursoModel>> streamMeusInscritos(String usuarioId) {
    return _service.streamInscricoesByUsuario(usuarioId);
  }

  /// Verifica se o usuário está inscrito em um curso
  Future<bool> isInscrito(String cursoId, String usuarioId) async {
    return await _service.isInscrito(cursoId, usuarioId);
  }

  /// Inscreve o usuário em um curso
  Future<InscricaoCursoModel> inscreverNoCurso({
    required CursoModel curso,
    required String usuarioId,
    required String usuarioNome,
    required String usuarioEmail,
    String? usuarioFoto,
  }) async {
    // Verifica se já está inscrito
    final inscricaoExistente = await getInscricao(curso.id, usuarioId);
    if (inscricaoExistente != null && inscricaoExistente.isAtivo) {
      return inscricaoExistente;
    }

    // Conta total de tópicos para calcular progresso
    final todosTopicos = await getTodosTopicosCurso(curso.id);
    final aulas = await getAulasByCurso(curso.id);

    // Cria nova inscrição
    final novaInscricao = InscricaoCursoModel.criar(
      cursoId: curso.id,
      cursoTitulo: curso.titulo,
      cursoImagem: curso.imagemCapa,
      usuarioId: usuarioId,
      usuarioNome: usuarioNome,
      usuarioEmail: usuarioEmail,
      usuarioFoto: usuarioFoto,
      totalTopicos: todosTopicos.length,
      totalAulas: aulas.length,
    );

    await _service.criarInscricao(novaInscricao);

    // Atualiza cache
    _inscricoesCache[novaInscricao.id] = novaInscricao;

    return novaInscricao;
  }

  /// Cancela inscrição do usuário
  Future<void> cancelarInscricao(String cursoId, String usuarioId) async {
    final inscricaoId = InscricaoCursoModel.gerarId(cursoId, usuarioId);
    await _service.cancelarInscricao(inscricaoId);

    // Remove do cache
    _inscricoesCache.remove(inscricaoId);
  }

  // === Progresso ===

  /// Marca um tópico como concluído
  Future<InscricaoCursoModel> marcarTopicoCompleto({
    required String cursoId,
    required String aulaId,
    required String topicoId,
    required String usuarioId,
  }) async {
    final inscricaoId = InscricaoCursoModel.gerarId(cursoId, usuarioId);
    var inscricao = await getInscricao(cursoId, usuarioId);

    if (inscricao == null) {
      throw Exception('Inscrição não encontrada');
    }

    // Atualiza progresso
    var novoProgresso = inscricao.progresso.adicionarTopicoCompleto(topicoId).atualizarUltimoAcesso(topicoId, aulaId);

    // Verifica se completou a aula
    final topicosAula = await getTopicosByAula(cursoId, aulaId);
    final topicosAulaIds = topicosAula.map((t) => t.id).toSet();
    final topicosCompletosAula = novoProgresso.topicosCompletos.where((id) => topicosAulaIds.contains(id)).length;

    if (topicosCompletosAula == topicosAula.length) {
      novoProgresso = novoProgresso.adicionarAulaCompleta(aulaId);
    }

    // Calcula percentual
    final percentual =
        inscricao.totalTopicos > 0 ? (novoProgresso.totalTopicosCompletos / inscricao.totalTopicos) * 100 : 0.0;

    novoProgresso = novoProgresso.copyWith(percentualConcluido: percentual);

    // Atualiza no Firebase
    await _service.atualizarProgresso(inscricaoId, novoProgresso);

    // Verifica se completou o curso (100%)
    if (percentual >= 100 && inscricao.isAtivo) {
      await _service.atualizarStatusInscricao(
        inscricaoId,
        StatusInscricao.concluido,
        dataConclusao: DateTime.now(),
      );

      inscricao = inscricao.copyWith(
        status: StatusInscricao.concluido,
        dataConclusao: DateTime.now(),
      );
    }

    // Atualiza modelo local
    inscricao = inscricao.copyWith(progresso: novoProgresso);

    // Atualiza cache
    _inscricoesCache[inscricaoId] = inscricao;

    return inscricao;
  }

  /// Marca um tópico como não concluído
  Future<InscricaoCursoModel> desmarcarTopicoCompleto({
    required String cursoId,
    required String aulaId,
    required String topicoId,
    required String usuarioId,
  }) async {
    final inscricaoId = InscricaoCursoModel.gerarId(cursoId, usuarioId);
    var inscricao = await getInscricao(cursoId, usuarioId);

    if (inscricao == null) {
      throw Exception('Inscrição não encontrada');
    }

    // Atualiza progresso
    var novoProgresso = inscricao.progresso.removerTopicoCompleto(topicoId);

    // Recalcula percentual
    final percentual =
        inscricao.totalTopicos > 0 ? (novoProgresso.totalTopicosCompletos / inscricao.totalTopicos) * 100 : 0.0;

    novoProgresso = novoProgresso.copyWith(percentualConcluido: percentual);

    // Atualiza no Firebase
    await _service.atualizarProgresso(inscricaoId, novoProgresso);

    // Se estava concluído, volta para ativo
    if (inscricao.isConcluido) {
      await _service.atualizarStatusInscricao(
        inscricaoId,
        StatusInscricao.ativo,
      );
      inscricao = inscricao.copyWith(status: StatusInscricao.ativo);
    }

    // Atualiza modelo local
    inscricao = inscricao.copyWith(progresso: novoProgresso);

    // Atualiza cache
    _inscricoesCache[inscricaoId] = inscricao;

    return inscricao;
  }

  /// Atualiza último acesso (sem marcar como completo)
  Future<void> atualizarUltimoAcesso({
    required String cursoId,
    required String aulaId,
    required String topicoId,
    required String usuarioId,
  }) async {
    final inscricaoId = InscricaoCursoModel.gerarId(cursoId, usuarioId);
    final inscricao = await getInscricao(cursoId, usuarioId);

    if (inscricao == null) return;

    final novoProgresso = inscricao.progresso.atualizarUltimoAcesso(
      topicoId,
      aulaId,
    );

    await _service.atualizarProgresso(inscricaoId, novoProgresso);

    // Atualiza cache
    _inscricoesCache[inscricaoId] = inscricao.copyWith(progresso: novoProgresso);
  }

  // === Quiz ===

  /// Busca questões do quiz
  Future<List<QuizQuestionModel>> getQuizByTopico(
    String cursoId,
    String aulaId,
    String topicoId,
  ) async {
    return await _service.getQuizByTopico(cursoId, aulaId, topicoId);
  }

  // === Helpers ===

  /// Limpa todos os caches
  void limparCache() {
    _cursosCache.clear();
    _aulasCache.clear();
    _inscricoesCache.clear();
  }

  /// Limpa cache de um curso específico
  void limparCacheCurso(String cursoId) {
    _cursosCache.remove(cursoId);
    _aulasCache.remove(cursoId);
    // Remove inscrições relacionadas a este curso
    _inscricoesCache.removeWhere((key, _) => key.startsWith('${cursoId}_'));
  }

  /// Busca cursos com status de inscrição do usuário
  Future<List<({CursoModel curso, InscricaoCursoModel? inscricao})>> getCursosComInscricao(String usuarioId) async {
    final cursos = await getCursosDisponiveis();
    final resultado = <({CursoModel curso, InscricaoCursoModel? inscricao})>[];

    for (final curso in cursos) {
      final inscricao = await getInscricao(curso.id, usuarioId);
      resultado.add((curso: curso, inscricao: inscricao));
    }

    return resultado;
  }
}
