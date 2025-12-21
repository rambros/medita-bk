import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:medita_bk/data/repositories/auth_repository.dart';
import 'package:medita_bk/routing/ead_routes.dart';
import 'package:medita_bk/ui/core/theme/app_theme.dart';
import 'view_model/quiz_view_model.dart';
import 'widgets/question_tile.dart';
import 'widgets/quiz_result_widget.dart';

/// Pagina de quiz
class QuizPage extends StatefulWidget {
  const QuizPage({
    super.key,
    required this.cursoId,
    required this.aulaId,
    required this.topicoId,
  });

  final String cursoId;
  final String aulaId;
  final String topicoId;

  static const String routeName = EadRoutes.quiz;
  static const String routePath = EadRoutes.quizPath;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late final QuizViewModel _viewModel;
  bool _modoRevisao = false;

  @override
  void initState() {
    super.initState();
    _viewModel = QuizViewModel(
      cursoId: widget.cursoId,
      aulaId: widget.aulaId,
      topicoId: widget.topicoId,
    );
    _carregarDados();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  String? get _usuarioId {
    final uid = context.read<AuthRepository>().currentUserUid;
    return uid.isNotEmpty ? uid : null;
  }

  Future<void> _carregarDados() async {
    await _viewModel.carregarDados(usuarioId: _usuarioId);
  }

  void _selecionarResposta(String opcaoId) {
    _viewModel.selecionarResposta(opcaoId);
  }

  void _proximaPergunta() {
    if (_viewModel.isUltimaPergunta) {
      _finalizarQuiz();
    } else {
      _viewModel.proximaPergunta();
    }
  }

  void _perguntaAnterior() {
    _viewModel.perguntaAnterior();
  }

  Future<void> _finalizarQuiz() async {
    final usuarioId = _usuarioId;
    if (usuarioId == null) {
      _mostrarSnackBar('Faça login para completar a avaliação');
      return;
    }

    final appTheme = AppTheme.of(context);

    // Confirma se quer finalizar
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finalizar Avaliação'),
        content: const Text(
          'Tem certeza que deseja finalizar a avaliação?\n'
          'Suas respostas serão avaliadas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: appTheme.primary,
              foregroundColor: appTheme.info,
            ),
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await _viewModel.finalizarQuiz(usuarioId);
      if (mounted) {
        setState(() {
          _modoRevisao = false;
        });
      }
    }
  }

  void _entrarModoRevisao() {
    setState(() {
      _modoRevisao = true;
    });
    _viewModel.irParaPergunta(0);
  }

  void _sairModoRevisao() {
    setState(() {
      _modoRevisao = false;
    });
  }

  void _refazerQuiz() {
    _viewModel.reiniciarQuiz();
    setState(() {
      _modoRevisao = false;
    });
  }

  void _continuarCurso() {
    // Passa 'next' para indicar que deve navegar para o próximo tópico
    context.pop('next');
  }

