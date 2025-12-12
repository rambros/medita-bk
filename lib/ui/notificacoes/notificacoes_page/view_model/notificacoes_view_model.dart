import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

import 'package:medita_bk/data/repositories/notificacoes_repository.dart';
import 'package:medita_bk/domain/models/notificacao.dart';

/// ViewModel para a página de notificações
/// Sistema simplificado com collection única
class NotificacoesViewModel extends ChangeNotifier {
  final NotificacoesRepository _repository;

  NotificacoesViewModel({
    NotificacoesRepository? repository,
  }) : _repository = repository ?? NotificacoesRepository() {
    _init();
  }

  // === State ===

  List<Notificacao> _notificacoes = [];
  int _totalNaoLidas = 0;
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _errorMessage;

  StreamSubscription<List<Notificacao>>? _notificacoesSubscription;

  // === Getters ===

  List<Notificacao> get notificacoes => _notificacoes;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasNotificacoes => _notificacoes.isNotEmpty;
  int get totalNaoLidas => _totalNaoLidas;
  bool get temNaoLidas => _totalNaoLidas > 0;

  /// Notificações não lidas
  List<Notificacao> get notificacoesNaoLidas =>
      _notificacoes.where((n) => !n.lido).toList();

  /// Notificações lidas
  List<Notificacao> get notificacoesLidas =>
      _notificacoes.where((n) => n.lido).toList();

  /// Notificações de tickets
  List<Notificacao> get notificacoesTickets =>
      _notificacoes.where((n) => n.tipo.isTicket).toList();

  /// Notificações de discussões
  List<Notificacao> get notificacoesDiscussoes =>
      _notificacoes.where((n) => n.tipo.isDiscussao).toList();

  /// Notificações de cursos
  List<Notificacao> get notificacoesCursos =>
      _notificacoes.where((n) => n.tipo.isCurso).toList();

  // === Initialization ===

  void _init() {
    _setupListeners();
    loadNotificacoes();
  }

  /// Configura listeners de streams para notificações
  void _setupListeners() {
    // Listen para notificações
    _notificacoesSubscription = _repository.streamNotificacoes().listen(
      (notificacoes) {
        _notificacoes = notificacoes;
        _totalNaoLidas = notificacoes.where((n) => !n.lido).length;
        _isLoading = false;
        _errorMessage = null;
        _updateAppBadge(_totalNaoLidas);
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = 'Erro ao carregar notificações: $error';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Atualiza o badge do ícone do app
  Future<void> _updateAppBadge(int count) async {
    try {
      // Verifica se o dispositivo suporta badges
      final isSupported = await FlutterAppBadger.isAppBadgeSupported();

      if (isSupported) {
        if (count > 0) {
          await FlutterAppBadger.updateBadgeCount(count);
        } else {
          await FlutterAppBadger.removeBadge();
        }
      }
    } catch (e) {
      debugPrint('Erro ao atualizar badge: $e');
    }
  }

  // === Data Loading ===

  /// Carrega notificações
  Future<void> loadNotificacoes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notificacoes = await _repository.getNotificacoes();
      _totalNaoLidas = await _repository.contarNaoLidas();
      _updateAppBadge(_totalNaoLidas);
    } catch (e) {
      _errorMessage = 'Erro ao carregar notificações: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Recarrega notificações (pull to refresh)
  Future<void> refresh() async {
    _isRefreshing = true;
    notifyListeners();

    try {
      _notificacoes = await _repository.getNotificacoes();
      _totalNaoLidas = await _repository.contarNaoLidas();
      _updateAppBadge(_totalNaoLidas);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Erro ao recarregar notificações: $e';
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  // === Actions ===

  /// Marca uma notificação como lida
  Future<bool> marcarComoLida(Notificacao notificacao) async {
    final success = await _repository.marcarComoLida(notificacao.id);

    if (success) {
      // Stream já vai atualizar automaticamente
      _updateAppBadge(_totalNaoLidas - 1);
    }

    return success;
  }

  /// Marca todas as notificações como lidas
  Future<bool> marcarTodasComoLidas() async {
    final success = await _repository.marcarTodasComoLidas();

    if (success) {
      _updateAppBadge(0);
    }

    return success;
  }

  /// Remove uma notificação
  Future<bool> removerNotificacao(Notificacao notificacao) async {
    final success = await _repository.removerNotificacao(notificacao.id);

    if (success) {
      // Stream já vai atualizar automaticamente
      if (!notificacao.lido) {
        _updateAppBadge(_totalNaoLidas - 1);
      }
    }

    return success;
  }

  /// Trata clique em notificação
  /// Marca como lida e retorna dados de navegação
  Future<Map<String, dynamic>?> onNotificacaoTap(
    Notificacao notificacao,
  ) async {
    // Marca como lida se não foi lida
    if (!notificacao.lido) {
      await marcarComoLida(notificacao);
    }

    // Se tem dados de navegação, retorna
    if (notificacao.navegacao != null) {
      final nav = notificacao.navegacao!;
      return {
        'type': nav.tipo,
        'id': nav.id,
        if (nav.dados != null) 'dados': nav.dados,
      };
    }

    return null;
  }

  // === Cleanup ===

  @override
  void dispose() {
    _notificacoesSubscription?.cancel();
    super.dispose();
  }
}
