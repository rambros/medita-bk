import 'package:flutter/material.dart';
import '/core/structs/index.dart';
import '/data/repositories/agenda_repository.dart';

class EventListViewModel extends ChangeNotifier {
  final AgendaRepository _repository;

  EventListViewModel({
    required AgendaRepository repository,
  }) : _repository = repository {
    loadEvents();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<EventModelStruct> _events = [];
  List<EventModelStruct> get events => _events;

  Future<void> loadEvents() async {
    _setLoading(true);
    _clearError();

    try {
      _events = await _repository.getEvents();
      notifyListeners();
    } catch (e) {
      _setError('Erro ao carregar atividades: $e');
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

  void _clearError() {
    _errorMessage = null;
  }
}
