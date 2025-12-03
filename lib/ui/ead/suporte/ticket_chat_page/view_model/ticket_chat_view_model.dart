import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../../data/repositories/comunicacao_repository.dart';
import '../../../../../domain/models/ead/index.dart';

/// ViewModel para a página de Chat do Ticket
class TicketChatViewModel extends ChangeNotifier {
  final ComunicacaoRepository _repository;
  final String ticketId;

  TicketChatViewModel({
    required this.ticketId,
    ComunicacaoRepository? repository,
  }) : _repository = repository ?? ComunicacaoRepository();

  // === Controllers ===

  final TextEditingController mensagemController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // === Estado ===

  TicketModel? _ticket;
  TicketModel? get ticket => _ticket;

  List<TicketMensagemModel> _mensagens = [];
  List<TicketMensagemModel> get mensagens => _mensagens;

  bool _isLoadingTicket = false;
  bool get isLoadingTicket => _isLoadingTicket;

  bool _isLoadingMensagens = false;
  bool get isLoadingMensagens => _isLoadingMensagens;

  bool _isEnviando = false;
  bool get isEnviando => _isEnviando;

  String? _error;
  String? get error => _error;

  StreamSubscription<TicketModel?>? _ticketSubscription;
  StreamSubscription<List<TicketMensagemModel>>? _mensagensSubscription;

  // === Getters computados ===

  bool get hasMensagens => _mensagens.isNotEmpty;

  bool get podeEnviarMensagem {
    return mensagemController.text.trim().isNotEmpty && !_isEnviando;
  }

  bool get ticketFechado => _ticket?.status.isFechado ?? false;

  String get tituloTicket {
    if (_ticket == null) return 'Carregando...';
    return 'Ticket #${_ticket!.numero}';
  }

  // === Ações ===

  /// Inicia os streams
  void iniciarStreams() {
    _carregarTicket();
    _carregarMensagens();
  }

  /// Carrega o ticket e inicia stream
  void _carregarTicket() {
    _isLoadingTicket = true;
    notifyListeners();

    _ticketSubscription?.cancel();
    _ticketSubscription = _repository.streamTicket(ticketId).listen(
      (ticket) {
        _ticket = ticket;
        _isLoadingTicket = false;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = 'Erro ao carregar ticket: $error';
        _isLoadingTicket = false;
        notifyListeners();
      },
    );
  }

  /// Carrega as mensagens e inicia stream
  void _carregarMensagens() {
    _isLoadingMensagens = true;
    notifyListeners();

    _mensagensSubscription?.cancel();
    _mensagensSubscription =
        _repository.streamMensagensByTicket(ticketId).listen(
      (mensagens) {
        final hadMensagens = _mensagens.isNotEmpty;
        _mensagens = mensagens;
        _isLoadingMensagens = false;
        _error = null;
        notifyListeners();

        // Auto-scroll para o final quando nova mensagem chegar
        if (mensagens.isNotEmpty && hadMensagens) {
          _scrollToBottom();
        }
      },
      onError: (error) {
        _error = 'Erro ao carregar mensagens: $error';
        _isLoadingMensagens = false;
        notifyListeners();
      },
    );
  }

  /// Envia uma mensagem
  Future<bool> enviarMensagem({
    required String usuarioId,
    required String usuarioNome,
  }) async {
    if (!podeEnviarMensagem) return false;

    final conteudo = mensagemController.text.trim();
    if (conteudo.isEmpty) return false;

    _isEnviando = true;
    notifyListeners();

    try {
      final sucesso = await _repository.adicionarMensagem(
        ticketId: ticketId,
        conteudo: conteudo,
        autorId: usuarioId,
        autorNome: usuarioNome,
        autorTipo: TipoAutor.aluno,
      );

      if (sucesso) {
        mensagemController.clear();
        _scrollToBottom();
      } else {
        _error = 'Erro ao enviar mensagem';
      }

      _isEnviando = false;
      notifyListeners();
      return sucesso;
    } catch (e) {
      _error = 'Erro ao enviar mensagem: $e';
      _isEnviando = false;
      notifyListeners();
      return false;
    }
  }

  /// Scroll para o final da lista
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

  /// Força scroll para o final (chamado pelo usuário)
  void scrollToBottom() {
    _scrollToBottom();
  }

  /// Recarrega os dados
  Future<void> refresh() async {
    _carregarTicket();
    _carregarMensagens();
  }

  @override
  void dispose() {
    _ticketSubscription?.cancel();
    _mensagensSubscription?.cancel();
    mensagemController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
