import 'package:medita_b_k/data/services/comunicacao_service.dart';
import 'package:medita_b_k/domain/models/ead/index.dart';

/// Repository para o módulo de Comunicação (Tickets e Discussões)
/// Camada de abstração entre Service e ViewModels
/// Responsável por lógica de negócio e cache
/// Implementado como Singleton para compartilhar cache entre ViewModels
class ComunicacaoRepository {
  // Singleton instance
  static final ComunicacaoRepository _instance =
      ComunicacaoRepository._internal();

  factory ComunicacaoRepository() => _instance;

  ComunicacaoRepository._internal() : _service = ComunicacaoService();

  final ComunicacaoService _service;

  // === Cache local ===

  final Map<String, TicketModel> _ticketsCache = {};
  final Map<String, List<TicketMensagemModel>> _mensagensCache = {};

  // Cache de discussões
  final Map<String, DiscussaoModel> _discussoesCache = {};
  final Map<String, List<RespostaDiscussaoModel>> _respostasCache = {};

  // === Tickets ===

  /// Busca todos os tickets do usuário
  Future<List<TicketModel>> getTicketsByUsuario(
    String usuarioId, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _ticketsCache.isNotEmpty) {
      return _ticketsCache.values
          .where((t) => t.usuarioId == usuarioId)
          .toList()
        ..sort((a, b) => b.dataCriacao.compareTo(a.dataCriacao));
    }

    final tickets = await _service.getTicketsByUsuario(usuarioId);

    // Atualiza cache
    for (final ticket in tickets) {
      _ticketsCache[ticket.id] = ticket;
    }

