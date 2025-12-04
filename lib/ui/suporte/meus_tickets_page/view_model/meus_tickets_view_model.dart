import 'package:flutter/material.dart';

import 'package:medita_b_k/data/repositories/comunicacao_repository.dart';
import 'package:medita_b_k/domain/models/ead/index.dart';

/// Filtro de status para Meus Tickets
enum FiltroMeusTickets {
  todos,
  abertos,
  resolvidos;

  String get label {
    switch (this) {
      case FiltroMeusTickets.todos:
        return 'Todos';
      case FiltroMeusTickets.abertos:
        return 'Abertos';
      case FiltroMeusTickets.resolvidos:
        return 'Resolvidos';
    }
  }

  IconData get icon {
    switch (this) {
      case FiltroMeusTickets.todos:
        return Icons.list;
      case FiltroMeusTickets.abertos:
        return Icons.pending;
      case FiltroMeusTickets.resolvidos:
        return Icons.check_circle;
    }
  }
}

/// ViewModel para a página de Meus Tickets
class MeusTicketsViewModel extends ChangeNotifier {
  final ComunicacaoRepository _repository;

  MeusTicketsViewModel({ComunicacaoRepository? repository})
      : _repository = repository ?? ComunicacaoRepository();

  // === Estado ===

  List<TicketModel> _tickets = [];
  List<TicketModel> get tickets => _tickets;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  FiltroMeusTickets _filtroAtual = FiltroMeusTickets.todos;
  FiltroMeusTickets get filtroAtual => _filtroAtual;

  // === Getters computados ===

  /// Tickets filtrados pelo status selecionado
  List<TicketModel> get ticketsFiltrados {
    switch (_filtroAtual) {
      case FiltroMeusTickets.todos:
        return _tickets;
      case FiltroMeusTickets.abertos:
        return _tickets.where((t) => t.isAberto).toList();
      case FiltroMeusTickets.resolvidos:
        return _tickets.where((t) => !t.isAberto).toList();
    }
  }

  /// Total de tickets abertos
  int get totalAbertos => _tickets.where((t) => t.isAberto).length;

  /// Total de tickets resolvidos
  int get totalResolvidos => _tickets.where((t) => !t.isAberto).length;

  /// Verifica se tem algum ticket
  bool get hasTickets => _tickets.isNotEmpty;

  /// Verifica se a lista filtrada está vazia
  bool get listaVazia => ticketsFiltrados.isEmpty;

  /// Mensagem para lista vazia
  String get mensagemListaVazia {
    switch (_filtroAtual) {
      case FiltroMeusTickets.todos:
        return 'Você ainda não criou nenhum ticket de suporte';
      case FiltroMeusTickets.abertos:
        return 'Nenhum ticket aberto no momento';
      case FiltroMeusTickets.resolvidos:
        return 'Nenhum ticket resolvido ainda';
    }
  }

  /// Tickets ordenados por data de criação (mais recente primeiro)
  List<TicketModel> get ticketsRecentes {
    final lista = List<TicketModel>.from(ticketsFiltrados);
    lista.sort((a, b) => b.dataCriacao.compareTo(a.dataCriacao));
    return lista;
  }

  /// Tickets com alta prioridade e abertos
  List<TicketModel> get ticketsUrgentes {
    return _tickets
        .where((t) => 
            t.isAberto && 
            (t.prioridade == PrioridadeTicket.alta || 
             t.prioridade == PrioridadeTicket.urgente))
        .toList()
      ..sort((a, b) => b.prioridade.ordem.compareTo(a.prioridade.ordem));
  }

  /// Verifica se tem tickets urgentes
  bool get hasTicketsUrgentes => ticketsUrgentes.isNotEmpty;

  // === Ações ===

  /// Carrega os tickets do usuário
  Future<void> carregarMeusTickets(String usuarioId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tickets = await _repository.getTicketsByUsuario(usuarioId);
      _error = null;
    } catch (e) {
      _error = 'Erro ao carregar seus tickets: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Altera o filtro atual
  void setFiltro(FiltroMeusTickets filtro) {
    if (_filtroAtual != filtro) {
      _filtroAtual = filtro;
      notifyListeners();
    }
  }

  /// Recarrega os dados
  Future<void> refresh(String usuarioId) async {
    await carregarMeusTickets(usuarioId);
  }

  /// Limpa o cache e recarrega
  Future<void> forceRefresh(String usuarioId) async {
    _repository.clearCache();
    await carregarMeusTickets(usuarioId);
  }

  /// Retorna estatísticas resumidas dos tickets
  ({
    int total,
    int abertos,
    int resolvidos,
    int urgentes,
  }) getEstatisticas() {
    return (
      total: _tickets.length,
      abertos: totalAbertos,
      resolvidos: totalResolvidos,
      urgentes: ticketsUrgentes.length,
    );
  }

  /// Busca um ticket pelo ID
  Future<TicketModel?> getTicketById(String ticketId) async {
    try {
      return await _repository.getTicketById(ticketId);
    } catch (e) {
      debugPrint('Erro ao buscar ticket: $e');
      return null;
    }
  }

}
