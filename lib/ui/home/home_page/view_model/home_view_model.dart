import 'dart:async';

import 'package:flutter/material.dart';

import 'package:medita_bk/data/models/firebase/user_model.dart';
import 'package:medita_bk/data/models/firebase/desafio21_model.dart';
import 'package:medita_bk/data/models/firebase/settings_model.dart';
import 'package:medita_bk/data/repositories/auth_repository.dart';
import 'package:medita_bk/data/repositories/home_repository.dart';
import 'package:medita_bk/data/repositories/user_repository.dart';
import 'package:medita_bk/data/services/user_document_service.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/ui/core/actions/actions.dart' as action_blocks;
import 'package:medita_bk/core/structs/index.dart';

/// ViewModel for HomePage
/// Manages state and business logic for the home page
class HomeViewModel extends ChangeNotifier {
  final HomeRepository _repository;
  final AuthRepository _authRepository;

  HomeViewModel({required HomeRepository repository, required AuthRepository authRepository})
      : _repository = repository,
        _authRepository = authRepository;

  // State properties
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasInternet = false;
  bool get hasInternet => _hasInternet;

  UserModel? _userRecord;
  UserModel? get userRecord => _userRecord;

  Desafio21Model? _desafioRecord;
  Desafio21Model? get desafioRecord => _desafioRecord;

  SettingsModel? _settings;
  SettingsModel? get settings => _settings;

  bool _habilitaDesafio21 = false;
  bool get habilitaDesafio21 => _habilitaDesafio21;

  DateTime? _diaInicioDesafio21;
  DateTime? get diaInicioDesafio21 => _diaInicioDesafio21;

  List<D21EtapaModelStruct> _listaEtapasMandalas = [];
  List<D21EtapaModelStruct> get listaEtapasMandalas => _listaEtapasMandalas;

  D21ModelStruct? _desafio21Data;
  D21ModelStruct? get desafio21Data => _desafio21Data;

  /// Inicialização da home page
  ///
  /// Estratégia:
  /// - checkInternetAccess: ~5ms (sem DNS lookup)
  /// - loadUserData: getDocument() — sempre servido do cache offline do Firestore
  /// - loadSettings + initializeDesafio21: em paralelo após ter o userRecord
  Future<void> initialize(BuildContext context) async {
    if (_isLoading) return;

    debugPrint('🏠 HomeViewModel - Iniciando carregamento...');
    final startTime = DateTime.now();

    _isLoading = true;
    notifyListeners();

    try {
      await checkInternetAccess(context);
      debugPrint('   ✅ Internet: ${DateTime.now().difference(startTime).inMilliseconds}ms');

      await loadUserData();
      debugPrint('   ✅ User data: ${DateTime.now().difference(startTime).inMilliseconds}ms');

      await Future.wait([loadSettings(), initializeDesafio21()]);
      debugPrint('   ✅ Settings + Desafio21: ${DateTime.now().difference(startTime).inMilliseconds}ms');
    } catch (e) {
      debugPrint('   ❌ Error initializing HomePage: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
      debugPrint('   🏁 Total: ${DateTime.now().difference(startTime).inMilliseconds}ms');
    }
  }

  /// Check internet access using action block
  Future<void> checkInternetAccess(BuildContext context) async {
    await action_blocks.checkInternetAccess(context);
    _hasInternet = true;
  }

  /// Load user data
  /// Primário: getDocument() — sempre servido do cache offline do Firestore (instantâneo)
  /// Fallback: ensureUserDocument() — só para usuários novos sem documento
  Future<void> loadUserData() async {
    final userId = _authRepository.currentUserUid;
    if (userId.isEmpty) return;

    // Primário: getDocument() — sempre servido do cache offline do Firestore
    _userRecord = await _repository.getUserById(userId);

    // Fallback: só se documento não existe (usuário novo)
    if (_userRecord == null) {
      final userDocService = UserDocumentService(
        userRepository: UserRepository(),
        authRepository: _authRepository,
      );
      _userRecord = await userDocService.ensureUserDocument();
    }

    if (_userRecord != null) {
      // ignore: unawaited_futures
      _repository.updateLastAccess(userId);
    }
  }

  /// Initialize Desafio 21 data
  Future<void> initializeDesafio21() async {
    final userId = _authRepository.currentUserUid;
    if (userId.isEmpty || _userRecord == null) return;

    final desafioStarted = _userRecord?.desafio21Started ?? false;
    AppStateStore().desafioStarted = desafioStarted;

    if (desafioStarted != true) {
      // ignore: unawaited_futures
      _repository.updateDesafio21Started(userId, false);
    }

    _desafioRecord = await _repository.getDesafio21Template();

    if (_desafioRecord != null) {
      _listaEtapasMandalas = _desafioRecord!.listaEtapasMandalas.toList().cast<D21EtapaModelStruct>();
      AppStateStore().listaEtapasMandalas = _listaEtapasMandalas;

      if (valueOrDefault<bool>(_userRecord?.desafio21Started, false) == true) {
        _desafio21Data = _userRecord!.desafio21;

        if (_desafio21Data == null || _desafio21Data!.d21Meditations.isEmpty || _desafio21Data!.listaBrasoes.isEmpty) {
          final templateData = _desafioRecord!.desafio21Data;

          if (_desafio21Data == null) {
            _desafio21Data = templateData;
          } else {
            if (_desafio21Data!.d21Meditations.isEmpty) {
              _desafio21Data!.d21Meditations = templateData.d21Meditations;
            }
            if (_desafio21Data!.listaBrasoes.isEmpty) {
              debugPrint('🔥 HomeViewModel - listaBrasoes vazio, copiando do template: ${templateData.listaBrasoes.length} brasões');
              _desafio21Data!.listaBrasoes = templateData.listaBrasoes;
            }
          }

          // ignore: unawaited_futures
          _repository.updateUserDesafio21(userId, _desafio21Data!);
        }

        AppStateStore().desafio21 = _desafio21Data!;
      } else {
        final newDesafio21 = _desafioRecord!.desafio21Data;
        // ignore: unawaited_futures
        _repository.updateUserDesafio21(userId, newDesafio21);

        _desafio21Data = newDesafio21;
        AppStateStore().desafio21 = newDesafio21;
      }
    }
  }

  /// Load app settings
  Future<void> loadSettings() async {
    _settings = await _repository.getSettings();

    if (_settings != null) {
      _habilitaDesafio21 = _settings!.habilitaDesafio21;
      _diaInicioDesafio21 = _settings!.diaInicioDesafio21;

      AppStateStore().habilitaDesafio21 = _habilitaDesafio21;
      AppStateStore().diaInicioDesafio21 = _diaInicioDesafio21;
    }
  }
}
