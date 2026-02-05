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

  /// Main initialization method
  /// Called when page loads
  /// OTIMIZADO: Carrega dados em paralelo quando possível
  Future<void> initialize(BuildContext context) async {
    if (_isLoading) return;

    debugPrint('🏠 HomeViewModel - Iniciando carregamento...');
    final startTime = DateTime.now();

    _isLoading = true;
    notifyListeners();

    try {
      // 1. Check internet access (rápido, mas necessário primeiro)
      await checkInternetAccess(context);
      debugPrint('   ✅ Internet check: ${DateTime.now().difference(startTime).inMilliseconds}ms');

      // 2. Load user data (necessário para o resto)
      await loadUserData();
      debugPrint('   ✅ User data loaded: ${DateTime.now().difference(startTime).inMilliseconds}ms');

      // 3. PARALELIZAR: Settings e Desafio21 podem carregar ao mesmo tempo
      final settingsFuture = loadSettings();
      final desafio21Future = initializeDesafio21();

      await Future.wait([settingsFuture, desafio21Future]);
      debugPrint('   ✅ Settings & Desafio21 loaded: ${DateTime.now().difference(startTime).inMilliseconds}ms');
    } catch (e) {
      debugPrint('   ❌ Error initializing HomePage: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
      debugPrint('   🏁 Total loading time: ${DateTime.now().difference(startTime).inMilliseconds}ms');
    }
  }

  /// Check internet access using action block
  Future<void> checkInternetAccess(BuildContext context) async {
    await action_blocks.checkInternetAccess(context);
    _hasInternet = true;
  }

  /// Load user data and update last access
  /// Garante que o documento do usuário existe no Firestore antes de prosseguir
  Future<void> loadUserData() async {
    final userId = _authRepository.currentUserUid;
    if (userId.isEmpty) return;

    // PREVENTIVO: Garante que o documento do usuário existe no Firestore
    // Se não existir, cria automaticamente com dados do Firebase Auth
    final userDocService = UserDocumentService(
      userRepository: UserRepository(),
      authRepository: _authRepository,
    );

    try {
      _userRecord = await userDocService.ensureUserDocument();
    } catch (e) {
      debugPrint('❌ Erro ao garantir documento do usuário: $e');
      // Fallback: tenta buscar diretamente
      _userRecord = await _repository.getUserById(userId);
    }

    if (_userRecord != null) {
      // Update last access timestamp (não-bloqueante - não precisa esperar)
      // ignore: unawaited_futures
      _repository.updateLastAccess(userId);
    }

    notifyListeners();
  }

  /// Initialize Desafio 21 data
  /// OTIMIZADO: Escritas não-críticas são não-bloqueantes
  Future<void> initializeDesafio21() async {
    final userId = _authRepository.currentUserUid;
    if (userId.isEmpty || _userRecord == null) return;

    // Get desafioStarted from user
    final desafioStarted = _userRecord?.desafio21Started ?? false;
    AppStateStore().desafioStarted = desafioStarted;

    // Create field if it doesn't exist (não-bloqueante - apenas garante consistência)
    if (desafioStarted != true) {
      // ignore: unawaited_futures
      _repository.updateDesafio21Started(userId, false);
    }

    // Load Desafio 21 template
    _desafioRecord = await _repository.getDesafio21Template();

    if (_desafioRecord != null) {
      // Save mandalas to app state
      _listaEtapasMandalas = _desafioRecord!.listaEtapasMandalas.toList().cast<D21EtapaModelStruct>();
      AppStateStore().listaEtapasMandalas = _listaEtapasMandalas;

      if (valueOrDefault<bool>(_userRecord?.desafio21Started, false) == true) {
        // Load user's existing desafio21 data
        _desafio21Data = _userRecord!.desafio21;

        // Fix for missing meditations, listaBrasoes, or null data (corrupted state)
        if (_desafio21Data == null || _desafio21Data!.d21Meditations.isEmpty || _desafio21Data!.listaBrasoes.isEmpty) {
          // Use template data to restore/fix
          final templateData = _desafioRecord!.desafio21Data;

          if (_desafio21Data == null) {
            _desafio21Data = templateData;
          } else {
            // Update missing fields, keeping other progress if possible
            if (_desafio21Data!.d21Meditations.isEmpty) {
              _desafio21Data!.d21Meditations = templateData.d21Meditations;
            }
            if (_desafio21Data!.listaBrasoes.isEmpty) {
              debugPrint('🔥 HomeViewModel - listaBrasoes vazio, copiando do template: ${templateData.listaBrasoes.length} brasões');
              _desafio21Data!.listaBrasoes = templateData.listaBrasoes;
            }
          }

          // Persist the fix to Firestore (não-bloqueante - correção de dados)
          // ignore: unawaited_futures
          _repository.updateUserDesafio21(userId, _desafio21Data!);
        }

        AppStateStore().desafio21 = _desafio21Data!;
      } else {
        // Create new desafio21 for user (não-bloqueante - apenas inicialização)
        final newDesafio21 = _desafioRecord!.desafio21Data;
        // ignore: unawaited_futures
        _repository.updateUserDesafio21(userId, newDesafio21);

        _desafio21Data = newDesafio21;
        AppStateStore().desafio21 = newDesafio21;
      }
    }

    notifyListeners();
  }

  /// Load app settings
  Future<void> loadSettings() async {
    _settings = await _repository.getSettings();

    if (_settings != null) {
      _habilitaDesafio21 = _settings!.habilitaDesafio21;
      _diaInicioDesafio21 = _settings!.diaInicioDesafio21;

      // Update app state
      AppStateStore().habilitaDesafio21 = _habilitaDesafio21;
      AppStateStore().diaInicioDesafio21 = _diaInicioDesafio21;
    }

    notifyListeners();
  }
}
