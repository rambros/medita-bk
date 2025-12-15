import 'package:flutter/foundation.dart';

import 'package:medita_bk/data/repositories/ead_repository.dart';
import 'package:medita_bk/domain/models/ead/index.dart';

/// ViewModel para a página de catálogo de cursos
class CatalogoCursosViewModel extends ChangeNotifier {
  final EadRepository _repository;

  CatalogoCursosViewModel({EadRepository? repository})
      : _repository = repository ?? EadRepository();

  // === Estado ===

  List<CursoModel> _cursos = [];
  List<CursoModel> get cursos => _cursos;

  Map<String, InscricaoCursoModel> _inscricoes = {};
  Map<String, InscricaoCursoModel> get inscricoes => _inscricoes;

  /// Mapa de total de tópicos reais por curso
  final Map<String, int> _totalTopicosReais = {};

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // === Getters computados ===

  /// Cursos filtrados pela busca
  List<CursoModel> get cursosFiltrados {
    if (_searchQuery.isEmpty) return _cursos;
    
    final query = _searchQuery.toLowerCase();
    return _cursos.where((curso) {
      return curso.titulo.toLowerCase().contains(query) ||
          curso.descricaoCurta.toLowerCase().contains(query) ||
          curso.tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();
  }

  /// Verifica se um curso está inscrito (exclui cancelados)
  bool isInscrito(String cursoId) {
    final inscricao = _inscricoes[cursoId];
    return inscricao != null && (inscricao.isAtivo || inscricao.isConcluido);
  }

  /// Retorna a inscrição de um curso (se existir e não estiver cancelada)
  InscricaoCursoModel? getInscricao(String cursoId) {
    final inscricao = _inscricoes[cursoId];
    if (inscricao == null || inscricao.isCancelado) return null;
    return inscricao;
  }

  /// Retorna o progresso de um curso (0 se cancelado)
  double getProgresso(String cursoId) {
    final inscricao = _inscricoes[cursoId];
    if (inscricao == null || inscricao.isCancelado) return 0;
    // Usa o total real de tópicos se disponível
    final totalReal = _totalTopicosReais[cursoId];
    if (totalReal == null || totalReal == 0) {
      return inscricao.percentualConcluido;
    }
    return (inscricao.topicosCompletos / totalReal) * 100;
  }

  /// Retorna o total real de tópicos de um curso
  int getTotalTopicosReal(String cursoId) {
    return _totalTopicosReais[cursoId] ?? 0;
  }

  // === Ações ===

  /// Carrega os cursos disponíveis
  Future<void> carregarCursos({String? usuarioId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cursos = await _repository.getCursosDisponiveis();

      // Se tiver usuário logado, carrega inscrições
      if (usuarioId != null) {
        await _carregarInscricoes(usuarioId);
      }

      _error = null;
    } catch (e) {
      _error = 'Erro ao carregar cursos: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Carrega as inscrições do usuário
  Future<void> _carregarInscricoes(String usuarioId) async {
    try {
      final inscricoes = await _repository.getMeusInscritos(usuarioId);
      _inscricoes = {
        for (final inscricao in inscricoes) inscricao.cursoId: inscricao
      };

      // Carrega o total real de tópicos para cursos inscritos
      _totalTopicosReais.clear();
      for (final inscricao in inscricoes) {
        final aulas = await _repository.getAulasComTopicos(inscricao.cursoId);
        final totalReal = aulas.fold(0, (sum, aula) => sum + aula.topicos.length);
        _totalTopicosReais[inscricao.cursoId] = totalReal;
      }
    } catch (e) {
      debugPrint('Erro ao carregar inscrições: $e');
    }
  }

  /// Atualiza a query de busca
  void buscar(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Limpa a busca
  void limparBusca() {
    _searchQuery = '';
    notifyListeners();
  }

  /// Recarrega os dados
  Future<void> refresh({String? usuarioId}) async {
    _repository.limparCache();
    await carregarCursos(usuarioId: usuarioId);
  }
}