  void _mostrarSnackBar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appTheme.primary,
          foregroundColor: appTheme.info,
          title: Text(_modoRevisao ? 'Revisão' : 'Avaliação'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              if (_modoRevisao) {
                _sairModoRevisao();
              } else {
                _confirmarSaida();
              }
            },
          ),
        ),
        body: Consumer<QuizViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              final appTheme = AppTheme.of(context);
              return Center(
                child: CircularProgressIndicator(color: appTheme.primary),
              );
            }

            if (viewModel.error != null) {
              return _buildError(viewModel);
            }

            if (viewModel.perguntas.isEmpty) {
              return _buildSemPerguntas();
            }

            // Mostra resultado se concluido e nao esta em modo revisao
            if (viewModel.quizConcluido && !_modoRevisao) {
              return QuizResultWidget(
                resultado: viewModel.resultado!,
                onRevisar: _entrarModoRevisao,
                onContinuar: _continuarCurso,
                onRefazer: _refazerQuiz,
              );
            }

            return _buildQuiz(viewModel);
          },
        ),
      ),
    );
  }

  Widget _buildError(QuizViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              viewModel.error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _carregarDados,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSemPerguntas() {
    final appTheme = AppTheme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.quiz_outlined,
            size: 64,
            color: appTheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text('Avaliação sem perguntas'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: appTheme.primary,
              foregroundColor: appTheme.info,
            ),
            child: const Text('Voltar'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuiz(QuizViewModel viewModel) {
    final pergunta = viewModel.perguntaAtualModel!;
    final mostrarResultado = _modoRevisao || viewModel.quizConcluido;

    return Column(
      children: [
        // Barra de progresso
        QuizProgressIndicator(
          totalPerguntas: viewModel.totalPerguntas,
          perguntaAtual: viewModel.perguntaAtual,
          respostas: viewModel.respostas,
          perguntas: viewModel.perguntas,
          onPerguntaTap: mostrarResultado ? viewModel.irParaPergunta : null,
        ),

        // Pergunta
        Expanded(
          child: QuestionTile(
            pergunta: pergunta,
            numeroPergunta: viewModel.perguntaAtual + 1,
            totalPerguntas: viewModel.totalPerguntas,
            respostaSelecionada: viewModel.respostaSelecionada,
            respostasSelecionadas: viewModel.respostasSelecionadas,
            onRespostaSelecionada: _selecionarResposta,
            mostrarResultado: mostrarResultado,
          ),
        ),

        // Botoes de navegacao
        _buildNavigationBar(viewModel, mostrarResultado),
      ],
    );
  }

  Widget _buildNavigationBar(QuizViewModel viewModel, bool mostrarResultado) {
    final appTheme = AppTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appTheme.secondaryBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Botão anterior
            if (!viewModel.isPrimeiraPergunta)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _perguntaAnterior,
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text('Anterior'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: appTheme.primary,
                    side: BorderSide(color: appTheme.primary),
                  ),
                ),
              )
            else
              const Expanded(child: SizedBox()),

            const SizedBox(width: 16),

            // Botão próximo/finalizar
            Expanded(
              child: _buildNextButton(viewModel, mostrarResultado),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton(QuizViewModel viewModel, bool mostrarResultado) {
    final appTheme = AppTheme.of(context);

    // Se está em modo revisão
    if (mostrarResultado) {
      if (viewModel.isUltimaPergunta) {
        return ElevatedButton.icon(
          onPressed: _sairModoRevisao,
          icon: const Icon(Icons.check, size: 18),
          label: const Text('Ver resultado'),
          style: ElevatedButton.styleFrom(
            backgroundColor: appTheme.primary,
            foregroundColor: appTheme.info,
          ),
        );
      }
      return ElevatedButton.icon(
        onPressed: _proximaPergunta,
        icon: const Text('Próxima'),
        label: const Icon(Icons.arrow_forward, size: 18),
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.primary,
          foregroundColor: appTheme.info,
        ),
      );
    }

    // Se é a última pergunta
    if (viewModel.isUltimaPergunta) {
      return ElevatedButton.icon(
        onPressed: viewModel.todasRespondidas
            ? () {
                if (viewModel.isSubmitting) return;
                _finalizarQuiz();
              }
            : null,
        icon: viewModel.isSubmitting
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: appTheme.info,
                ),
              )
            : const Icon(Icons.check, size: 18),
        label: const Text('Finalizar'),
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.primary,
          foregroundColor: appTheme.info,
        ),
      );
    }

    // Próxima pergunta
    return ElevatedButton.icon(
      onPressed: viewModel.perguntaAtualRespondida ? _proximaPergunta : null,
      icon: const Text('Próxima'),
      label: const Icon(Icons.arrow_forward, size: 18),
      style: ElevatedButton.styleFrom(
        backgroundColor: appTheme.primary,
        foregroundColor: appTheme.info,
      ),
    );
  }

  Future<void> _confirmarSaida() async {
    if (_viewModel.quizConcluido) {
      context.pop();
      return;
    }

    final appTheme = AppTheme.of(context);

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da Avaliação'),
        content: const Text(
          'Tem certeza que deseja sair?\n'
          'Seu progresso será perdido.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: appTheme.error,
              foregroundColor: appTheme.info,
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      context.pop();
    }
  }
}
