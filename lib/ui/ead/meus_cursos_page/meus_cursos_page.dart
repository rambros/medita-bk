import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:medita_b_k/data/repositories/auth_repository.dart';
import 'package:medita_b_k/routing/ead_routes.dart';
import 'view_model/meus_cursos_view_model.dart';
import 'widgets/meu_curso_card.dart';
import 'widgets/resumo_progresso_widget.dart';

/// Pagina que lista os cursos do usuario
class MeusCursosPage extends StatefulWidget {
  const MeusCursosPage({super.key});

  static const String routeName = EadRoutes.meusCursos;
  static const String routePath = EadRoutes.meusCursosPath;

  @override
  State<MeusCursosPage> createState() => _MeusCursosPageState();
}

class _MeusCursosPageState extends State<MeusCursosPage> {
  late final MeusCursosViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MeusCursosViewModel();
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
    final usuarioId = _usuarioId;
    if (usuarioId != null) {
      await _viewModel.carregarMeusCursos(usuarioId);
    }
  }

  void _navegarParaDetalhes(String cursoId) {
    context.pushNamed(
      EadRoutes.cursoDetalhes,
      pathParameters: {'cursoId': cursoId},
    );
  }

  void _navegarParaCatalogo() {
    context.pushNamed(EadRoutes.catalogoCursos);
  }

  void _continuarCurso(String cursoId, String? aulaId, String? topicoId) {
    if (aulaId != null && topicoId != null) {
      context.pushNamed(
        EadRoutes.playerTopico,
        pathParameters: {
          'cursoId': cursoId,
          'aulaId': aulaId,
          'topicoId': topicoId,
        },
      );
    } else {
      _navegarParaDetalhes(cursoId);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_usuarioId == null) {
      return _buildNaoLogado();
    }

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Meus Cursos'),
          actions: [
            IconButton(
              icon: const Icon(Icons.explore),
              tooltip: 'Explorar cursos',
              onPressed: _navegarParaCatalogo,
            ),
          ],
        ),
        body: Consumer<MeusCursosViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.error != null) {
              return _buildError(viewModel);
            }

            if (!viewModel.hasCursos) {
              return _buildSemCursos();
            }

            return RefreshIndicator(
              onRefresh: () => viewModel.refresh(_usuarioId!),
              child: _buildConteudo(viewModel),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNaoLogado() {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Cursos')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 80,
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 24),
              Text(
                'Faca login para ver seus cursos',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Acesse sua conta para acompanhar seu progresso nos cursos',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError(MeusCursosViewModel viewModel) {
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

  Widget _buildSemCursos() {
    return EmptyCursosWidget(
      mensagem: 'Voce ainda nao esta inscrito em nenhum curso.\nExplore nosso catalogo!',
      onExplorar: _navegarParaCatalogo,
    );
  }

  Widget _buildConteudo(MeusCursosViewModel viewModel) {
    return CustomScrollView(
      slivers: [
        // Resumo de progresso
        SliverToBoxAdapter(
          child: ResumoProgressoWidget(
            totalCursos: viewModel.inscricoes.length,
            emAndamento: viewModel.totalEmAndamento,
            concluidos: viewModel.totalConcluidos,
          ),
        ),

        // Filtros
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: FiltroChipsWidget(
              filtroAtual: viewModel.filtroAtual,
              onFiltroChanged: viewModel.setFiltro,
              totalEmAndamento: viewModel.totalEmAndamento,
              totalConcluidos: viewModel.totalConcluidos,
              totalPausados: viewModel.totalPausados,
            ),
          ),
        ),

        // Lista de cursos ou estado vazio
        if (viewModel.listaVazia)
          SliverFillRemaining(
            child: EmptyCursosWidget(
              mensagem: viewModel.mensagemListaVazia,
              onExplorar: viewModel.filtroAtual != FiltroMeusCursos.todos
                  ? null
                  : _navegarParaCatalogo,
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final inscricao = viewModel.cursosRecentes[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: MeuCursoCard(
                      inscricao: inscricao,
                      onTap: () => _navegarParaDetalhes(inscricao.cursoId),
                      onContinuar: () => _continuarCurso(
                        inscricao.cursoId,
                        inscricao.progresso.ultimaAulaId,
                        inscricao.progresso.ultimoTopicoId,
                      ),
                    ),
                  );
                },
                childCount: viewModel.cursosRecentes.length,
              ),
            ),
          ),

        // Espaco no final
        const SliverToBoxAdapter(
          child: SizedBox(height: 16),
        ),
      ],
    );
  }
}
