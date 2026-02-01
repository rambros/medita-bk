import 'package:flutter/foundation.dart';

import '../../../../data/repositories/index.dart';
import '../../../../domain/models/ead/index.dart';

/// ViewModel para o formulário de avaliação do aluno
class AvaliacaoFormViewModel extends ChangeNotifier {
  final String inscricaoId;
  final AvaliacaoRepository _avaliacaoRepository;

  AvaliacaoFormViewModel({required this.inscricaoId, AvaliacaoRepository? avaliacaoRepository})
    : _avaliacaoRepository = avaliacaoRepository ?? AvaliacaoRepository() {
    _init();
  }

  // === Estado ===
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  AvaliacaoCursoModel? _avaliacao;
  InscricaoCursoModel? _inscricao;
  CursoModel? _curso;

  final Map<String, dynamic> _respostas = {};
  DateTime? _inicioPreenchimento;

  // === Getters ===
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;
  AvaliacaoCursoModel? get avaliacao => _avaliacao;
  InscricaoCursoModel? get inscricao => _inscricao;
  CursoModel? get curso => _curso;
  Map<String, dynamic> get respostas => Map.unmodifiable(_respostas);

  /// Verifica se pode submeter (todas obrigatórias respondidas)
  bool get podeSubmeter {
    if (_avaliacao == null) return false;
    return _avaliacaoRepository.validarRespostas(avaliacao: _avaliacao!, respostas: _respostas);
  }

  /// Calcula progresso (0-100)
  double get progresso {
    if (_avaliacao == null) return 0;
    return _avaliacaoRepository.calcularProgresso(avaliacao: _avaliacao!, respostas: _respostas);
  }

  /// Retorna perguntas ordenadas
  List<PerguntaAvaliacaoModel> get perguntas {
    return _avaliacao?.perguntasOrdenadas ?? [];
  }

  // === Inicialização ===

  Future<void> _init() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Marcar início do preenchimento
      _inicioPreenchimento = DateTime.now();

      // Buscar dados da inscrição
      await _carregarDados();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao carregar avaliação: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _carregarDados() async {
    // TODO: Buscar inscrição e curso do Firestore
    // Por enquanto, apenas buscar a avaliação

    // Extrair cursoId do inscricaoId (formato: cursoId_usuarioId)
    final parts = inscricaoId.split('_');
    if (parts.isEmpty) {
      throw Exception('ID de inscrição inválido');
    }

    final cursoId = parts[0];

    // Buscar avaliação do curso
    _avaliacao = await _avaliacaoRepository.getAvaliacaoCurso(cursoId);

    if (_avaliacao == null) {
      throw Exception('Avaliação não encontrada para este curso');
    }

    // Verificar se já respondeu
    final jaRespondeu = await _avaliacaoRepository.jaRespondeu(inscricaoId);
    if (jaRespondeu) {
      // Carregar respostas anteriores
      final respostaAnterior = await _avaliacaoRepository.getResposta(inscricaoId);
      if (respostaAnterior != null) {
        _respostas.addAll(respostaAnterior.respostas);
      }
    }
  }

  // === Ações ===

  /// Atualiza resposta de uma pergunta
  void setResposta(String perguntaId, dynamic valor) {
    _respostas[perguntaId] = valor;
    notifyListeners();
  }

  /// Retorna resposta de uma pergunta
  dynamic getResposta(String perguntaId) {
    return _respostas[perguntaId];
  }

  /// Verifica se pergunta foi respondida
  bool isRespondida(String perguntaId) {
    final resposta = _respostas[perguntaId];
    if (resposta == null) return false;
    if (resposta is String) return resposta.trim().isNotEmpty;
    return true;
  }

  /// Limpa erro
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Submete avaliação
  Future<bool> submeter({required String usuarioId, required String usuarioNome, required String usuarioEmail}) async {
    if (!podeSubmeter) {
      _error = 'Por favor, responda todas as perguntas obrigatórias';
      notifyListeners();
      return false;
    }

    try {
      _isSaving = true;
      _error = null;
      notifyListeners();

      // Calcular tempo de preenchimento
      final tempoSegundos = _inicioPreenchimento != null
          ? DateTime.now().difference(_inicioPreenchimento!).inSeconds
          : 0;

      // Extrair cursoId
      final parts = inscricaoId.split('_');
      final cursoId = parts[0];

      // Criar resposta
      final resposta = RespostaAvaliacaoModel.criar(
        inscricaoId: inscricaoId,
        cursoId: cursoId,
        usuarioId: usuarioId,
        usuarioNome: usuarioNome,
        usuarioEmail: usuarioEmail,
        respostas: Map<String, dynamic>.from(_respostas),
        tempoPreenchimentoSegundos: tempoSegundos,
        versaoAvaliacao: _avaliacao?.versao ?? 1,
      );

      // Salvar
      await _avaliacaoRepository.salvarResposta(resposta);

      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Erro ao enviar avaliação: $e';
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  /// Recarrega dados
  Future<void> refresh() async {
    await _init();
  }
}
