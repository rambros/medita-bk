import 'package:flutter/material.dart';

import '/app_state.dart';
import '/backend/backend.dart';
import '/data/repositories/auth_repository.dart';

class DesafioPlayViewModel extends ChangeNotifier {
  final int meditationIndex;
  final AuthRepository _authRepository;

  DesafioPlayViewModel({
    required this.meditationIndex,
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Desafio21Record? _desafio21Record;
  bool _iniciadoDesafio = false;
  bool get iniciadoDesafio => _iniciadoDesafio;

  // Computed properties from FFAppState
  D21ModelStruct get desafio21 => FFAppState().desafio21;

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
    _setLoading(true);
    try {
      // Fetch desafio template
      final records = await queryDesafio21RecordOnce(singleRecord: true);
      _desafio21Record = records.firstOrNull;

      if (_desafio21Record == null) {
        _setError('Desafio template not found');
        return;
      }

      // Update lista mandalas in FFAppState
      FFAppState().listaEtapasMandalas = _desafio21Record!.listaEtapasMandalas.toList().cast<D21EtapaModelStruct>();

      // Check if user has started the challenge
      final userDesafio = _authRepository.currentUser?.desafio21;
      if (userDesafio == null) {
        // Not started - use template data
        FFAppState().desafio21 = _desafio21Record!.desafio21Data;
        _iniciadoDesafio = false;
      } else {
        // Started - use user data
        FFAppState().desafio21 = userDesafio;
        _iniciadoDesafio = true;
      }

      notifyListeners();
    } catch (e) {
      _setError('Erro ao carregar dados do desafio: $e');
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
