import 'package:flutter/material.dart';

import 'package:medita_bk/data/repositories/ead_repository.dart';
import 'package:medita_bk/domain/models/ead/index.dart';

/// ViewModel para o player de topico
class PlayerTopicoViewModel extends ChangeNotifier {
  final EadRepository _repository;
  final String cursoId;
  final String aulaId;
  final String topicoId;

  PlayerTopicoViewModel({
    required this.cursoId,
    required this.aulaId,
    required this.topicoId,
    EadRepository? repository,
  }) : _repository = repository ?? EadRepository();

  // === Estado ===

  CursoModel? _curso;
  CursoModel? get curso => _curso;

  AulaModel? _aula;
  AulaModel? get aula => _aula;

  TopicoModel? _topico;
  TopicoModel? get topico => _topico;

  List<AulaModel> _todasAulas = [];
  List<AulaModel> get todasAulas => _todasAulas;

  InscricaoCursoModel? _inscricao;
  InscricaoCursoModel? get inscricao => _inscricao;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isMarcandoCompleto = false;
  bool get isMarcandoCompleto => _isMarcandoCompleto;

  String? _error;
  String? get error => _error;

  // === Getters computados ===

  /// Verifica se o topico atual esta completo
  bool get isTopicoCompleto {
    return _inscricao?.progresso.isTopicoCompleto(topicoId) ?? false;
  }

  /// Verifica se o usuario esta inscrito
  bool get isInscrito => _inscricao != null && _inscricao!.isAtivo;

  /// Progresso geral do curso (calculado dinamicamente)
  double get progressoCurso {
    if (_inscricao == null) return 0;
    final totalTopicos = todosTopicos.length;
    if (totalTopicos == 0) return 0;
    return (_inscricao!.topicosCompletos / totalTopicos) * 100;
  }

  /// Lista de todos os topicos do curso (achatada)
  List<({AulaModel aula, TopicoModel topico})> get todosTopicos {
    final lista = <({AulaModel aula, TopicoModel topico})>[];
    for (final aula in _todasAulas) {
      for (final topico in aula.topicos) {
        lista.add((aula: aula, topico: topico));
      }
    }
    return lista;
  }

  /// Indice do topico atual na lista achatada
  int get indiceAtual {
    return todosTopicos.indexWhere((item) => item.topico.id == topicoId);
  }

  /// Topico anterior (se existir)
  ({AulaModel aula, TopicoModel topico})? get topicoAnterior {
    final idx = indiceAtual;
    if (idx > 0) {
      return todosTopicos[idx - 1];
    }
    return null;
  }

  /// Proximo topico (se existir)
  ({AulaModel aula, TopicoModel topico})? get proximoTopico {
    final idx = indiceAtual;
    if (idx >= 0 && idx < todosTopicos.length - 1) {
      return todosTopicos[idx + 1];
    }
    return null;
  }

  /// Verifica se tem topico anterior
  bool get hasAnterior => topicoAnterior != null;

  /// Verifica se tem proximo topico
  bool get hasProximo => proximoTopico != null;

  /// Titulo da aula atual
  String get tituloAula => _aula?.titulo ?? '';

  /// Titulo do topico atual
  String get tituloTopico => _topico?.titulo ?? '';

  /// Tipo do conteudo
  TipoConteudoTopico? get tipoConteudo => _topico?.tipo;

  /// URL do conteudo (video/audio)
  String? get urlConteudo => _topico?.url;

  /// Conteudo HTML (para tipo texto)
  String? get htmlConteudo => _topico?.htmlContent;

  /// Verificacoes de tipo
  bool get isVideo => _topico?.isVideo ?? false;
  bool get isAudio => _topico?.isAudio ?? false;
  bool get isTexto => _topico?.isTexto ?? false;
  bool get isQuiz => _topico?.isQuiz ?? false;

  /// Texto do indicador de progresso
  String get textoProgresso {
    final idx = indiceAtual;
    final total = todosTopicos.length;
    if (idx >= 0) {
      return '${idx + 1} de $total';
    }
    return '';
  }

  // === Acoes ===

  /// Carrega os dados do topico
  Future<void> carregarDados({String? usuarioId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Carrega curso
      _curso = await _repository.getCursoById(cursoId);
      if (_curso == null) {
        throw Exception('Curso nao encontrado');
      }

      // Carrega todas as aulas com topicos
      _todasAulas = await _repository.getAulasComTopicos(cursoId);

      // Encontra a aula e topico atual
      for (final aula in _todasAulas) {
        if (aula.id == aulaId) {
          _aula = aula;
          _topico = aula.topicos.firstWhere(
            (t) => t.id == topicoId,
            orElse: () => throw Exception('Topico nao encontrado'),
          );
          break;
        }
      }

      if (_aula == null || _topico == null) {
        throw Exception('Aula ou topico nao encontrado');
      }

      // Carrega inscricao do usuario
      if (usuarioId != null) {
        _inscricao = await _repository.getInscricao(cursoId, usuarioId);

        // Atualiza ultimo acesso
        if (_inscricao != null) {
          await _repository.atualizarUltimoAcesso(
            cursoId: cursoId,
            usuarioId: usuarioId,
            aulaId: aulaId,
            topicoId: topicoId,
          );
        }
      }

      _error = null;
    } catch (e) {
      _error = 'Erro ao carregar conteudo: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Marca o topico como completo
  Future<bool> marcarCompleto(String usuarioId) async {
    if (_inscricao == null) return false;

    _isMarcandoCompleto = true;
    notifyListeners();

    try {
      _inscricao = await _repository.marcarTopicoCompleto(
        cursoId: cursoId,
        usuarioId: usuarioId,
        aulaId: aulaId,
        topicoId: topicoId,
      );
      return true;
    } catch (e) {
      debugPrint('Erro ao marcar topico completo: $e');
      return false;
    } finally {
      _isMarcandoCompleto = false;
      notifyListeners();
    }
  }

  /// Desmarca o topico como completo
  Future<bool> desmarcarCompleto(String usuarioId) async {
    if (_inscricao == null) return false;

    _isMarcandoCompleto = true;
    notifyListeners();

    try {
      _inscricao = await _repository.desmarcarTopicoCompleto(
        cursoId: cursoId,
        aulaId: aulaId,
        topicoId: topicoId,
        usuarioId: usuarioId,
      );
      return true;
    } catch (e) {
      debugPrint('Erro ao desmarcar topico: $e');
      return false;
    } finally {
      _isMarcandoCompleto = false;
      notifyListeners();
    }
  }

  /// Toggle completo
  Future<bool> toggleCompleto(String usuarioId) async {
    if (isTopicoCompleto) {
      return await desmarcarCompleto(usuarioId);
    } else {
      return await marcarCompleto(usuarioId);
    }
  }
}
