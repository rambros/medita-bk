import 'package:flutter/material.dart';

import 'package:medita_bk/data/repositories/ead_repository.dart';
import 'package:medita_bk/domain/models/ead/index.dart';

/// ViewModel para a pagina home do EAD
class EadHomeViewModel extends ChangeNotifier {
  final EadRepository _repository;

  EadHomeViewModel({EadRepository? repository})
      : _repository = repository ?? EadRepository();

  // === Estado ===

  List<CursoModel> _cursosDestaque = [];
  List<CursoModel> get cursosDestaque => _cursosDestaque;

  List<InscricaoCursoModel> _cursosEmAndamento = [];
  List<InscricaoCursoModel> get cursosEmAndamento => _cursosEmAndamento;

  List<InscricaoCursoModel> _cursosConcluidos = [];
  List<InscricaoCursoModel> get cursosConcluidos => _cursosConcluidos;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // === Getters computados ===

  /// Verifica se tem cursos em andamento
  bool get hasCursosEmAndamento => _cursosEmAndamento.isNotEmpty;

  /// Verifica se tem cursos concluidos
  bool get hasCursosConcluidos => _cursosConcluidos.isNotEmpty;

  /// Verifica se tem cursos de destaque
  bool get hasCursosDestaque => _cursosDestaque.isNotEmpty;

  /// Total de cursos em andamento
  int get totalEmAndamento => _cursosEmAndamento.length;

  /// Total de cursos concluidos
  int get totalConcluidos => _cursosConcluidos.length;

  /// Retorna o ultimo curso acessado (se houver)
  InscricaoCursoModel? get ultimoCursoAcessado {
    if (_cursosEmAndamento.isEmpty) return null;

    final lista = List<InscricaoCursoModel>.from(_cursosEmAndamento);
    lista.sort((a, b) {
      final acessoA = a.progresso.ultimoAcesso ?? a.dataInscricao;
      final acessoB = b.progresso.ultimoAcesso ?? b.dataInscricao;
      if (acessoA == null && acessoB == null) return 0;
      if (acessoA == null) return 1;
      if (acessoB == null) return -1;
      return acessoB.compareTo(acessoA);
    });

    return lista.first;
  }

  /// Retorna os 3 primeiros cursos de destaque
  List<CursoModel> get cursosDestaqueTop3 => _cursosDestaque.take(3).toList();

  /// Retorna os 3 primeiros cursos em andamento
  List<InscricaoCursoModel> get cursosEmAndamentoTop3 =>
      _cursosEmAndamento.take(3).toList();

  // === Acoes ===

  /// Carrega os dados da home
  Future<void> carregarDados({String? usuarioId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Carrega cursos disponiveis (para destaque)
      _cursosDestaque = await _repository.getCursosDisponiveis();

      // Se tiver usuario logado, carrega seus cursos
      if (usuarioId != null) {
        final inscricoes = await _repository.getMeusInscritos(usuarioId);

        // Separa em andamento e concluidos
        _cursosEmAndamento = inscricoes
            .where((i) => i.isAtivo && !i.progresso.isConcluido)
            .toList();

        _cursosConcluidos = inscricoes.where((i) => i.isConcluido).toList();

        // Ordena em andamento por ultimo acesso
        _cursosEmAndamento.sort((a, b) {
          final acessoA = a.progresso.ultimoAcesso ?? a.dataInscricao;
          final acessoB = b.progresso.ultimoAcesso ?? b.dataInscricao;
          if (acessoA == null && acessoB == null) return 0;
          if (acessoA == null) return 1;
          if (acessoB == null) return -1;
          return acessoB.compareTo(acessoA);
        });
      }

      _error = null;
    } catch (e) {
      _error = 'Erro ao carregar dados: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Recarrega os dados
  Future<void> refresh({String? usuarioId}) async {
    _repository.limparCache();
    await carregarDados(usuarioId: usuarioId);
  }
}
