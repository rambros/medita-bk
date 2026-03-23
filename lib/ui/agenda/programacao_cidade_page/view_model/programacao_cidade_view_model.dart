import 'package:flutter/material.dart';
import 'package:medita_bk/core/structs/index.dart';
import 'package:medita_bk/data/repositories/agenda_repository.dart';

class Cidades {
  static const Map<int, String> lista = {
    258: '00 - Eventos ONLINE (Nacionais)',
    233: 'BA - Lauro de Freitas (Vilas do Atlântico)',
    229: 'BA - Salvador (Barris)',
    280: 'BA - Salvador (Pituba)',
    219: 'CE - Fortaleza',
    208: 'DF - Brasília',
    213: 'MG - Belo Horizonte',
    312: 'MG - Serra do Cipó',
    226: 'RS - Porto Alegre',
    230: 'RS - São Leopoldo',
    218: 'SC - Florianópolis',
    214: 'SP - Campinas',
    222: 'SP - Limeira',
    231: 'SP - São Paulo (Perdizes)',
    232: 'SP - Serra Negra',
  };
}

class ProgramacaoCidadeViewModel extends ChangeNotifier {
  final AgendaRepository _repository;

  ProgramacaoCidadeViewModel({
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

  int _selectedOrgId = 258; // Default
  int get selectedOrgId => _selectedOrgId;

  void setSelectedCity(int orgId) {
    if (_selectedOrgId != orgId) {
      _selectedOrgId = orgId;
      loadEvents();
    }
  }

  Future<void> loadEvents() async {
    _setLoading(true);
    _clearError();

    try {
      _events = await _repository.getEvents(orgId: _selectedOrgId);
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
