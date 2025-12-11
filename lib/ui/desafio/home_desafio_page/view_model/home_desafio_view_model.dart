import 'package:flutter/material.dart';

import 'package:medita_bk/core/enums/enums.dart';
import 'package:medita_bk/core/structs/index.dart';
import 'package:medita_bk/data/repositories/auth_repository.dart';
import 'package:medita_bk/data/repositories/desafio_repository.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart'; // For valueOrDefault

class HomeDesafioViewModel extends ChangeNotifier {
  final DesafioRepository _repository;
  final AuthRepository _authRepository;

  HomeDesafioViewModel({required DesafioRepository repository, required AuthRepository authRepository})
      : _repository = repository,
        _authRepository = authRepository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Accessing AppStateStore directly for now as it acts as a global store
  D21ModelStruct get desafio21 => AppStateStore().desafio21;
  bool get isD21Completed => desafio21.isD21Completed;
  int get etapaAtual => desafio21.etapaAtual;
  int get diasCompletados => desafio21.diasCompletados;
  List<D21EtapaModelStruct> get listaEtapasMandalas => AppStateStore().listaEtapasMandalas;

  // We need to check currentUserDocument for started status as per original code
  bool get isDesafioStarted =>
      valueOrDefault<bool>(_authRepository.currentUser?.desafio21Started, AppStateStore().desafioStarted);

  Future<void> startDesafio() async {
    _setLoading(true);
    try {
      final newDesafio = createD21ModelStruct(
        title: desafio21.title,
        description: desafio21.description,
        etapasCompletadas: 0,
        etapaAtual: 1,
        diasCompletados: 0,
        diaAtual: 1,
        dateStarted: getCurrentTimestamp,
        d21Status: D21Status.open,
        isD21Completed: false,
        fieldValues: {
          'd21_meditations': getD21MeditationModelListFirestoreData(
            desafio21.d21Meditations,
          ),
        },
        clearUnsetFields: false,
      );

      await _repository.updateDesafio21(newDesafio, desafio21Started: true);

      // Keep local stores in sync so the UI doesn't require a reload.
      AppStateStore().desafio21 = newDesafio;
      AppStateStore().desafioStarted = true;
      await _authRepository.refreshCurrentUser();

      notifyListeners();
    } catch (e) {
      _setError('Erro ao iniciar desafio: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
}
