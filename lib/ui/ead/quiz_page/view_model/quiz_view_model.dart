import 'package:flutter/material.dart';

import 'package:medita_bk/data/repositories/ead_repository.dart';
import 'package:medita_bk/data/services/ead_service.dart';
import 'package:medita_bk/domain/models/ead/index.dart';

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

  bool _disposed = false;

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

  // Respostas do usuario (perguntaId -> String para única resposta ou Set<String> para múltiplas)
  final Map<String, dynamic> _respostas = {};
  Map<String, dynamic> get respostas => Map.unmodifiable(_respostas);

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

  /// Resposta selecionada para a pergunta atual (String ou null para única resposta)
  String? get respostaSelecionada {
    final pergunta = perguntaAtualModel;
    if (pergunta == null) return null;
    final resposta = _respostas[pergunta.id];
    return resposta is String ? resposta : null;
  }

  /// Respostas selecionadas para a pergunta atual (`Set<String>` para múltiplas respostas)
  Set<String> get respostasSelecionadas {
    final pergunta = perguntaAtualModel;
    if (pergunta == null) return {};
    final resposta = _respostas[pergunta.id];
    if (resposta is Set<String>) return resposta;
    if (resposta is String) return {resposta};
    return {};
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
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Seleciona uma resposta para a pergunta atual
  void selecionarResposta(String opcaoId) {
    final pergunta = perguntaAtualModel;
    if (pergunta == null || _estado == QuizEstado.concluido) return;

    if (pergunta.isMultiplasRespostas) {
      // Múltiplas respostas: toggle checkbox
      final respostasAtuais = _respostas[pergunta.id] as Set<String>? ?? <String>{};
      if (respostasAtuais.contains(opcaoId)) {
        respostasAtuais.remove(opcaoId);
      } else {
        respostasAtuais.add(opcaoId);
      }
      _respostas[pergunta.id] = respostasAtuais;
    } else {
      // Múltipla escolha ou V/F: radio button
      _respostas[pergunta.id] = opcaoId;
    }

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

        bool acertou = false;
        if (pergunta.isMultiplasRespostas) {
          // Múltiplas respostas: all-or-nothing
          final respostasSet = respostaUsuario is Set<String>
              ? respostaUsuario
              : (respostaUsuario is String ? {respostaUsuario} : <String>{});
          acertou = pergunta.isRespostaCorreta(respostasSet);
        } else {
          // Múltipla escolha ou V/F
          if (respostaUsuario is String) {
            acertou = pergunta.isOpcaoCorreta(respostaUsuario);
          } else if (respostaUsuario is Set<String> && respostaUsuario.length == 1) {
            acertou = pergunta.isOpcaoCorreta(respostaUsuario.first);
          }
        }

        if (acertou) acertos++;
      }

      final nota = (acertos / _perguntas.length) * 100;

      // Converter respostas para formato que o resultado espera (Map<String, String>)
      final respostasParaSalvar = <String, String>{};
      _respostas.forEach((key, value) {
        if (value is String) {
          respostasParaSalvar[key] = value;
        } else if (value is Set<String>) {
          respostasParaSalvar[key] = value.join(','); // Salvar múltiplas separadas por vírgula
        }
      });

      _resultado = QuizResultadoModel(
        topicoId: topicoId,
        totalPerguntas: _perguntas.length,
        acertos: acertos,
        nota: nota,
        dataRealizacao: DateTime.now(),
        respostas: respostasParaSalvar,
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
    final pergunta = perguntaAtualModel;
    if (pergunta == null) return false;

    if (pergunta.isMultiplasRespostas) {
      return respostasSelecionadas.contains(opcaoId);
    } else {
      return respostaSelecionada == opcaoId;
    }
  }

  /// Verifica se a opcao e a correta (apos concluir quiz)
  bool isOpcaoCorreta(String opcaoId) {
    if (!quizConcluido) return false;
    final pergunta = perguntaAtualModel;
    return pergunta?.isOpcaoCorreta(opcaoId) ?? false;
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

/// Estado do quiz
enum QuizEstado {
  emAndamento,
  concluido,
}
