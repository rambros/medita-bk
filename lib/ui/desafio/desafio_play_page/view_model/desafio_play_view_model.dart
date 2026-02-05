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

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Desafio21Model? _desafio21Record;
  bool _iniciadoDesafio = false;
  bool get iniciadoDesafio => _iniciadoDesafio;

  // Computed properties from AppStateStore
  D21ModelStruct get desafio21 => AppStateStore().desafio21;

  // Cache para evitar múltiplas buscas durante o build
  D21MeditationModelStruct? _cachedMeditation;
  int? _cachedForIndex;

  D21MeditationModelStruct? get currentMeditation {
    // Se já temos cache para este índice, retorna direto
    if (_cachedForIndex == meditationIndex && _cachedMeditation != null) {
      return _cachedMeditation;
    }

    final meditations = desafio21.d21Meditations;

    // Debug info (só uma vez por índice)
    debugPrint('🔍 DesafioPlayViewModel - Buscando meditação:');
    debugPrint('   Index solicitado: $meditationIndex');
    debugPrint('   Total de meditações: ${meditations.length}');

    if (meditationIndex < 0 || meditationIndex >= meditations.length) {
      debugPrint('   ❌ Índice fora do intervalo válido (0-${meditations.length - 1})');
      _cachedMeditation = null;
      _cachedForIndex = meditationIndex;
      return null;
    }

    final meditation = meditations.elementAtOrNull(meditationIndex);
    debugPrint('   ${meditation != null ? "✅" : "❌"} Meditação encontrada: ${meditation?.titulo ?? "null"}');

    // Atualiza cache
    _cachedMeditation = meditation;
    _cachedForIndex = meditationIndex;

    return meditation;
  }

  String get meditationTitle => currentMeditation?.titulo ?? '';
  String get audioUrl => currentMeditation?.audioUrl ?? '';

  String get imageUrl => currentMeditation?.imageUrl ?? '';

  Future<void> loadDesafioData() async {
    debugPrint('📥 DesafioPlayViewModel - Iniciando carregamento de dados...');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Check if data is already loaded in AppStateStore
      final currentDesafio = AppStateStore().desafio21;
      debugPrint('   AppStateStore atual tem ${currentDesafio.d21Meditations.length} meditações');

      // If meditation list is already populated, we're good to go
      if (currentDesafio.d21Meditations.isNotEmpty) {
        debugPrint('   ✅ Dados já carregados no AppStateStore');
        _iniciadoDesafio = _authRepository.currentUser?.desafio21 != null;
        _isLoading = false;
        notifyListeners();
        return;
      }

      debugPrint('   ⚠️  AppStateStore vazio, buscando do Firestore...');

      // If not, fetch from Firestore
      _desafio21Record = await _homeRepository.getDesafio21Template();

      if (_desafio21Record == null) {
        debugPrint('   ❌ Falha ao buscar template do Firestore');
        _errorMessage = 'Não foi possível carregar os dados do desafio.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      debugPrint('   ✅ Template recebido do Firestore com ${_desafio21Record!.desafio21Data.d21Meditations.length} meditações');
      AppStateStore().listaEtapasMandalas = _desafio21Record!.listaEtapasMandalas.toList().cast<D21EtapaModelStruct>();

      final userDesafio = _authRepository.currentUser?.desafio21;
      if (userDesafio == null || userDesafio.d21Meditations.isEmpty) {
        // User hasn't started or has no meditation data - use template
        debugPrint('   📋 Usando dados do template (usuário não iniciou ou sem dados)');
        AppStateStore().desafio21 = _desafio21Record!.desafio21Data;
        _iniciadoDesafio = false;
      } else {
        // Merge user progress with template structure
        debugPrint('   🔄 Mesclando dados do usuário com template');
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

      debugPrint('   ✅ Dados carregados com sucesso! Total de meditações: ${AppStateStore().desafio21.d21Meditations.length}');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('   ❌ Erro ao carregar dados: $e');
      _errorMessage = 'Erro ao carregar meditação: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }
}
