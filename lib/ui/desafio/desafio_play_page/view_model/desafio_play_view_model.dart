import 'package:flutter/material.dart';

import 'package:medita_bk/core/state/app_state.dart';
import 'package:medita_bk/data/models/firebase/desafio21_model.dart';
import 'package:medita_bk/data/repositories/home_repository.dart';
import 'package:medita_bk/data/repositories/auth_repository.dart';
import 'package:medita_bk/core/structs/index.dart';

class DesafioPlayViewModel extends ChangeNotifier {
  final int meditationIndex;
  final AuthRepository _authRepository;
  final HomeRepository _homeRepository;

  DesafioPlayViewModel({
    required this.meditationIndex,
    required AuthRepository authRepository,
    required HomeRepository homeRepository,
  })  : _authRepository = authRepository,
        _homeRepository = homeRepository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Desafio21Model? _desafio21Record;
  bool _iniciadoDesafio = false;
  bool get iniciadoDesafio => _iniciadoDesafio;

  // Computed properties from AppStateStore
  D21ModelStruct get desafio21 => AppStateStore().desafio21;

  D21MeditationModelStruct? get currentMeditation {
    if (meditationIndex < 0 || meditationIndex >= desafio21.d21Meditations.length) {
      return null;
    }

    return desafio21.d21Meditations.elementAtOrNull(meditationIndex);
  }

  String get meditationTitle => currentMeditation?.titulo ?? '';
  String get audioUrl => currentMeditation?.audioUrl ?? '';

  String get imageUrl => currentMeditation?.imageUrl ?? '';

  Future<void> loadDesafioData() async {
    try {
      _desafio21Record = await _homeRepository.getDesafio21Template();

      if (_desafio21Record == null) {
        return;
      }

      AppStateStore().listaEtapasMandalas = _desafio21Record!.listaEtapasMandalas.toList().cast<D21EtapaModelStruct>();

      final userDesafio = _authRepository.currentUser?.desafio21;
      if (userDesafio == null) {
        AppStateStore().desafio21 = _desafio21Record!.desafio21Data;
        _iniciadoDesafio = false;
      } else {
        final mergedDesafio = _desafio21Record!.desafio21Data;

        mergedDesafio.d21Meditations = userDesafio.d21Meditations;
        mergedDesafio.etapasCompletadas = userDesafio.etapasCompletadas;
        mergedDesafio.etapaAtual = userDesafio.etapaAtual;
        mergedDesafio.diasCompletados = userDesafio.diasCompletados;
        mergedDesafio.diaAtual = userDesafio.diaAtual;
        mergedDesafio.dateStarted = userDesafio.dateStarted;
        mergedDesafio.dateCompleted = userDesafio.dateCompleted;
        mergedDesafio.d21Status = userDesafio.d21Status;
        mergedDesafio.isD21Completed = userDesafio.isD21Completed;

        AppStateStore().desafio21 = mergedDesafio;
        _iniciadoDesafio = true;
      }

      notifyListeners();
    } catch (e) {
      // Silent fail - data already available from AppStateStore
    }
  }
}
