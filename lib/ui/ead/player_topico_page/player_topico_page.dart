import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:medita_b_k/data/repositories/auth_repository.dart';
import 'package:medita_b_k/routing/ead_routes.dart';
import 'package:medita_b_k/ui/core/theme/app_theme.dart';
import 'view_model/player_topico_view_model.dart';
import 'widgets/mark_complete_button.dart';
import 'widgets/navegacao_topicos_widget.dart';
import 'widgets/topico_content_widget.dart';
import 'widgets/topico_header_widget.dart';

/// Pagina de player para visualizar conteudo do topico
class PlayerTopicoPage extends StatefulWidget {
  const PlayerTopicoPage({
    super.key,
    required this.cursoId,
    required this.aulaId,
    required this.topicoId,
  });

  final String cursoId;
  final String aulaId;
  final String topicoId;

  static const String routeName = EadRoutes.playerTopico;
  static const String routePath = EadRoutes.playerTopicoPath;

  @override
  State<PlayerTopicoPage> createState() => _PlayerTopicoPageState();
}

class _PlayerTopicoPageState extends State<PlayerTopicoPage> {
  late PlayerTopicoViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _initViewModel();
  }

  void _initViewModel() {
    _viewModel = PlayerTopicoViewModel(
      cursoId: widget.cursoId,
      aulaId: widget.aulaId,
      topicoId: widget.topicoId,
    );
    _carregarDados();
  }

  @override
  void didUpdateWidget(PlayerTopicoPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Se mudou o topico, reinicializa o viewmodel
    if (oldWidget.topicoId != widget.topicoId || oldWidget.aulaId != widget.aulaId) {
      _viewModel.dispose();
      _initViewModel();
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  String? get _usuarioId =>
      context.read<AuthRepository>().currentUserUid.isEmpty ? null : context.read<AuthRepository>().currentUserUid;

  Future<void> _carregarDados() async {
    await _viewModel.carregarDados(usuarioId: _usuarioId);
  }

  void _navegarParaTopico(String aulaId, String topicoId) {
    context.pushReplacementNamed(
      EadRoutes.playerTopico,
      pathParameters: {
        'cursoId': widget.cursoId,
        'aulaId': aulaId,
        'topicoId': topicoId,
      },
    );
  }

  void _irParaAnterior() {
    final anterior = _viewModel.topicoAnterior;
    if (anterior != null) {
      _navegarParaTopico(anterior.aula.id, anterior.topico.id);
    }
  }

  void _irParaProximo() {
    final proximo = _viewModel.proximoTopico;
    if (proximo != null) {
      _navegarParaTopico(proximo.aula.id, proximo.topico.id);
    }
  }

  void _navegarParaQuiz() {
    context.pushNamed(
      EadRoutes.quiz,
      pathParameters: {
        'cursoId': widget.cursoId,
        'aulaId': widget.aulaId,
        'topicoId': widget.topicoId,
      },
    );
  }

  void _navegarParaDiscussoes() {
    final cursoTitulo = _viewModel.curso?.titulo ?? '';
    context.pushNamed(
      EadRoutes.discussoesCurso,
      pathParameters: {'cursoId': widget.cursoId},
      queryParameters: {'cursoTitulo': cursoTitulo},
    );
  }

  Future<void> _toggleCompleto() async {
    final usuarioId = _usuarioId;
    if (usuarioId == null) {
      _mostrarSnackBar('Faca login para marcar como concluido');
      return;
    }

    final sucesso = await _viewModel.toggleCompleto(usuarioId);
    if (!sucesso) {
      _mostrarSnackBar('Erro ao atualizar status');
    }
  }

  void _mostrarSnackBar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        body: Consumer<PlayerTopicoViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              final appTheme = AppTheme.of(context);
              return Center(
                child: CircularProgressIndicator(
                  color: appTheme.primary,
                ),
              );
            }

            if (viewModel.error != null) {
              return _buildError(viewModel);
            }

            if (viewModel.topico == null) {
              return _buildNaoEncontrado();
            }

            return _buildConteudo(viewModel);
          },
        ),
      ),
    );
  }

  Widget _buildError(PlayerTopicoViewModel viewModel) {
    final appTheme = AppTheme.of(context);

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: appTheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                viewModel.error!,
                textAlign: TextAlign.center,
                style: appTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: appTheme.primary,
                      side: BorderSide(color: appTheme.primary),
                    ),
                    child: const Text('Voltar'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _carregarDados,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar novamente'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.primary,
                      foregroundColor: appTheme.info,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNaoEncontrado() {
    final appTheme = AppTheme.of(context);

    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 64,
              color: appTheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Topico nao encontrado',
              style: appTheme.bodyLarge,
            ),
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
      ),
    );
  }

  Widget _buildConteudo(PlayerTopicoViewModel viewModel) {
    final topico = viewModel.topico!;

    return Column(
      children: [
        // Header
        TopicoHeaderWidget(
          tituloAula: viewModel.tituloAula,
          tituloTopico: viewModel.tituloTopico,
          tipo: topico.tipo,
          isCompleto: viewModel.isTopicoCompleto,
          textoProgresso: viewModel.textoProgresso,
          onBack: () => context.pop(),
          onDiscussoes: _navegarParaDiscussoes,
        ),

        // Conteudo principal
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Conteudo do topico (video/audio/texto)
                TopicoContentWidget(
                  topico: topico,
                  cursoTitulo: viewModel.curso?.titulo,
                  cursoImagem: viewModel.curso?.imagemCapa,
                  onIniciarQuiz: viewModel.isInscrito ? _navegarParaQuiz : null,
                ),

                // Card de conclusao (se inscrito e nao for quiz)
                if (viewModel.isInscrito && !viewModel.isQuiz)
                  CompletionCard(
                    isCompleto: viewModel.isTopicoCompleto,
                    isLoading: viewModel.isMarcandoCompleto,
                    onToggle: _toggleCompleto,
                    progressoCurso: viewModel.progressoCurso,
                  ),

                const SizedBox(height: 80), // Espaco para navegacao
              ],
            ),
          ),
        ),

        // Navegacao entre topicos
        NavegacaoTopicosWidget(
          hasAnterior: viewModel.hasAnterior,
          hasProximo: viewModel.hasProximo,
          onAnterior: _irParaAnterior,
          onProximo: _irParaProximo,
          textoProgresso: viewModel.textoProgresso,
        ),
      ],
    );
  }
}
