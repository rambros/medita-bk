import 'package:flutter/material.dart';
import 'package:medita_b_k/data/repositories/mensagem_repository.dart';
import 'package:medita_b_k/core/structs/index.dart';
import 'package:medita_b_k/core/utils/logger.dart';

class MensagensSemanticSearchViewModel extends ChangeNotifier {
  final MensagemRepository _repository;

  List<MensagemStruct> searchResults = [];
  bool isLoading = false;
  String? error;

  MensagensSemanticSearchViewModel(this._repository);

  Future<void> searchMensagens(String query) async {
    if (query.trim().isEmpty) {
      searchResults = [];
      notifyListeners();
      return;
    }

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final dynamicResult = await _repository.searchMensagens(query);
      final struct = SearchedMessagesStruct.maybeFromMap(dynamicResult);
      searchResults = struct?.result ?? [];
    } catch (e) {
      error = 'Erro ao buscar mensagens: $e';
      searchResults = [];
      logDebug(error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    searchResults = [];
    error = null;
    notifyListeners();
  }
}