    return tickets;
  }

  /// Busca tickets abertos do usuário
  Future<List<TicketModel>> getTicketsAbertos(
    String usuarioId, {
    bool forceRefresh = false,
  }) async {
    final tickets = await getTicketsByUsuario(usuarioId, forceRefresh: forceRefresh);
    return tickets.where((t) => t.isAberto).toList();
  }

  /// Busca tickets fechados do usuário
  Future<List<TicketModel>> getTicketsFechados(
    String usuarioId, {
    bool forceRefresh = false,
  }) async {
    final tickets = await getTicketsByUsuario(usuarioId, forceRefresh: forceRefresh);
    return tickets.where((t) => !t.isAberto).toList();
  }

  /// Busca um ticket pelo ID
  Future<TicketModel?> getTicketById(String ticketId) async {
    // Verifica cache primeiro
    if (_ticketsCache.containsKey(ticketId)) {
      return _ticketsCache[ticketId];
    }

    final ticket = await _service.getTicketById(ticketId);

    if (ticket != null) {
      _ticketsCache[ticket.id] = ticket;
    }

    return ticket;
  }

  /// Stream de um ticket específico
  Stream<TicketModel?> streamTicket(String ticketId) {
    return _service.streamTicket(ticketId).map((ticket) {
      if (ticket != null) {
        _ticketsCache[ticket.id] = ticket;
      }
      return ticket;
    });
  }

  /// Stream de tickets do usuário
  Stream<List<TicketModel>> streamTicketsByUsuario(String usuarioId) {
    return _service.streamTicketsByUsuario(usuarioId).map((tickets) {
      // Atualiza cache
      for (final ticket in tickets) {
        _ticketsCache[ticket.id] = ticket;
      }
      return tickets;
    });
  }

  /// Cria um novo ticket
  Future<String?> criarTicket({
    required String titulo,
    required String descricao,
    required CategoriaTicket categoria,
    required String usuarioId,
    required String usuarioNome,
    String? usuarioEmail,
    String? cursoId,
    String? cursoTitulo,
  }) async {
    final ticketId = await _service.criarTicket(
      titulo: titulo,
      descricao: descricao,
      categoria: categoria,
      usuarioId: usuarioId,
      usuarioNome: usuarioNome,
      usuarioEmail: usuarioEmail,
      cursoId: cursoId,
      cursoTitulo: cursoTitulo,
    );

    if (ticketId != null) {
      // Invalida cache para forçar reload
      _ticketsCache.clear();
    }

    return ticketId;
  }

  // === Mensagens ===

  /// Busca todas as mensagens de um ticket
  Future<List<TicketMensagemModel>> getMensagensByTicket(
    String ticketId, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _mensagensCache.containsKey(ticketId)) {
      return _mensagensCache[ticketId]!;
    }

    final mensagens = await _service.getMensagensByTicket(ticketId);
    _mensagensCache[ticketId] = mensagens;

    return mensagens;
  }

  /// Stream de mensagens de um ticket
  Stream<List<TicketMensagemModel>> streamMensagensByTicket(String ticketId) {
    return _service.streamMensagensByTicket(ticketId).map((mensagens) {
      _mensagensCache[ticketId] = mensagens;
      return mensagens;
    });
  }

  /// Adiciona uma mensagem ao ticket
  Future<bool> adicionarMensagem({
    required String ticketId,
    required String conteudo,
    required String autorId,
    required String autorNome,
    required TipoAutor autorTipo,
    List<Map<String, dynamic>>? anexos,
  }) async {
    final sucesso = await _service.adicionarMensagem(
      ticketId: ticketId,
      conteudo: conteudo,
      autorId: autorId,
      autorNome: autorNome,
      autorTipo: autorTipo,
      anexos: anexos,
    );

    if (sucesso) {
      // Invalida cache de mensagens deste ticket
      _mensagensCache.remove(ticketId);

      // Atualiza o ticket no cache se existir
      if (_ticketsCache.containsKey(ticketId)) {
        final ticket = _ticketsCache[ticketId]!;
        _ticketsCache[ticketId] = ticket.copyWith(
          totalMensagens: ticket.totalMensagens + 1,
          dataAtualizacao: DateTime.now(),
        );
      }
    }

    return sucesso;
  }

  /// Atualiza o status do ticket
  Future<bool> atualizarStatusTicket(
    String ticketId,
    StatusTicket novoStatus,
  ) async {
    final sucesso = await _service.atualizarStatusTicket(ticketId, novoStatus);

    if (sucesso) {
      // Atualiza o ticket no cache
      if (_ticketsCache.containsKey(ticketId)) {
        final ticket = _ticketsCache[ticketId]!;
        _ticketsCache[ticketId] = ticket.copyWith(
          status: novoStatus,
          dataAtualizacao: DateTime.now(),
          dataFechamento: (novoStatus == StatusTicket.fechado ||
                  novoStatus == StatusTicket.resolvido)
              ? DateTime.now()
              : null,
        );
      }
    }

    return sucesso;
  }

  /// Limpa o cache
  void clearCache() {
    _ticketsCache.clear();
    _mensagensCache.clear();
    _discussoesCache.clear();
    _respostasCache.clear();
  }

  /// Limpa o cache de um ticket específico
  void clearTicketCache(String ticketId) {
    _ticketsCache.remove(ticketId);
    _mensagensCache.remove(ticketId);
  }

  // ============================================================
  // === DISCUSSÕES (Q&A) ===
  // ============================================================

  /// Busca discussões de um curso
  Future<List<DiscussaoModel>> getDiscussoesByCurso(
    String cursoId, {
    String? usuarioId,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _discussoesCache.isNotEmpty) {
      final cached = _discussoesCache.values
          .where((d) => d.cursoId == cursoId)
          .where((d) => !d.isPrivada || d.autorId == usuarioId)
          .toList()
        ..sort((a, b) => b.dataCriacao.compareTo(a.dataCriacao));

      if (cached.isNotEmpty) return cached;
    }

    final discussoes = await _service.getDiscussoesByCurso(
      cursoId,
      usuarioId: usuarioId,
    );

    // Atualiza cache
    for (final discussao in discussoes) {
      _discussoesCache[discussao.id] = discussao;
    }

    return discussoes;
  }

  /// Busca minhas discussões
  Future<List<DiscussaoModel>> getMinhasDiscussoes(
    String usuarioId, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _discussoesCache.isNotEmpty) {
      final cached = _discussoesCache.values
          .where((d) => d.autorId == usuarioId)
          .toList()
        ..sort((a, b) => b.dataCriacao.compareTo(a.dataCriacao));

      if (cached.isNotEmpty) return cached;
    }

    final discussoes = await _service.getMinhasDiscussoes(usuarioId);

    // Atualiza cache
    for (final discussao in discussoes) {
      _discussoesCache[discussao.id] = discussao;
    }

    return discussoes;
  }

  /// Busca uma discussão pelo ID
  Future<DiscussaoModel?> getDiscussaoById(String discussaoId) async {
    // Verifica cache primeiro
    if (_discussoesCache.containsKey(discussaoId)) {
      return _discussoesCache[discussaoId];
    }

    final discussao = await _service.getDiscussaoById(discussaoId);

    if (discussao != null) {
      _discussoesCache[discussao.id] = discussao;
    }

    return discussao;
  }

  /// Stream de uma discussão específica
  Stream<DiscussaoModel?> streamDiscussao(String discussaoId) {
    return _service.streamDiscussao(discussaoId).map((discussao) {
      if (discussao != null) {
        _discussoesCache[discussao.id] = discussao;
      }
      return discussao;
    });
  }

  /// Stream de discussões de um curso
  Stream<List<DiscussaoModel>> streamDiscussoesByCurso(
    String cursoId, {
    String? usuarioId,
  }) {
    return _service.streamDiscussoesByCurso(cursoId, usuarioId: usuarioId).map((discussoes) {
      // Atualiza cache
      for (final discussao in discussoes) {
        _discussoesCache[discussao.id] = discussao;
      }
      return discussoes;
    });
  }

  /// Cria uma nova discussão
  Future<String?> criarDiscussao({
    required String cursoId,
    required String cursoTitulo,
    String? aulaId,
    String? aulaTitulo,
    String? topicoId,
    String? topicoTitulo,
    required String titulo,
    required String conteudo,
    required String autorId,
    required String autorNome,
    String? autorFoto,
    bool isPrivada = false,
    List<String>? tags,
  }) async {
    final discussaoId = await _service.criarDiscussao(
      cursoId: cursoId,
      cursoTitulo: cursoTitulo,
      aulaId: aulaId,
      aulaTitulo: aulaTitulo,
      topicoId: topicoId,
      topicoTitulo: topicoTitulo,
      titulo: titulo,
      conteudo: conteudo,
      autorId: autorId,
      autorNome: autorNome,
      autorFoto: autorFoto,
      isPrivada: isPrivada,
      tags: tags,
    );

    if (discussaoId != null) {
      // Invalida cache do curso para forçar reload
      _discussoesCache.removeWhere((_, d) => d.cursoId == cursoId);
    }

    return discussaoId;
  }

  // === Respostas ===

  /// Busca respostas de uma discussão
  Future<List<RespostaDiscussaoModel>> getRespostasByDiscussao(
    String discussaoId, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _respostasCache.containsKey(discussaoId)) {
      return _respostasCache[discussaoId]!;
    }

    final respostas = await _service.getRespostasByDiscussao(discussaoId);
    _respostasCache[discussaoId] = respostas;

    return respostas;
  }

  /// Stream de respostas de uma discussão
  Stream<List<RespostaDiscussaoModel>> streamRespostasByDiscussao(
    String discussaoId,
  ) {
    return _service.streamRespostasByDiscussao(discussaoId).map((respostas) {
      _respostasCache[discussaoId] = respostas;
      return respostas;
    });
  }

  /// Adiciona uma resposta à discussão
  Future<bool> adicionarResposta({
    required String discussaoId,
    required String conteudo,
    required String autorId,
    required String autorNome,
    String? autorFoto,
    required TipoAutor autorTipo,
  }) async {
    final sucesso = await _service.adicionarResposta(
      discussaoId: discussaoId,
      conteudo: conteudo,
      autorId: autorId,
      autorNome: autorNome,
      autorFoto: autorFoto,
      autorTipo: autorTipo,
    );

    if (sucesso) {
      // Invalida cache de respostas desta discussão
      _respostasCache.remove(discussaoId);

      // Atualiza a discussão no cache se existir
      if (_discussoesCache.containsKey(discussaoId)) {
        final discussao = _discussoesCache[discussaoId]!;
        _discussoesCache[discussaoId] = discussao.copyWith(
          totalRespostas: discussao.totalRespostas + 1,
          status: StatusDiscussao.respondida,
          dataAtualizacao: DateTime.now(),
        );
      }
    }

    return sucesso;
  }

  /// Curtir/descurtir uma resposta
  Future<bool> toggleLikeResposta({
    required String discussaoId,
    required String respostaId,
    required String usuarioId,
    String? usuarioNome,
  }) async {
    final sucesso = await _service.toggleLikeResposta(
      discussaoId: discussaoId,
      respostaId: respostaId,
      usuarioId: usuarioId,
      usuarioNome: usuarioNome,
    );

    if (sucesso) {
      // Invalida cache de respostas
      _respostasCache.remove(discussaoId);
    }

    return sucesso;
  }

  /// Marca uma resposta como solução
  Future<bool> marcarComoSolucao({
    required String discussaoId,
    required String respostaId,
    required bool isSolucao,
    String? usuarioId,
    String? usuarioNome,
  }) async {
    final sucesso = await _service.marcarComoSolucao(
      discussaoId: discussaoId,
      respostaId: respostaId,
      isSolucao: isSolucao,
      usuarioId: usuarioId,
      usuarioNome: usuarioNome,
    );

    if (sucesso) {
      // Invalida caches
      _respostasCache.remove(discussaoId);

      // Atualiza status da discussão no cache
      if (_discussoesCache.containsKey(discussaoId)) {
        final discussao = _discussoesCache[discussaoId]!;
        _discussoesCache[discussaoId] = discussao.copyWith(
          status: isSolucao ? StatusDiscussao.fechada : StatusDiscussao.respondida,
          dataAtualizacao: DateTime.now(),
        );
      }
    }

    return sucesso;
  }

  /// Limpa cache de uma discussão específica
  void clearDiscussaoCache(String discussaoId) {
    _discussoesCache.remove(discussaoId);
    _respostasCache.remove(discussaoId);
  }
}
