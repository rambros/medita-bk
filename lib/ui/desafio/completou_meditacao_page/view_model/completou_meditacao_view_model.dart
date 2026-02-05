import 'package:flutter/material.dart';
import 'package:medita_bk/data/repositories/desafio_repository.dart';
import 'package:medita_bk/core/structs/index.dart';
import 'package:medita_bk/core/enums/enums.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/ui/core/flutter_flow/custom_functions.dart' as functions;

class CompletouMeditacaoViewModel extends ChangeNotifier {
  final DesafioRepository _repository;
  final int diaCompletado;

  CompletouMeditacaoViewModel({
    required DesafioRepository repository,
    required this.diaCompletado,
  }) : _repository = repository;

  bool _isLoading = false; // Iniciar como false para evitar tela em branco
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
  D21ModelStruct get desafio21 => AppStateStore().desafio21;

  String get meditationTitle {
    return desafio21.d21Meditations.elementAtOrNull(diaCompletado)?.titulo ?? '';
  }

  int get diaNumero => diaCompletado + 1;

  bool get isUltimoDia => diaCompletado >= 20;

  Future<void> processarConclusaoMeditacao() async {
    debugPrint('🎯 CompletouMeditacaoViewModel - Processando conclusão do dia $diaCompletado');
    debugPrint('   Total de meditações no AppState: ${desafio21.d21Meditations.length}');

    try {
      // Verificar se temos dados antes de processar
      if (desafio21.d21Meditations.isEmpty) {
        debugPrint('   ⚠️  AVISO: Lista de meditações vazia! Tentando carregar do Firestore...');
        _setLoading(true);
        await _carregarDadosSeNecessario();
        _setLoading(false);

        if (desafio21.d21Meditations.isEmpty) {
          throw Exception('Não foi possível carregar os dados do desafio');
        }
      }

      // Check if meditation was already completed
      _isMeditacaoJaFeita =
          desafio21.d21Meditations.elementAtOrNull(diaCompletado)?.meditationStatus == D21Status.completed;
      debugPrint('   Meditação já feita? $_isMeditacaoJaFeita');

      if (_isMeditacaoJaFeita) {
        // Just get the mandala URL
        _mandalaURL = functions.getURLMandala(
          ((diaCompletado) ~/ 3) + 1,
          diaCompletado + 1,
          AppStateStore().listaEtapasMandalas.toList(),
        );
        notifyListeners();
        return;
      }

      // Mark meditation as completed (atualiza estado local imediatamente)
      final now = getCurrentTimestamp;

      AppStateStore().updateDesafio21Struct(
        (e) => e
          ..updateD21Meditations(
            (e) => e[diaCompletado]
              ..dateCompleted = now
              ..meditationStatus = D21Status.completed,
          ),
      );

      if (isUltimoDia) {
        // Complete the entire challenge
        _completarDesafio();
      } else {
        // Open next meditation and update progress
        _avancarParaProximoDia();
      }

      // UI atualizada - notifica imediatamente
      notifyListeners();
      debugPrint('   ✅ UI atualizada! Persistindo no Firestore em background...');

      // Persist to Firestore em background (não-bloqueante)
      _persistirNoFirestoreAsync();
    } catch (e) {
      _setError('Erro ao processar conclusão: $e');
    }
  }

  /// Persiste dados no Firestore de forma assíncrona (não-bloqueante)
  Future<void> _persistirNoFirestoreAsync() async {
    try {
      var desafioToSave = AppStateStore().desafio21;

      // IMPORTANT: Ensure listaBrasoes is present before saving
      if (desafioToSave.listaBrasoes.isEmpty) {
        final template = await _repository.getDesafio21Template();
        if (template != null && template.desafio21Data.listaBrasoes.isNotEmpty) {
          desafioToSave.listaBrasoes = template.desafio21Data.listaBrasoes;
          AppStateStore().desafio21 = desafioToSave;
        }
      }

      await _repository.updateDesafio21(
        desafioToSave,
        desafio21Started: true,
      );

      debugPrint('   ✅ Dados persistidos no Firestore com sucesso!');
    } catch (e) {
      debugPrint('   ❌ Erro ao persistir no Firestore: $e');
      // Não propaga o erro - dados já estão no AppState local
    }
  }

  void _completarDesafio() {
    // Update challenge completion data
    AppStateStore().updateDesafio21Struct(
      (e) => e
        ..diasCompletados = 21
        ..diaAtual = 21
        ..etapasCompletadas = 7
        ..etapaAtual = 7
        ..dateCompleted = getCurrentTimestamp,
    );

    // Mark challenge as completed
    AppStateStore().updateDesafio21Struct(
      (e) => e
        ..dateCompleted = getCurrentTimestamp
        ..d21Status = D21Status.completed
        ..isD21Completed = true,
    );

    // Get final mandala URL
    _mandalaURL = functions.getURLMandala(
      7,
      21,
      AppStateStore().listaEtapasMandalas.toList(),
    );
  }

  void _avancarParaProximoDia() {
    // Open next meditation
    AppStateStore().updateDesafio21Struct(
      (e) => e
        ..updateD21Meditations(
          (e) => e[diaCompletado + 1]..meditationStatus = D21Status.open,
        ),
    );

    // Update days completed
    AppStateStore().updateDesafio21Struct(
      (e) => e
        ..incrementDiasCompletados(1)
        ..incrementDiaAtual(1),
    );

    // Get mandala URL
    _mandalaURL = functions.getURLMandala(
      AppStateStore().desafio21.etapaAtual,
      AppStateStore().desafio21.diasCompletados,
      AppStateStore().listaEtapasMandalas.toList(),
    );

    // Get next stage
    _proximaEtapa = desafio21.d21Meditations.elementAtOrNull(diaCompletado + 1)?.etapa;

    // Update stage data
    if (_proximaEtapa != null) {
      AppStateStore().updateDesafio21Struct(
        (e) => e
          ..etapasCompletadas = _proximaEtapa! - 1
          ..etapaAtual = _proximaEtapa,
      );
    }
  }

  /// Carrega dados do template se o AppStateStore estiver vazio
  Future<void> _carregarDadosSeNecessario() async {
    try {
      debugPrint('   📥 Carregando template do Firestore...');
      final template = await _repository.getDesafio21Template();

      if (template != null && template.desafio21Data.d21Meditations.isNotEmpty) {
        debugPrint('   ✅ Template carregado com ${template.desafio21Data.d21Meditations.length} meditações');
        AppStateStore().desafio21 = template.desafio21Data;
        AppStateStore().listaEtapasMandalas = template.listaEtapasMandalas.toList().cast<D21EtapaModelStruct>();
      } else {
        debugPrint('   ❌ Template vazio ou nulo');
      }
    } catch (e) {
      debugPrint('   ❌ Erro ao carregar template: $e');
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
