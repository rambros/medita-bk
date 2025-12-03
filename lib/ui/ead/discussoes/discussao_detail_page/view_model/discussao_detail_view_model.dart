import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../../data/repositories/comunicacao_repository.dart';
import '../../../../../domain/models/ead/index.dart';

/// ViewModel para a página de detalhes da discussão
class DiscussaoDetailViewModel extends ChangeNotifier {
  final ComunicacaoRepository _repository;
  final String discussaoId;

  DiscussaoDetailViewModel({
    required this.discussaoId,
    ComunicacaoRepository? repository,
  }) : _repository = repository ?? ComunicacaoRepository();

  // === Estado ===
  DiscussaoModel? _discussao;
  List<RespostaDiscussaoModel> _respostas = [];
  bool _isLoading = false;
  bool _isEnviando = false;
  String? _error;

  final TextEditingController respostaController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  StreamSubscription<DiscussaoModel?>? _discussaoSubscription;
  StreamSubscription<List<RespostaDiscussaoModel>>? _respostasSubscription;

  // === Getters ===
  DiscussaoModel? get discussao => _discussao;
  List<RespostaDiscussaoModel> get respostas => _respostas;
  bool get isLoading => _isLoading;
  bool get isEnviando => _isEnviando;
  String? get error => _error;

  bool get hasDiscussao => _discussao != null;
  bool get hasRespostas => _respostas.isNotEmpty;
  bool get podeResponder => _discussao?.podeResponder ?? false;

  /// Respostas ordenadas: solução primeiro, depois por likes e data
  List<RespostaDiscussaoModel> get respostasOrdenadas {
    final lista = _respostas.toList();
    lista.sort((a, b) {
      // Solução primeiro
      if (a.isSolucao && !b.isSolucao) return -1;
      if (!a.isSolucao && b.isSolucao) return 1;
      // Depois por likes
      if (a.likes != b.likes) return b.likes.compareTo(a.likes);
      // Por último por data
      return a.dataCriacao.compareTo(b.dataCriacao);
    });
    return lista;
  }

  /// Resposta marcada como solução
  RespostaDiscussaoModel? get respostaSolucao {
    try {
      return _respostas.firstWhere((r) => r.isSolucao);
    } catch (_) {
      return null;
    }
  }

  // === Ações ===

  /// Inicia os streams de dados
  void iniciarStreams() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Stream da discussão
    _discussaoSubscription = _repository.streamDiscussao(discussaoId).listen(
      (discussao) {
        _discussao = discussao;
        if (_discussao == null) {
          _error = 'Discussão não encontrada';
        } else {
          _error = null;
        }
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _error = 'Erro ao carregar discussão';
        _isLoading = false;
        debugPrint('Erro stream discussão: $e');
        notifyListeners();
      },
    );

    // Stream das respostas
    _respostasSubscription =
        _repository.streamRespostasByDiscussao(discussaoId).listen(
      (respostas) {
        final tinhaRespostas = _respostas.length;
        _respostas = respostas;

        // Scroll automático se recebeu nova resposta
        if (respostas.length > tinhaRespostas) {
          _scrollToBottom();
        }

        notifyListeners();
      },
      onError: (e) {
        debugPrint('Erro stream respostas: $e');
      },
    );
  }

  /// Envia uma nova resposta
  Future<bool> enviarResposta({
    required String usuarioId,
    required String usuarioNome,
    String? usuarioFoto,
  }) async {
    final conteudo = respostaController.text.trim();
    if (conteudo.isEmpty) return false;

    _isEnviando = true;
    notifyListeners();

    try {
      final sucesso = await _repository.adicionarResposta(
        discussaoId: discussaoId,
        conteudo: conteudo,
        autorId: usuarioId,
        autorNome: usuarioNome,
        autorFoto: usuarioFoto,
        autorTipo: TipoAutor.aluno,
      );

      if (sucesso) {
        respostaController.clear();
        _scrollToBottom();
      }

      return sucesso;
    } catch (e) {
      debugPrint('Erro ao enviar resposta: $e');
      return false;
    } finally {
      _isEnviando = false;
      notifyListeners();
    }
  }

  /// Curtir ou descurtir uma resposta
  Future<bool> toggleLike({
    required String respostaId,
    required String usuarioId,
  }) async {
    try {
      return await _repository.toggleLikeResposta(
        discussaoId: discussaoId,
        respostaId: respostaId,
        usuarioId: usuarioId,
      );
    } catch (e) {
      debugPrint('Erro ao curtir: $e');
      return false;
    }
  }

  /// Marca uma resposta como solução (apenas autor da discussão)
  Future<bool> marcarComoSolucao({
    required String respostaId,
    required bool isSolucao,
  }) async {
    try {
      return await _repository.marcarComoSolucao(
        discussaoId: discussaoId,
        respostaId: respostaId,
        isSolucao: isSolucao,
      );
    } catch (e) {
      debugPrint('Erro ao marcar como solução: $e');
      return false;
    }
  }

  /// Verifica se o usuário pode marcar como solução
  bool podeMarcarSolucao(String usuarioId) {
    return _discussao?.autorId == usuarioId;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Atualiza os dados
  Future<void> refresh() async {
    _discussao = await _repository.getDiscussaoById(discussaoId);
    _respostas = await _repository.getRespostasByDiscussao(discussaoId, forceRefresh: true);
    notifyListeners();
  }

  @override
  void dispose() {
    _discussaoSubscription?.cancel();
    _respostasSubscription?.cancel();
    respostaController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
