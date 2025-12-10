import 'package:flutter/material.dart';

import 'package:medita_b_k/data/repositories/ead_repository.dart';
import 'package:medita_b_k/data/services/ead_service.dart';
import 'package:medita_b_k/domain/models/ead/index.dart';

/// ViewModel para a pagina de quiz
class QuizViewModel extends ChangeNotifier {
  final EadRepository _repository;
  final EadService _service;
  final String cursoId;
  final String aulaId;
  final String topicoId;

  QuizViewModel({
    required this.cursoId,
    required this.aulaId,
    required this.topicoId,
    EadRepository? repository,
    EadService? service,
  })  : _repository = repository ?? EadRepository(),
        _service = service ?? EadService();

  // === Estado ===

  TopicoModel? _topico;
  TopicoModel? get topico => _topico;

  List<QuizQuestionModel> _perguntas = [];
  List<QuizQuestionModel> get perguntas => _perguntas;

  InscricaoCursoModel? _inscricao;
  InscricaoCursoModel? get inscricao => _inscricao;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  String? _error;
  String? get error => _error;

  // Respostas do usuario (perguntaId -> opcaoId)
  final Map<String, String> _respostas = {};
  Map<String, String> get respostas => Map.unmodifiable(_respostas);

  // Indice da pergunta atual
  int _perguntaAtual = 0;
  int get perguntaAtual => _perguntaAtual;

  // Estado do quiz
  QuizEstado _estado = QuizEstado.emAndamento;
  QuizEstado get estado => _estado;

  // Resultado do quiz
  QuizResultadoModel? _resultado;
  QuizResultadoModel? get resultado => _resultado;

  // === Getters computados ===

  /// Total de perguntas
  int get totalPerguntas => _perguntas.length;

  /// Pergunta atual
  QuizQuestionModel? get perguntaAtualModel {
    if (_perguntaAtual >= 0 && _perguntaAtual < _perguntas.length) {
      return _perguntas[_perguntaAtual];
    }
    return null;
  }

  /// Verifica se e a primeira pergunta
  bool get isPrimeiraPergunta => _perguntaAtual == 0;

  /// Verifica se e a ultima pergunta
  bool get isUltimaPergunta => _perguntaAtual == _perguntas.length - 1;

  /// Progresso do quiz (0 a 1)
  double get progressoQuiz {
    if (_perguntas.isEmpty) return 0;
    return (_perguntaAtual + 1) / _perguntas.length;
  }

  /// Texto do progresso
  String get textoProgresso => '${_perguntaAtual + 1}/$totalPerguntas';

  /// Verifica se a pergunta atual foi respondida
  bool get perguntaAtualRespondida {
    final pergunta = perguntaAtualModel;
    if (pergunta == null) return false;
    return _respostas.containsKey(pergunta.id);
  }

  /// Resposta selecionada para a pergunta atual
  String? get respostaSelecionada {
    final pergunta = perguntaAtualModel;
    if (pergunta == null) return null;
    return _respostas[pergunta.id];
  }

  /// Verifica se todas as perguntas foram respondidas
  bool get todasRespondidas => _respostas.length == _perguntas.length;

  /// Verifica se o quiz foi concluido
  bool get quizConcluido => _estado == QuizEstado.concluido;

  /// Verifica se foi aprovado (nota >= 70)
  bool get aprovado => _resultado?.aprovado ?? false;

  // === Acoes ===

  /// Carrega os dados do quiz
  Future<void> carregarDados({String? usuarioId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Carrega perguntas do quiz
      _perguntas = await _service.getQuizByTopico(cursoId, aulaId, topicoId);
      
      if (_perguntas.isEmpty) {
        throw Exception('Quiz nao possui perguntas');
      }

      // Carrega inscricao do usuario
      if (usuarioId != null) {
        _inscricao = await _repository.getInscricao(cursoId, usuarioId);
      }

      _error = null;
    } catch (e) {
      _error = 'Erro ao carregar quiz: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Seleciona uma resposta para a pergunta atual
  void selecionarResposta(String opcaoId) {
    final pergunta = perguntaAtualModel;
    if (pergunta == null || _estado == QuizEstado.concluido) return;

    _respostas[pergunta.id] = opcaoId;
    notifyListeners();
  }

  /// Vai para a proxima pergunta
  void proximaPergunta() {
    if (_perguntaAtual < _perguntas.length - 1) {
      _perguntaAtual++;
      notifyListeners();
    }
  }

  /// Volta para a pergunta anterior
  void perguntaAnterior() {
    if (_perguntaAtual > 0) {
      _perguntaAtual--;
      notifyListeners();
    }
  }

  /// Vai para uma pergunta especifica
  void irParaPergunta(int index) {
    if (index >= 0 && index < _perguntas.length) {
      _perguntaAtual = index;
      notifyListeners();
    }
  }

  /// Finaliza o quiz e calcula resultado
  Future<QuizResultadoModel?> finalizarQuiz(String usuarioId) async {
    if (!todasRespondidas) return null;

    _isSubmitting = true;
    notifyListeners();

    try {
      // Calcula resultado
      int acertos = 0;
      for (final pergunta in _perguntas) {
        final respostaUsuario = _respostas[pergunta.id];
        if (respostaUsuario != null && pergunta.isOpcaoCorreta(respostaUsuario)) {
          acertos++;
        }
      }

      final nota = (acertos / _perguntas.length) * 100;

      _resultado = QuizResultadoModel(
        topicoId: topicoId,
        totalPerguntas: _perguntas.length,
        acertos: acertos,
        nota: nota,
        dataRealizacao: DateTime.now(),
        respostas: Map.from(_respostas),
      );

      _estado = QuizEstado.concluido;

      // Se aprovado, marca topico como completo
      if (_resultado!.aprovado) {
        await _repository.marcarTopicoCompleto(
          cursoId: cursoId,
          usuarioId: usuarioId,
          aulaId: aulaId,
          topicoId: topicoId,
        );
      }

      return _resultado;
    } catch (e) {
      debugPrint('Erro ao finalizar quiz: $e');
      return null;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  /// Reinicia o quiz
  void reiniciarQuiz() {
    _respostas.clear();
    _perguntaAtual = 0;
    _estado = QuizEstado.emAndamento;
    _resultado = null;
    notifyListeners();
  }

  /// Verifica se uma opcao especifica foi selecionada
  bool isOpcaoSelecionada(String opcaoId) {
    return respostaSelecionada == opcaoId;
  }

  /// Verifica se a opcao e a correta (apos concluir quiz)
  bool isOpcaoCorreta(String opcaoId) {
    if (!quizConcluido) return false;
    final pergunta = perguntaAtualModel;
    return pergunta?.isOpcaoCorreta(opcaoId) ?? false;
  }
}

/// Estado do quiz
enum QuizEstado {
  emAndamento,
  concluido,
}
