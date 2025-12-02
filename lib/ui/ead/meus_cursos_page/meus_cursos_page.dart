import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:medita_b_k/data/repositories/auth_repository.dart';
import 'package:medita_b_k/routing/ead_routes.dart';
import '../../core/theme/app_theme.dart';
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

  Future<void> _navegarParaDetalhes(String cursoId) async {
    await context.pushNamed(
      EadRoutes.cursoDetalhes,
      pathParameters: {'cursoId': cursoId},
    );
    // Recarrega os dados ao voltar para atualizar o progresso
    await _recarregarDados();
  }

  Future<void> _navegarParaCatalogo() async {
    await context.pushNamed(EadRoutes.catalogoCursos);
    // Recarrega os dados ao voltar caso tenha se inscrito em novo curso
    await _recarregarDados();
  }

  Future<void> _continuarCurso(String cursoId, String? aulaId, String? topicoId) async {
    if (aulaId != null && topicoId != null) {
      await context.pushNamed(
        EadRoutes.playerTopico,
        pathParameters: {
          'cursoId': cursoId,
          'aulaId': aulaId,
          'topicoId': topicoId,
        },
      );
      // Recarrega os dados ao voltar para atualizar o progresso
      await _recarregarDados();
    } else {
      await _navegarParaDetalhes(cursoId);
    }
  }

  Future<void> _recarregarDados() async {
    final usuarioId = _usuarioId;
    if (usuarioId != null) {
      await _viewModel.refresh(usuarioId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    if (_usuarioId == null) {
      return _buildNaoLogado();
    }

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: appTheme.primaryBackground,
        appBar: AppBar(
          backgroundColor: appTheme.primary,
          foregroundColor: appTheme.info,
          elevation: 2.0,
          title: Text(
            'Meus Cursos',
            style: appTheme.headlineMedium.copyWith(
              color: appTheme.info,
            ),
          ),
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
              return Center(
                child: CircularProgressIndicator(color: appTheme.primary),
              );
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
    final appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: appTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: appTheme.primary,
        foregroundColor: appTheme.info,
        elevation: 2.0,
        title: Text(
          'Meus Cursos',
          style: appTheme.headlineMedium.copyWith(
            color: appTheme.info,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 80,
                color: appTheme.primary.withOpacity(0.3),
              ),
              const SizedBox(height: 24),
              Text(
                'Faca login para ver seus cursos',
                textAlign: TextAlign.center,
                style: appTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Acesse sua conta para acompanhar seu progresso nos cursos',
                textAlign: TextAlign.center,
                style: appTheme.bodyMedium.copyWith(
                  color: appTheme.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError(MeusCursosViewModel viewModel) {
    final appTheme = AppTheme.of(context);

    return Center(
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
            ElevatedButton.icon(
              onPressed: _carregarDados,
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.primary,
                foregroundColor: appTheme.info,
              ),
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
