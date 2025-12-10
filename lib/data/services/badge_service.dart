import 'package:flutter/foundation.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

import 'package:medita_b_k/data/repositories/notificacoes_repository.dart';
import 'auth/firebase_auth/auth_util.dart';

/// Service para gerenciar o badge do ícone do app
/// Singleton que atualiza o contador baseado nas notificações não lidas
class BadgeService {
  static final BadgeService _instance = BadgeService._internal();
  factory BadgeService() => _instance;
  BadgeService._internal();

  final NotificacoesRepository _repository = NotificacoesRepository();
  bool _isInitialized = false;
  bool _isSupported = false;

  /// Inicializa o serviço de badge
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Verifica suporte a badges
      _isSupported = await FlutterAppBadger.isAppBadgeSupported();
      
      if (_isSupported) {
        debugPrint('BadgeService: Badges suportados neste dispositivo');
        
        // Configura listener para atualizar badge automaticamente
        _setupBadgeListener();
      } else {
        debugPrint('BadgeService: Badges não suportados neste dispositivo');
      }

      _isInitialized = true;
    } catch (e) {
      debugPrint('BadgeService.initialize: Erro - $e');
    }
  }

  /// Configura listener para atualizar badge automaticamente
  void _setupBadgeListener() {
    // Escuta mudanças no contador de notificações
    _repository.streamContador().listen(
      (contador) {
        updateBadge(contador.totalNaoLidas);
      },
      onError: (error) {
        debugPrint('BadgeService: Erro no stream de contador - $error');
      },
    );
  }

  /// Atualiza o badge com o contador
  Future<void> updateBadge(int count) async {
    if (!_isSupported) return;

    try {
      if (count > 0) {
        await FlutterAppBadger.updateBadgeCount(count);
        debugPrint('BadgeService: Badge atualizado para $count');
      } else {
        await FlutterAppBadger.removeBadge();
        debugPrint('BadgeService: Badge removido');
      }
    } catch (e) {
      debugPrint('BadgeService.updateBadge: Erro - $e');
    }
  }

  /// Remove o badge
  Future<void> removeBadge() async {
    if (!_isSupported) return;

    try {
      await FlutterAppBadger.removeBadge();
      debugPrint('BadgeService: Badge removido');
    } catch (e) {
      debugPrint('BadgeService.removeBadge: Erro - $e');
    }
  }

  /// Atualiza badge baseado nas notificações não lidas de AMBAS as collections
  Future<void> updateFromNotifications() async {
    if (!_isSupported) return;

    final userId = currentUserUid;
    if (userId.isEmpty) {
      await removeBadge();
      return;
    }

    try {
      final totalNaoLidas = await _repository.contarNaoLidasUnificadas();
      await updateBadge(totalNaoLidas);
    } catch (e) {
      debugPrint('BadgeService.updateFromNotifications: Erro - $e');
    }
  }

  /// Reseta o badge (útil no logout)
  Future<void> reset() async {
    await removeBadge();
  }
}

