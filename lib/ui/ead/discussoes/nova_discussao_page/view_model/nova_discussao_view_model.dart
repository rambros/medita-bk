import 'package:flutter/material.dart';

import '../../../../../data/repositories/comunicacao_repository.dart';

/// ViewModel para a página de nova discussão
class NovaDiscussaoViewModel extends ChangeNotifier {
  final ComunicacaoRepository _repository;
  final String cursoId;
  final String cursoTitulo;

  NovaDiscussaoViewModel({
    required this.cursoId,
    required this.cursoTitulo,
    ComunicacaoRepository? repository,
  }) : _repository = repository ?? ComunicacaoRepository();

  // === Controllers ===
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController conteudoController = TextEditingController();

  // === Estado ===
  bool _isPrivada = false;
  bool _isCriando = false;
  String? _error;

  // === Getters ===
  bool get isPrivada => _isPrivada;
  bool get isCriando => _isCriando;
  String? get error => _error;

  /// Valida se o formulário está pronto para envio
  bool get isFormularioValido {
    return tituloController.text.trim().length >= 5 &&
        conteudoController.text.trim().length >= 10;
  }

  /// Validação do título
  String? validarTitulo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Digite um título para sua pergunta';
    }
    if (value.trim().length < 5) {
      return 'O título deve ter pelo menos 5 caracteres';
    }
    if (value.trim().length > 200) {
      return 'O título deve ter no máximo 200 caracteres';
    }
    return null;
  }

  /// Validação do conteúdo
  String? validarConteudo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Descreva sua dúvida ou pergunta';
    }
    if (value.trim().length < 10) {
      return 'A descrição deve ter pelo menos 10 caracteres';
    }
    return null;
  }

  // === Ações ===

  /// Define se a discussão é privada
  void setPrivada(bool value) {
    _isPrivada = value;
    notifyListeners();
  }

  /// Cria uma nova discussão
  Future<String?> criarDiscussao({
    required String autorId,
    required String autorNome,
    String? autorFoto,
  }) async {
    if (!isFormularioValido) {
      _error = 'Preencha todos os campos corretamente';
      notifyListeners();
      return null;
    }

    _isCriando = true;
    _error = null;
    notifyListeners();

    try {
      final discussaoId = await _repository.criarDiscussao(
        cursoId: cursoId,
        cursoTitulo: cursoTitulo,
        titulo: tituloController.text.trim(),
        conteudo: conteudoController.text.trim(),
        autorId: autorId,
        autorNome: autorNome,
        autorFoto: autorFoto,
        isPrivada: _isPrivada,
      );

      if (discussaoId != null) {
        _limparFormulario();
        return discussaoId;
      } else {
        _error = 'Erro ao criar discussão. Tente novamente.';
        return null;
      }
    } catch (e) {
      _error = 'Erro ao criar discussão: $e';
      debugPrint(_error);
      return null;
    } finally {
      _isCriando = false;
      notifyListeners();
    }
  }

  void _limparFormulario() {
    tituloController.clear();
    conteudoController.clear();
    _isPrivada = false;
  }

  @override
  void dispose() {
    tituloController.dispose();
    conteudoController.dispose();
    super.dispose();
  }
}
