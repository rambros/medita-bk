import 'package:flutter/material.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/data/repositories/home_repository.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/actions/actions.dart' as action_blocks;

/// ViewModel for HomePage
/// Manages state and business logic for the home page
class HomeViewModel extends ChangeNotifier {
  final HomeRepository _repository;

  HomeViewModel(this._repository);

  // State properties
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasInternet = false;
  bool get hasInternet => _hasInternet;

  UsersRecord? _userRecord;
  UsersRecord? get userRecord => _userRecord;

  Desafio21Record? _desafioRecord;
  Desafio21Record? get desafioRecord => _desafioRecord;

  SettingsRecord? _settings;
  SettingsRecord? get settings => _settings;

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
  Future<void> initialize(BuildContext context) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Check internet access
      await checkInternetAccess(context);

      // Load user data
      await loadUserData();

      // Initialize Desafio 21
      await initializeDesafio21();

      // Load settings
      await loadSettings();
    } catch (e) {
      debugPrint('Error initializing HomePage: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Check internet access using action block
  Future<void> checkInternetAccess(BuildContext context) async {
    await action_blocks.checkInternetAccess(context);
    _hasInternet = true;
  }

  /// Load user data and update last access
  Future<void> loadUserData() async {
    if (currentUserReference == null) return;

    _userRecord = await _repository.getUserRecord(currentUserReference!);

    // Update last access timestamp
    await _repository.updateLastAccess(currentUserReference!);

    notifyListeners();
  }

  /// Initialize Desafio 21 data
  Future<void> initializeDesafio21() async {
    if (currentUserReference == null || currentUserDocument == null) return;

    // Get desafioStarted from user
    final desafioStarted = _userRecord?.desafio21Started ?? false;
    FFAppState().desafioStarted = desafioStarted;

    // Create field if it doesn't exist
    if (desafioStarted != true) {
      await _repository.updateDesafio21Started(currentUserReference!, false);
    }

    // Load Desafio 21 template
    _desafioRecord = await _repository.getDesafio21Template();

    if (_desafioRecord != null) {
      // Save mandalas to app state
      _listaEtapasMandalas = _desafioRecord!.listaEtapasMandalas.toList().cast<D21EtapaModelStruct>();
      FFAppState().listaEtapasMandalas = _listaEtapasMandalas;

      if (valueOrDefault<bool>(currentUserDocument?.desafio21Started, false) == true) {
        // Load user's existing desafio21 data
        _desafio21Data = currentUserDocument!.desafio21;
        FFAppState().desafio21 = _desafio21Data!;
      } else {
        // Create new desafio21 for user
        final newDesafio21 = _desafioRecord!.desafio21Data;
        await _repository.updateUserDesafio21(currentUserReference!, newDesafio21);

        _desafio21Data = newDesafio21;
        FFAppState().desafio21 = newDesafio21;
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
      FFAppState().habilitaDesafio21 = _habilitaDesafio21;
      FFAppState().diaInicioDesafio21 = _diaInicioDesafio21;
    }

    notifyListeners();
  }
}
