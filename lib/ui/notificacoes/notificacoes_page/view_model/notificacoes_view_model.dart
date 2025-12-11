import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

import 'package:medita_bk/data/repositories/notificacoes_repository.dart';
import 'package:medita_bk/domain/models/ead/notificacao_ead_model.dart';
import 'package:medita_bk/domain/models/unified_notification.dart';

/// ViewModel para a página de notificações UNIFICADAS
/// Gerencia notificações de AMBAS as collections (EAD + Meditações)
class NotificacoesViewModel extends ChangeNotifier {
  final NotificacoesRepository _repository;

  NotificacoesViewModel({
    NotificacoesRepository? repository,
  }) : _repository = repository ?? NotificacoesRepository() {
    _init();
  }

  // === State ===

  List<UnifiedNotification> _notificacoes = [];
  int _totalNaoLidas = 0;
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _errorMessage;
  
  StreamSubscription<List<UnifiedNotification>>? _notificacoesSubscription;

  // === Getters ===

  List<UnifiedNotification> get notificacoes => _notificacoes;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasNotificacoes => _notificacoes.isNotEmpty;
  int get totalNaoLidas => _totalNaoLidas;
  bool get temNaoLidas => _totalNaoLidas > 0;

  /// Notificações não lidas
  List<UnifiedNotification> get notificacoesNaoLidas =>
      _notificacoes.where((n) => !n.lido).toList();

  /// Notificações lidas
  List<UnifiedNotification> get notificacoesLidas =>
      _notificacoes.where((n) => n.lido).toList();

  /// Notificações EAD
  List<UnifiedNotification> get notificacoesEad =>
      _notificacoes.where((n) => n.source == NotificationSource.ead).toList();

  /// Notificações de Meditações
  List<UnifiedNotification> get notificacoesMeditacoes =>
      _notificacoes.where((n) => n.source == NotificationSource.legacy).toList();

  // === Initialization ===

  void _init() {
    _setupListeners();
    loadNotificacoes();
  }

  /// Configura listeners de streams para notificações UNIFICADAS
  void _setupListeners() {
    // Listen para notificações unificadas
    _notificacoesSubscription = _repository.streamNotificacoesUnificadas().listen(
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

  /// Carrega notificações UNIFICADAS
  Future<void> loadNotificacoes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notificacoes = await _repository.getNotificacoesUnificadas();
      _totalNaoLidas = await _repository.contarNaoLidasUnificadas();
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
      _notificacoes = await _repository.getNotificacoesUnificadas();
      _totalNaoLidas = await _repository.contarNaoLidasUnificadas();
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
  /// Funciona para ambos os tipos de notificações
  Future<bool> marcarComoLida(UnifiedNotification notificacao) async {
    // Para notificações EAD, marca no Firestore
    if (notificacao.source == NotificationSource.ead) {
      final success = await _repository.marcarComoLida(notificacao.id);

      if (success) {
        // Recarregar para atualizar
        await refresh();
      }

      return success;
    }

    // Para notificações antigas (legacy), marca localmente
    // Atualiza o estado local
    final index = _notificacoes.indexWhere((n) => n.id == notificacao.id);
    if (index != -1) {
      // Cria uma cópia atualizada
      final updated = UnifiedNotification(
        id: notificacao.id,
        titulo: notificacao.titulo,
        conteudo: notificacao.conteudo,
        dataCriacao: notificacao.dataCriacao,
        lido: true, // Marca como lida
        source: notificacao.source,
        tipo: notificacao.tipo,
        originalData: notificacao.originalData,
      );

      _notificacoes[index] = updated;
      _totalNaoLidas = _notificacoes.where((n) => !n.lido).length;
      _updateAppBadge(_totalNaoLidas);
      notifyListeners();

      return true;
    }

    return false;
  }

  /// Marca todas as notificações EAD como lidas
  /// Notificações antigas não são afetadas
  Future<bool> marcarTodasComoLidas() async {
    final success = await _repository.marcarTodasComoLidas();
    
    if (success) {
      _updateAppBadge(0);
      await refresh();
    }
    
    return success;
  }

  /// Remove uma notificação (ambos os tipos)
  Future<bool> removerNotificacao(UnifiedNotification notificacao) async {
    // Para notificações EAD, remove do Firestore
    if (notificacao.source == NotificationSource.ead) {
      final success = await _repository.removerNotificacao(notificacao.id);

      if (success) {
        _notificacoes.removeWhere((n) => n.id == notificacao.id);
        _totalNaoLidas = _notificacoes.where((n) => !n.lido).length;
        _updateAppBadge(_totalNaoLidas);
        notifyListeners();
      }

      return success;
    }

    // Para notificações antigas (legacy), remove localmente
    _notificacoes.removeWhere((n) => n.id == notificacao.id);
    _totalNaoLidas = _notificacoes.where((n) => !n.lido).length;
    _updateAppBadge(_totalNaoLidas);
    notifyListeners();

    return true;
  }

  /// Trata clique em notificação unificada
  /// Marca como lida e retorna dados de navegação
  Future<Map<String, dynamic>?> onNotificacaoTap(
    UnifiedNotification notificacao,
  ) async {
    // Marca como lida se não foi lida (ambos os tipos)
    if (!notificacao.lido) {
      await marcarComoLida(notificacao);
    }

    // Se for notificação EAD, retorna dados de navegação
    if (notificacao.source == NotificationSource.ead &&
        notificacao.originalData is NotificacaoEadModel) {
      final ead = notificacao.originalData as NotificacaoEadModel;

      if (ead.relatedType != null && ead.relatedId != null) {
        return {
          'type': ead.relatedType,
          'id': ead.relatedId,
          'dados': ead.dados,
        };
      }
    }

    // Notificações antigas não têm navegação específica
    return null;
  }

  // === Cleanup ===

  @override
  void dispose() {
    _notificacoesSubscription?.cancel();
    super.dispose();
  }
}

