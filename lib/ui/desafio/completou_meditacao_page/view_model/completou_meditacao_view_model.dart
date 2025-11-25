import 'package:flutter/material.dart';
import '/data/repositories/desafio_repository.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import '/ui/core/flutter_flow/custom_functions.dart' as functions;

class CompletouMeditacaoViewModel extends ChangeNotifier {
  final DesafioRepository _repository;
  final int diaCompletado;

  CompletouMeditacaoViewModel({
    required DesafioRepository repository,
    required this.diaCompletado,
  }) : _repository = repository;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _mandalaURL;
  String? get mandalaURL => _mandalaURL;

  bool _isMeditacaoJaFeita = false;
  bool get isMeditacaoJaFeita => _isMeditacaoJaFeita;

  int? _proximaEtapa;
  int? get proximaEtapa => _proximaEtapa;

  // Computed properties
  D21ModelStruct get desafio21 => FFAppState().desafio21;

  String get meditationTitle {
    return desafio21.d21Meditations.elementAtOrNull(diaCompletado)?.titulo ?? '';
  }

  int get diaNumero => diaCompletado + 1;

  bool get isUltimoDia => diaCompletado >= 20;

  Future<void> processarConclusaoMeditacao() async {
    _setLoading(true);
    try {
      // Check if meditation was already completed
      _isMeditacaoJaFeita =
          desafio21.d21Meditations.elementAtOrNull(diaCompletado)?.meditationStatus == D21Status.completed;

      if (_isMeditacaoJaFeita) {
        // Just get the mandala URL
        _mandalaURL = functions.getURLMandala(
          ((diaCompletado) ~/ 3) + 1,
          diaCompletado + 1,
          FFAppState().listaEtapasMandalas.toList(),
        );
        notifyListeners();
        _setLoading(false);
        return;
      }

      // Mark meditation as completed
      FFAppState().updateDesafio21Struct(
        (e) => e
          ..updateD21Meditations(
            (e) => e[diaCompletado]
              ..dateCompleted = getCurrentTimestamp
              ..meditationStatus = D21Status.completed,
          ),
      );

      if (isUltimoDia) {
        // Complete the entire challenge
        await _completarDesafio();
      } else {
        // Open next meditation and update progress
        await _avancarParaProximoDia();
      }

      // Persist to Firestore
      await _repository.updateDesafio21(
        FFAppState().desafio21,
        desafio21Started: true,
      );

      notifyListeners();
    } catch (e) {
      _setError('Erro ao processar conclusão: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _completarDesafio() async {
    // Update challenge completion data
    FFAppState().updateDesafio21Struct(
      (e) => e
        ..diasCompletados = 21
        ..diaAtual = 21
        ..etapasCompletadas = 7
        ..etapaAtual = 7
        ..dateCompleted = getCurrentTimestamp,
    );

    // Mark challenge as completed
    FFAppState().updateDesafio21Struct(
      (e) => e
        ..dateCompleted = getCurrentTimestamp
        ..d21Status = D21Status.completed
        ..isD21Completed = true,
    );

    // Get final mandala URL
    _mandalaURL = functions.getURLMandala(
      7,
      21,
      FFAppState().listaEtapasMandalas.toList(),
    );
  }

  Future<void> _avancarParaProximoDia() async {
    // Open next meditation
    FFAppState().updateDesafio21Struct(
      (e) => e
        ..updateD21Meditations(
          (e) => e[diaCompletado + 1]..meditationStatus = D21Status.open,
        ),
    );

    // Update days completed
    FFAppState().updateDesafio21Struct(
      (e) => e
        ..incrementDiasCompletados(1)
        ..incrementDiaAtual(1),
    );

    // Get mandala URL
    _mandalaURL = functions.getURLMandala(
      FFAppState().desafio21.etapaAtual,
      FFAppState().desafio21.diasCompletados,
      FFAppState().listaEtapasMandalas.toList(),
    );

    // Get next stage
    _proximaEtapa = desafio21.d21Meditations.elementAtOrNull(diaCompletado + 1)?.etapa;

    // Update stage data
    if (_proximaEtapa != null) {
      FFAppState().updateDesafio21Struct(
        (e) => e
          ..etapasCompletadas = _proximaEtapa! - 1
          ..etapaAtual = _proximaEtapa,
      );
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

  // Navigation helper
  bool shouldNavigateToMandala() {
    // Check if this is a mandala completion day (every 3rd day)
    return diaCompletado == 2 ||
        diaCompletado == 5 ||
        diaCompletado == 8 ||
        diaCompletado == 11 ||
        diaCompletado == 14 ||
        diaCompletado == 17 ||
        diaCompletado == 20;
  }
}
