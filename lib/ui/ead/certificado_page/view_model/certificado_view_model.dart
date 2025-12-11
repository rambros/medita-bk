import 'package:flutter/material.dart';

import 'package:medita_bk/data/repositories/ead_repository.dart';
import 'package:medita_bk/domain/models/ead/index.dart';

/// ViewModel para a pagina de certificado
class CertificadoViewModel extends ChangeNotifier {
  final EadRepository _repository;
  final String cursoId;

  CertificadoViewModel({
    required this.cursoId,
    EadRepository? repository,
  }) : _repository = repository ?? EadRepository();

  // === Estado ===

  CursoModel? _curso;
  CursoModel? get curso => _curso;

  InscricaoCursoModel? _inscricao;
  InscricaoCursoModel? get inscricao => _inscricao;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // === Getters computados ===

  /// Verifica se o certificado esta disponivel
  bool get certificadoDisponivel =>
      _inscricao != null && _inscricao!.isConcluido;

  /// Nome do aluno
  String get nomeAluno => _inscricao?.usuarioNome ?? 'Aluno';

  /// Titulo do curso
  String get tituloCurso => _curso?.titulo ?? '';

  /// Nome do autor/instrutor
  String get nomeInstrutor => _curso?.nomeAutor ?? '';

  /// Data de conclusao formatada
  String get dataConclusaoFormatada {
    final data = _inscricao?.dataConclusao;
    if (data == null) return '';
    
    final meses = [
      'janeiro', 'fevereiro', 'marco', 'abril', 'maio', 'junho',
      'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro'
    ];
    
    return '${data.day} de ${meses[data.month - 1]} de ${data.year}';
  }

  /// Carga horaria do curso
  String get cargaHoraria => _curso?.duracaoEstimada ?? '';

  /// Total de aulas
  int get totalAulas => _curso?.totalAulas ?? 0;

  /// Total de topicos concluidos
  int get totalTopicos => _inscricao?.progresso.topicosCompletos.length ?? 0;

  /// Codigo do certificado (hash unico)
  String get codigoCertificado {
    if (_inscricao == null) return '';
    // Gera um codigo baseado no ID da inscricao e data
    final base = '${_inscricao!.id}-${_inscricao!.cursoId}-${_inscricao!.usuarioId}';
    return base.hashCode.toRadixString(16).toUpperCase().padLeft(8, '0');
  }

  // === Acoes ===

  /// Carrega os dados do certificado
  Future<void> carregarDados(String usuarioId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Carrega curso
      _curso = await _repository.getCursoById(cursoId);
      if (_curso == null) {
        throw Exception('Curso nao encontrado');
      }

      // Carrega inscricao
      _inscricao = await _repository.getInscricao(cursoId, usuarioId);
      if (_inscricao == null) {
        throw Exception('Inscricao nao encontrada');
      }

      if (!_inscricao!.isConcluido) {
        throw Exception('Curso ainda nao foi concluido');
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Erro ao carregar certificado: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
