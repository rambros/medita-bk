import 'package:flutter/material.dart';

import 'package:medita_bk/core/state/app_state.dart';
import 'package:medita_bk/core/structs/index.dart';
import 'package:medita_bk/data/repositories/desafio_repository.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/data/repositories/auth_repository.dart';

class ListaEtapasViewModel extends ChangeNotifier {
  ListaEtapasViewModel({
    required AuthRepository authRepository,
    required DesafioRepository repository,
  })  : _authRepository = authRepository,
        _repository = repository;

  final AuthRepository _authRepository;
  final DesafioRepository _repository;

  // Access to global state
  final AppStateStore _appState = AppStateStore();

  // Getters for UI
  int get diasCompletados => _appState.desafio21.diasCompletados;

  List<D21EtapaModelStruct> get listaEtapasMandalas => _appState.listaEtapasMandalas;

  bool _isTester = false;
  bool get isTester => _isTester;

  // Methods
  Future<void> checkAndFixData() async {
    await _ensureUserRoles();

    bool needsUpdate = false;
    D21ModelStruct desafio21 = _appState.desafio21;
    List<D21EtapaModelStruct> mandalas = _appState.listaEtapasMandalas;

    // Check if data is missing
    if (desafio21.d21Meditations.isEmpty || mandalas.isEmpty) {
      try {
        final template = await _repository.getDesafio21Template();
        if (template != null) {
          if (desafio21.d21Meditations.isEmpty) {
            desafio21.d21Meditations = template.desafio21Data.d21Meditations;
            needsUpdate = true;
          }
          if (mandalas.isEmpty) {
            mandalas = template.listaEtapasMandalas;
            _appState.listaEtapasMandalas = mandalas;
            // No need to persist mandalas to user doc as they are global usually,
            // but if they are part of user record, we should.
            // Based on HomeViewModel, they are just in AppState.
          }

          if (needsUpdate) {
            _appState.desafio21 = desafio21;
            final userId = _authRepository.currentUserUid;
            if (userId.isNotEmpty) {
              await _repository.updateUserDesafio21(userId, desafio21);
            }
            notifyListeners();
          }
        }
      } catch (e) {
        debugPrint('Error fixing Desafio data: $e');
      }
    }
  }

  String? getURLMandala(int etapa) {
    // This logic was in custom_functions.getURLMandala
    // We can call the function or replicate logic if it's simple.
    // For now, let's assume the UI calls the function directly or we wrap it here.
    // But the UI uses `functions.getURLMandala`.
    // It's better if the ViewModel provides the data.
    return null;
  }

  Future<void> _ensureUserRoles() async {
    if (_authRepository.currentUser == null) {
      await _authRepository.refreshCurrentUser();
    }

    final roles = _authRepository.currentUser?.userRole ?? const [];
    final tester = roles.any((role) => role.toLowerCase() == 'tester');
    if (tester != _isTester) {
      _isTester = tester;
      notifyListeners();
    }
  }
}
