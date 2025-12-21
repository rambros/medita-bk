import 'dart:async';
import 'package:flutter/material.dart';

import 'package:medita_bk/data/repositories/comunicacao_repository.dart';
import 'package:medita_bk/domain/models/ead/index.dart';

/// Filtro para a lista de discussões
enum FiltroDiscussoes { minhas, todas, abertas, fechadas }

/// ViewModel para a página de discussões do curso
class DiscussoesCursoViewModel extends ChangeNotifier {
  final ComunicacaoRepository _repository;
  final String cursoId;
  final String cursoTitulo;

  DiscussoesCursoViewModel({
    required this.cursoId,
    required this.cursoTitulo,
    ComunicacaoRepository? repository,
  }) : _repository = repository ?? ComunicacaoRepository();

  // === Estado ===
  List<DiscussaoModel> _discussoes = [];
  bool _isLoading = false;
  String? _error;
  FiltroDiscussoes _filtroAtual = FiltroDiscussoes.minhas;
  String _termoBusca = '';
  StreamSubscription<List<DiscussaoModel>>? _subscription;

  // === Getters ===
  List<DiscussaoModel> get discussoes => _discussoes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  FiltroDiscussoes get filtroAtual => _filtroAtual;
  String get termoBusca => _termoBusca;

  /// Discussões filtradas e ordenadas
  List<DiscussaoModel> get discussoesFiltradas {
    var lista = _discussoes.toList();

    // Aplica filtro de texto
    if (_termoBusca.isNotEmpty) {
      final termo = _termoBusca.toLowerCase();
      lista = lista.where((d) {
        return d.titulo.toLowerCase().contains(termo) ||
            d.conteudo.toLowerCase().contains(termo) ||
            d.autorNome.toLowerCase().contains(termo);
      }).toList();
    }

    // Aplica filtro por status
    switch (_filtroAtual) {
      case FiltroDiscussoes.todas:
        break;
      case FiltroDiscussoes.minhas:
        // Este filtro será aplicado no carregamento
        break;
      case FiltroDiscussoes.fechadas:
        lista = lista.where((d) => d.status.isFechada).toList();
        break;
      case FiltroDiscussoes.abertas:
        lista = lista.where((d) => !d.status.isFechada).toList();
        break;
    }

    // Ordena: pinadas primeiro, depois por data
    lista.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      if (a.isDestaque && !b.isDestaque) return -1;
      if (!a.isDestaque && b.isDestaque) return 1;
      return b.dataCriacao.compareTo(a.dataCriacao);
    });

    return lista;
  }

  /// Estatísticas das discussões
  int get totalDiscussoes => _discussoes.length;
  int get totalAbertas => _discussoes.where((d) => d.status == StatusDiscussao.aberta).length;
  int get totalRespondidas => _discussoes.where((d) => d.status == StatusDiscussao.respondida).length;
  int get totalFechadas => _discussoes.where((d) => d.status == StatusDiscussao.fechada).length;

  bool get hasDiscussoes => _discussoes.isNotEmpty;

  String get mensagemListaVazia {
    if (_termoBusca.isNotEmpty) {
      return 'Nenhuma discussão encontrada para "$_termoBusca"';
    }
    switch (_filtroAtual) {
      case FiltroDiscussoes.minhas:
        return 'Você ainda não criou nenhuma discussão';
      case FiltroDiscussoes.fechadas:
        return 'Nenhuma discussão fechada';
      case FiltroDiscussoes.abertas:
        return 'Nenhuma discussão em aberto';
      case FiltroDiscussoes.todas:
        return 'Nenhuma discussão neste curso.\nSeja o primeiro a fazer uma pergunta!';
    }
  }

  // === Ações ===

  /// Inicia o stream de discussões
  void iniciarStream(String usuarioId) {
    _subscription?.cancel();
    _isLoading = true;
    _error = null;
    notifyListeners();

    _subscription = _repository
        .streamDiscussoesByCurso(cursoId, usuarioId: usuarioId)
        .listen(
      (discussoes) {
        _discussoes = discussoes;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = 'Erro ao carregar discussões';
        _isLoading = false;
        debugPrint('Erro stream discussões: $e');
        notifyListeners();
      },
    );
  }

  /// Carrega discussões (sem stream)
  Future<void> carregarDiscussoes(String usuarioId, {bool forceRefresh = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_filtroAtual == FiltroDiscussoes.minhas) {
        _discussoes = await _repository.getMinhasDiscussoes(usuarioId, forceRefresh: forceRefresh);
        // Filtra pelo curso atual
        _discussoes = _discussoes.where((d) => d.cursoId == cursoId).toList();
      } else {
        _discussoes = await _repository.getDiscussoesByCurso(
          cursoId,
          usuarioId: usuarioId,
          forceRefresh: forceRefresh,
        );
      }
      _error = null;
    } catch (e) {
      _error = 'Erro ao carregar discussões';
      debugPrint('Erro carregarDiscussoes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Define o filtro atual
  void setFiltro(FiltroDiscussoes filtro, String usuarioId) {
    if (_filtroAtual == filtro) return;

    _filtroAtual = filtro;
    carregarDiscussoes(usuarioId, forceRefresh: true);
  }

  /// Define o termo de busca
  void setBusca(String termo) {
    _termoBusca = termo;
    notifyListeners();
  }

  /// Limpa a busca
  void limparBusca() {
    _termoBusca = '';
    notifyListeners();
  }

  /// Atualiza a lista
  Future<void> refresh(String usuarioId) async {
    await carregarDiscussoes(usuarioId, forceRefresh: true);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
