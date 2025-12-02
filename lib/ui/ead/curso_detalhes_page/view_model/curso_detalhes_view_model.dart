import 'package:flutter/material.dart';

import '../../../../data/repositories/ead_repository.dart';
import '../../../../domain/models/ead/index.dart';

/// ViewModel para a página de detalhes do curso
class CursoDetalhesViewModel extends ChangeNotifier {
  final EadRepository _repository;
  final String cursoId;

  CursoDetalhesViewModel({
    required this.cursoId,
    EadRepository? repository,
  }) : _repository = repository ?? EadRepository();

  // === Estado ===

  CursoModel? _curso;
  CursoModel? get curso => _curso;

  List<AulaModel> _aulas = [];
  List<AulaModel> get aulas => _aulas;

  InscricaoCursoModel? _inscricao;
  InscricaoCursoModel? get inscricao => _inscricao;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isInscrevendo = false;
  bool get isInscrevendo => _isInscrevendo;

  String? _error;
  String? get error => _error;

  // Controla qual aula está expandida
  Set<String> _aulasExpandidas = {};
  Set<String> get aulasExpandidas => _aulasExpandidas;

  // === Getters computados ===

  /// Verifica se o usuário está inscrito
  bool get isInscrito => _inscricao != null && _inscricao!.isAtivo;

  /// Verifica se o curso foi concluído
  bool get isConcluido => _inscricao?.isConcluido ?? false;

  /// Progresso do curso
  double get progresso => _inscricao?.percentualConcluido ?? 0;

  /// Total de tópicos do curso
  int get totalTopicos {
    return _aulas.fold(0, (sum, aula) => sum + aula.numeroTopicos);
  }

  /// Tópicos completados
  int get topicosCompletos => _inscricao?.progresso.totalTopicosCompletos ?? 0;

  /// Verifica se um tópico está completo
  bool isTopicoCompleto(String topicoId) {
    return _inscricao?.progresso.isTopicoCompleto(topicoId) ?? false;
  }

  /// Verifica se uma aula está completa
  bool isAulaCompleta(String aulaId) {
    return _inscricao?.progresso.isAulaCompleta(aulaId) ?? false;
  }

  /// Texto do botão de ação principal
  String get textoBotaoAcao {
    if (_inscricao == null) {
      return 'Inscrever-se';
    }
    if (_inscricao!.isConcluido) {
      return 'Concluído';
    }
    if (!_inscricao!.progresso.hasProgresso) {
      return 'Iniciar Curso';
    }
    return 'Continuar Curso';
  }

  /// Ícone do botão de ação principal
  IconData get iconeBotaoAcao {
    if (_inscricao == null) {
      return Icons.add;
    }
    if (!_inscricao!.progresso.hasProgresso) {
      return Icons.play_arrow;
    }
    if (_inscricao!.isConcluido) {
      return Icons.check;
    }
    return Icons.play_arrow;
  }

  /// Retorna o próximo tópico a ser assistido
  ({String aulaId, String topicoId})? get proximoTopico {
    if (_inscricao == null) return null;

    // Se tem último acesso, retorna ele
    final ultimoTopico = _inscricao!.progresso.ultimoTopicoId;
    final ultimaAula = _inscricao!.progresso.ultimaAulaId;
    if (ultimoTopico != null && ultimaAula != null) {
      return (aulaId: ultimaAula, topicoId: ultimoTopico);
    }

    // Senão, encontra o primeiro tópico não completo
    for (final aula in _aulas) {
      for (final topico in aula.topicos) {
        if (!isTopicoCompleto(topico.id)) {
          return (aulaId: aula.id, topicoId: topico.id);
        }
      }
    }

    // Se todos completos, retorna o primeiro
    if (_aulas.isNotEmpty && _aulas.first.topicos.isNotEmpty) {
      return (aulaId: _aulas.first.id, topicoId: _aulas.first.topicos.first.id);
    }

    return null;
  }

  // === Ações ===

  /// Carrega os dados do curso
  Future<void> carregarDados({String? usuarioId, bool forceRefresh = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Carrega curso
      _curso = await _repository.getCursoById(cursoId);
      if (_curso == null) {
        throw Exception('Curso não encontrado');
      }

      // Carrega aulas com tópicos
      _aulas = await _repository.getAulasComTopicos(cursoId);

      // Se tiver usuário, carrega inscrição
      if (usuarioId != null) {
        _inscricao = await _repository.getInscricao(
          cursoId,
          usuarioId,
          forceRefresh: forceRefresh,
        );
      }

      _error = null;
    } catch (e) {
      _error = 'Erro ao carregar curso: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Inscreve o usuário no curso
  Future<bool> inscrever({
    required String usuarioId,
    required String usuarioNome,
    required String usuarioEmail,
    String? usuarioFoto,
  }) async {
    if (_curso == null) return false;

    _isInscrevendo = true;
    notifyListeners();

    try {
      _inscricao = await _repository.inscreverNoCurso(
        curso: _curso!,
        usuarioId: usuarioId,
        usuarioNome: usuarioNome,
        usuarioEmail: usuarioEmail,
        usuarioFoto: usuarioFoto,
      );

      return true;
    } catch (e) {
      debugPrint('Erro ao inscrever: $e');
      return false;
    } finally {
      _isInscrevendo = false;
      notifyListeners();
    }
  }

  /// Expande ou recolhe uma aula
  void toggleAulaExpandida(String aulaId) {
    if (_aulasExpandidas.contains(aulaId)) {
      _aulasExpandidas = Set.from(_aulasExpandidas)..remove(aulaId);
    } else {
      _aulasExpandidas = Set.from(_aulasExpandidas)..add(aulaId);
    }
    notifyListeners();
  }

  /// Verifica se uma aula está expandida
  bool isAulaExpandida(String aulaId) => _aulasExpandidas.contains(aulaId);

  /// Expande todas as aulas
  void expandirTodas() {
    _aulasExpandidas = _aulas.map((a) => a.id).toSet();
    notifyListeners();
  }

  /// Recolhe todas as aulas
  void recolherTodas() {
    _aulasExpandidas = {};
    notifyListeners();
  }

  /// Recarrega os dados
  Future<void> refresh({String? usuarioId}) async {
    _repository.limparCacheCurso(cursoId);
    await carregarDados(usuarioId: usuarioId, forceRefresh: true);
  }
}
