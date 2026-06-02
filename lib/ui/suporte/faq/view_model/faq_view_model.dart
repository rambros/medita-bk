import 'package:flutter/foundation.dart';

import 'package:medita_bk/data/repositories/faq_repository.dart';
import 'package:medita_bk/domain/models/ead/faq_model.dart';

class FaqViewModel extends ChangeNotifier {
  final FaqRepository _repository;

  FaqViewModel({FaqRepository? repository})
      : _repository = repository ?? FaqRepository() {
    load();
  }

  List<FaqModel> _faqs = [];
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<FaqModel> get faqs => _faqs;

  List<String> get secoes {
    return _faqs.map((f) => f.secao).toSet().toList()..sort();
  }

  List<FaqModel> faqsPorSecao(String secao) =>
      _faqs.where((f) => f.secao == secao).toList();

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _faqs = await _repository.getFaqsAtivas();
    } catch (e) {
      _error = 'Não foi possível carregar as perguntas. Tente novamente.';
      if (kDebugMode) print('FaqViewModel error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void refresh() => load();
}
