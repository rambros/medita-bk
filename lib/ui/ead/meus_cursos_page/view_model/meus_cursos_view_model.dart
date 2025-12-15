import 'package:flutter/material.dart';

import 'package:medita_bk/data/repositories/ead_repository.dart';
import 'package:medita_bk/domain/models/ead/index.dart';

/// Filtro de status para Meus Cursos
enum FiltroMeusCursos {
  todos,
  emAndamento,
  concluidos,
  pausados;

  String get label {
    switch (this) {
      case FiltroMeusCursos.todos:
        return 'Todos';
      case FiltroMeusCursos.emAndamento:
        return 'Em andamento';
      case FiltroMeusCursos.concluidos:
        return 'Concluídos';
      case FiltroMeusCursos.pausados:
        return 'Pausados';
    }
  }

  IconData get icon {
    switch (this) {
      case FiltroMeusCursos.todos:
        return Icons.list;
      case FiltroMeusCursos.emAndamento:
        return Icons.play_circle_outline;
      case FiltroMeusCursos.concluidos:
        return Icons.check_circle_outline;
      case FiltroMeusCursos.pausados:
        return Icons.pause_circle_outline;
    }
  }
}

/// ViewModel para a página de Meus Cursos
class MeusCursosViewModel extends ChangeNotifier {
  final EadRepository _repository;

  MeusCursosViewModel({EadRepository? repository})
      : _repository = repository ?? EadRepository();

  // === Estado ===

  List<InscricaoCursoModel> _inscricoes = [];
  List<InscricaoCursoModel> get inscricoes => _inscricoes;

  /// Mapa de total de tópicos reais por curso (carregado das aulas)
  final Map<String, int> _totalTopicosReais = {};

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  FiltroMeusCursos _filtroAtual = FiltroMeusCursos.todos;
  FiltroMeusCursos get filtroAtual => _filtroAtual;

  // === Getters computados ===

  /// Inscrições ativas (exclui canceladas)
  List<InscricaoCursoModel> get _inscricoesAtivas =>
      _inscricoes.where((i) => !i.isCancelado).toList();

  /// Inscrições filtradas pelo status selecionado (sempre exclui canceladas)
  List<InscricaoCursoModel> get inscricoesFiltradas {
    switch (_filtroAtual) {
      case FiltroMeusCursos.todos:
        return _inscricoesAtivas;
      case FiltroMeusCursos.emAndamento:
        return _inscricoesAtivas.where((i) => i.isAtivo && !i.progresso.isConcluido).toList();
      case FiltroMeusCursos.concluidos:
        return _inscricoesAtivas.where((i) => i.isConcluido).toList();
      case FiltroMeusCursos.pausados:
        return _inscricoesAtivas.where((i) => i.isPausado).toList();
    }
  }

  /// Total de cursos em andamento (exclui cancelados)
  int get totalEmAndamento =>
      _inscricoesAtivas.where((i) => i.isAtivo && !i.progresso.isConcluido).length;

  /// Total de cursos concluídos (exclui cancelados)
  int get totalConcluidos => _inscricoesAtivas.where((i) => i.isConcluido).length;

  /// Total de cursos pausados (exclui cancelados)
  int get totalPausados => _inscricoesAtivas.where((i) => i.isPausado).length;

  /// Verifica se tem algum curso (exclui cancelados)
  bool get hasCursos => _inscricoesAtivas.isNotEmpty;

  /// Verifica se a lista filtrada está vazia
  bool get listaVazia => inscricoesFiltradas.isEmpty;

  /// Mensagem para lista vazia
  String get mensagemListaVazia {
    switch (_filtroAtual) {
      case FiltroMeusCursos.todos:
        return 'Você ainda não está inscrito em nenhum curso';
      case FiltroMeusCursos.emAndamento:
        return 'Nenhum curso em andamento';
      case FiltroMeusCursos.concluidos:
        return 'Nenhum curso concluído ainda';
      case FiltroMeusCursos.pausados:
        return 'Nenhum curso pausado';
    }
  }

  /// Retorna o total real de tópicos de um curso
  int getTotalTopicosReal(String cursoId) {
    return _totalTopicosReais[cursoId] ?? 0;
  }

  /// Calcula o progresso real de uma inscrição
  double calcularProgressoReal(InscricaoCursoModel inscricao) {
    final totalReal = _totalTopicosReais[inscricao.cursoId];
    if (totalReal == null || totalReal == 0) {
      // Fallback para o valor armazenado se não tiver o real
      return inscricao.percentualConcluido;
    }
    return (inscricao.topicosCompletos / totalReal) * 100;
  }

  /// Cursos ordenados por último acesso
  List<InscricaoCursoModel> get cursosRecentes {
    final lista = List<InscricaoCursoModel>.from(inscricoesFiltradas);
    lista.sort((a, b) {
      final acessoA = a.progresso.ultimoAcesso ?? a.dataInscricao;
      final acessoB = b.progresso.ultimoAcesso ?? b.dataInscricao;
      if (acessoA == null && acessoB == null) return 0;
      if (acessoA == null) return 1;
      if (acessoB == null) return -1;
      return acessoB.compareTo(acessoA);
    });
    return lista;
  }

  // === Ações ===

  /// Carrega os cursos do usuário
  Future<void> carregarMeusCursos(String usuarioId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _inscricoes = await _repository.getMeusInscritos(usuarioId);

      // Carrega o total real de tópicos para cada curso
      _totalTopicosReais.clear();
      for (final inscricao in _inscricoes) {
        final aulas = await _repository.getAulasComTopicos(inscricao.cursoId);
        final totalReal = aulas.fold(0, (sum, aula) => sum + aula.topicos.length);
        _totalTopicosReais[inscricao.cursoId] = totalReal;
      }

      _error = null;
    } catch (e) {
      _error = 'Erro ao carregar seus cursos: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Altera o filtro atual
  void setFiltro(FiltroMeusCursos filtro) {
    if (_filtroAtual != filtro) {
      _filtroAtual = filtro;
      notifyListeners();
    }
  }

  /// Recarrega os dados
  Future<void> refresh(String usuarioId) async {
    await carregarMeusCursos(usuarioId);
  }

  /// Reinicia o progresso de um curso
  Future<void> reiniciarCurso(String cursoId, String usuarioId) async {
    try {
      await _repository.reiniciarProgresso(
        cursoId: cursoId,
        usuarioId: usuarioId,
      );
      // Recarrega a lista para atualizar o estado
      await carregarMeusCursos(usuarioId);
    } catch (e) {
      _error = 'Erro ao reiniciar curso: $e';
      debugPrint(_error);
      notifyListeners();
    }
  }

  /// Retorna informações de progresso resumidas
  ({int completos, int total, double percentual}) getResumoProgresso() {
    if (_inscricoes.isEmpty) {
      return (completos: 0, total: 0, percentual: 0);
    }

    int totalTopicosCompletos = 0;
    int totalTopicos = 0;

    for (final inscricao in _inscricoes.where((i) => i.isAtivo || i.isConcluido)) {
      totalTopicosCompletos += inscricao.progresso.totalTopicosCompletos;
      // Usa o total real de tópicos se disponível
      final totalReal = _totalTopicosReais[inscricao.cursoId];
      totalTopicos += totalReal ?? inscricao.totalTopicos;
    }

    final percentual = totalTopicos > 0
        ? (totalTopicosCompletos / totalTopicos) * 100
        : 0.0;

    return (
      completos: totalTopicosCompletos,
      total: totalTopicos,
      percentual: percentual,
    );
  }
}
