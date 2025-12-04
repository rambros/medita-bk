import 'package:flutter/material.dart';

import 'package:medita_b_k/data/repositories/comunicacao_repository.dart';
import 'package:medita_b_k/data/repositories/ead_repository.dart';
import 'package:medita_b_k/domain/models/ead/index.dart';

/// ViewModel para a página de Novo Ticket
class NovoTicketViewModel extends ChangeNotifier {
  final ComunicacaoRepository _comunicacaoRepository;
  final EadRepository _eadRepository;

  NovoTicketViewModel({
    ComunicacaoRepository? comunicacaoRepository,
    EadRepository? eadRepository,
  })  : _comunicacaoRepository =
            comunicacaoRepository ?? ComunicacaoRepository(),
        _eadRepository = eadRepository ?? EadRepository();

  // === Controllers ===

  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();

  // === Estado ===

  CategoriaTicket _categoriaSelecionada = CategoriaTicket.outro;
  CategoriaTicket get categoriaSelecionada => _categoriaSelecionada;

  String? _cursoSelecionadoId;
  String? get cursoSelecionadoId => _cursoSelecionadoId;

  CursoModel? _cursoSelecionado;
  CursoModel? get cursoSelecionado => _cursoSelecionado;

  List<CursoModel> _cursosDisponiveis = [];
  List<CursoModel> get cursosDisponiveis => _cursosDisponiveis;

  bool _isLoadingCursos = false;
  bool get isLoadingCursos => _isLoadingCursos;

  bool _isCriando = false;
  bool get isCriando => _isCriando;

  String? _error;
  String? get error => _error;

  // === Validação ===

  bool get isFormularioValido {
    return tituloController.text.trim().isNotEmpty &&
        descricaoController.text.trim().isNotEmpty;
  }

  String? validarTitulo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, informe o título';
    }
    if (value.trim().length < 5) {
      return 'O título deve ter no mínimo 5 caracteres';
    }
    return null;
  }

  String? validarDescricao(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, descreva o problema';
    }
    if (value.trim().length < 20) {
      return 'A descrição deve ter no mínimo 20 caracteres';
    }
    return null;
  }

  // === Ações ===

  /// Carrega os cursos do usuário para seleção opcional
  Future<void> carregarCursos(String usuarioId) async {
    _isLoadingCursos = true;
    notifyListeners();

    try {
      final inscricoes = await _eadRepository.getMeusInscritos(usuarioId);
      _cursosDisponiveis = inscricoes
          .where((i) => i.isAtivo || i.isPausado)
          .map((i) => CursoModel(
                id: i.cursoId,
                titulo: i.cursoTitulo,
                imagemCapa: i.cursoImagem,
              ))
          .toList();
    } catch (e) {
      debugPrint('Erro ao carregar cursos: $e');
      _cursosDisponiveis = [];
    } finally {
      _isLoadingCursos = false;
      notifyListeners();
    }
  }

  /// Seleciona a categoria
  void setCategoria(CategoriaTicket categoria) {
    if (_categoriaSelecionada != categoria) {
      _categoriaSelecionada = categoria;
      notifyListeners();
    }
  }

  /// Seleciona um curso (opcional)
  void setCurso(String? cursoId) {
    _cursoSelecionadoId = cursoId;
    _cursoSelecionado = cursoId != null
        ? _cursosDisponiveis.firstWhere(
            (c) => c.id == cursoId,
            orElse: () => _cursosDisponiveis.first,
          )
        : null;
    notifyListeners();
  }

  /// Cria o ticket
  Future<String?> criarTicket({
    required String usuarioId,
    required String usuarioNome,
    String? usuarioEmail,
  }) async {
    if (!isFormularioValido) {
      _error = 'Preencha todos os campos obrigatórios';
      notifyListeners();
      return null;
    }

    _isCriando = true;
    _error = null;
    notifyListeners();

    try {
      final ticketId = await _comunicacaoRepository.criarTicket(
        titulo: tituloController.text.trim(),
        descricao: descricaoController.text.trim(),
        categoria: _categoriaSelecionada,
        usuarioId: usuarioId,
        usuarioNome: usuarioNome,
        usuarioEmail: usuarioEmail,
        cursoId: _cursoSelecionado?.id,
        cursoTitulo: _cursoSelecionado?.titulo,
      );

      if (ticketId == null) {
        _error = 'Erro ao criar ticket. Tente novamente.';
        _isCriando = false;
        notifyListeners();
        return null;
      }

      _isCriando = false;
      notifyListeners();
      return ticketId;
    } catch (e) {
      _error = 'Erro ao criar ticket: $e';
      _isCriando = false;
      notifyListeners();
      return null;
    }
  }

  /// Limpa o formulário
  void limparFormulario() {
    tituloController.clear();
    descricaoController.clear();
    _categoriaSelecionada = CategoriaTicket.outro;
    _cursoSelecionadoId = null;
    _cursoSelecionado = null;
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    tituloController.dispose();
    descricaoController.dispose();
    super.dispose();
  }
}
