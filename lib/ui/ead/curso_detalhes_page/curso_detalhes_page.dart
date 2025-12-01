import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../routing/ead_routes.dart';
import '../../../ui/core/widgets/html_display_widget.dart';
import 'view_model/curso_detalhes_view_model.dart';
import 'widgets/curso_info_header.dart';
import 'widgets/curriculo_section.dart';
import 'widgets/objetivos_section.dart';

/// Página de detalhes do curso
class CursoDetalhesPage extends StatefulWidget {
  const CursoDetalhesPage({
    super.key,
    required this.cursoId,
  });

  final String cursoId;

  static const String routeName = EadRoutes.cursoDetalhes;
  static const String routePath = EadRoutes.cursoDetalhesPath;

  @override
  State<CursoDetalhesPage> createState() => _CursoDetalhesPageState();
}

class _CursoDetalhesPageState extends State<CursoDetalhesPage> {
  late final CursoDetalhesViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CursoDetalhesViewModel(cursoId: widget.cursoId);
    _carregarDados();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _carregarDados() async {
    final authRepo = context.read<AuthRepository>();
    final usuarioId = authRepo.currentUserUid.isEmpty ? null : authRepo.currentUserUid;
    await _viewModel.carregarDados(usuarioId: usuarioId);
  }

  Future<void> _inscrever() async {
    final authRepo = context.read<AuthRepository>();
    final user = authRepo.currentUser;
    if (user == null || authRepo.currentUserUid.isEmpty) {
      _mostrarSnackBar('Faça login para se inscrever');
      return;
    }

    final sucesso = await _viewModel.inscrever(
      usuarioId: authRepo.currentUserUid,
      usuarioNome: user.displayName.isEmpty ? 'Usuário' : user.displayName,
      usuarioEmail: user.email,
      usuarioFoto: user.photoUrl,
    );

    if (sucesso) {
      _mostrarSnackBar('Inscrição realizada com sucesso!');
    } else {
      _mostrarSnackBar('Erro ao realizar inscrição');
    }
  }

  void _navegarParaTopico(String aulaId, String topicoId) {
    context.pushNamed(
      EadRoutes.playerTopico,
      pathParameters: {
        'cursoId': widget.cursoId,
        'aulaId': aulaId,
        'topicoId': topicoId,
      },
    );
  }

  void _continuarCurso() {
    final proximo = _viewModel.proximoTopico;
    if (proximo != null) {
      _navegarParaTopico(proximo.aulaId, proximo.topicoId);
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
        body: Consumer<CursoDetalhesViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.error != null) {
              return _buildError(viewModel);
            }

            if (viewModel.curso == null) {
              return _buildNaoEncontrado();
            }

            return _buildConteudo(viewModel);
          },
        ),
        bottomNavigationBar: Consumer<CursoDetalhesViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading || viewModel.curso == null) {
              return const SizedBox.shrink();
            }
            return _buildBottomBar(viewModel);
          },
        ),
      ),
    );
  }

  Widget _buildError(CursoDetalhesViewModel viewModel) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(null),
        SliverFillRemaining(
          child: Center(
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
          ),
        ),
      ],
    );
  }

  Widget _buildNaoEncontrado() {
    return CustomScrollView(
      slivers: [
        _buildAppBar(null),
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.school_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                const Text('Curso não encontrado'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Voltar'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConteudo(CursoDetalhesViewModel viewModel) {
    final curso = viewModel.curso!;

    return RefreshIndicator(
      onRefresh: () {
        final authRepo = context.read<AuthRepository>();
        final usuarioId = authRepo.currentUserUid.isEmpty ? null : authRepo.currentUserUid;
        return viewModel.refresh(usuarioId: usuarioId);
      },
      child: CustomScrollView(
        slivers: [
          // AppBar
          _buildAppBar(curso.titulo),

          // Conteúdo
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header com info do curso
                CursoInfoHeader(
                  curso: curso,
                  inscricao: viewModel.inscricao,
                ),

                const Divider(),

                // Objetivos
                if (curso.objetivos.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ObjetivosSection(objetivos: curso.objetivos),
                  const SizedBox(height: 24),
                  const Divider(),
                ],

                // Requisitos
                if (curso.requisitos.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  RequisitosSection(requisitos: curso.requisitos),
                  const SizedBox(height: 24),
                  const Divider(),
                ],

                // Descrição completa
                if (curso.descricao?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sobre o Curso',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 12),
                        HtmlDisplayWidget(description: curso.descricao!),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                ],

                // Currículo
                const SizedBox(height: 16),
                CurriculoSection(
                  aulas: viewModel.aulas,
                  aulasExpandidas: viewModel.aulasExpandidas,
                  onToggleAula: viewModel.toggleAulaExpandida,
                  onTopicoTap: (aula, topico) {
                    if (viewModel.isInscrito) {
                      _navegarParaTopico(aula.id, topico.id);
                    } else {
                      _mostrarSnackBar('Inscreva-se para acessar o conteúdo');
                    }
                  },
                  isTopicoCompleto: viewModel.isTopicoCompleto,
                  isAulaCompleta: viewModel.isAulaCompleta,
                  isInscrito: viewModel.isInscrito,
                ),

                // Espaço para o bottom bar
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(String? titulo) {
    return SliverAppBar(
      floating: true,
      title: titulo != null ? Text(titulo) : null,
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            // TODO: Implementar compartilhamento
          },
        ),
      ],
    );
  }

  Widget _buildBottomBar(CursoDetalhesViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
            // Info de progresso
            if (viewModel.isInscrito) ...[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${viewModel.topicosCompletos}/${viewModel.totalTopicos} tópicos',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: viewModel.progresso / 100,
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
            ],

            // Botão principal
            Expanded(
              flex: viewModel.isInscrito ? 0 : 1,
              child: SizedBox(
                width: viewModel.isInscrito ? null : double.infinity,
                child: ElevatedButton.icon(
                  onPressed: viewModel.isInscrevendo ? null : (viewModel.isInscrito ? _continuarCurso : _inscrever),
                  icon: viewModel.isInscrevendo
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(viewModel.iconeBotaoAcao),
                  label: Text(viewModel.textoBotaoAcao),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
