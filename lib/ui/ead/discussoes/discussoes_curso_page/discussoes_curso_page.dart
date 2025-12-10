import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:medita_b_k/data/repositories/auth_repository.dart';
import 'package:medita_b_k/routing/ead_routes.dart';
import 'package:medita_b_k/ui/core/theme/app_theme.dart';
import 'view_model/discussoes_curso_view_model.dart';
import 'widgets/discussao_card.dart';

/// Página de discussões do curso
class DiscussoesCursoPage extends StatefulWidget {
  final String cursoId;
  final String cursoTitulo;

  const DiscussoesCursoPage({
    super.key,
    required this.cursoId,
    required this.cursoTitulo,
  });

  static const String routeName = EadRoutes.discussoesCurso;
  static const String routePath = EadRoutes.discussoesCursoPath;

  @override
  State<DiscussoesCursoPage> createState() => _DiscussoesCursoPageState();
}

class _DiscussoesCursoPageState extends State<DiscussoesCursoPage> {
  late final DiscussoesCursoViewModel _viewModel;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = DiscussoesCursoViewModel(
      cursoId: widget.cursoId,
      cursoTitulo: widget.cursoTitulo,
    );
    _carregarDados();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String? get _usuarioId {
    final uid = context.read<AuthRepository>().currentUserUid;
    return uid.isNotEmpty ? uid : null;
  }

  Future<void> _carregarDados() async {
    final usuarioId = _usuarioId;
    if (usuarioId != null) {
      _viewModel.iniciarStream(usuarioId);
    }
  }

  void _onNovaDiscussao() {
    context.pushNamed(
      EadRoutes.novaDiscussao,
      pathParameters: {'cursoId': widget.cursoId},
      extra: {'cursoTitulo': widget.cursoTitulo},
    ).then((result) {
      if (result == true) {
        // Discussão criada com sucesso - stream já atualiza automaticamente
      }
    });
  }

  void _onDiscussaoTap(String discussaoId) {
    context.pushNamed(
      EadRoutes.discussaoDetail,
      pathParameters: {'discussaoId': discussaoId},
    );
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return ChangeNotifierProvider<DiscussoesCursoViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appTheme.primary,
          foregroundColor: appTheme.info,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Perguntas e Respostas',
                style: TextStyle(color: appTheme.info),
              ),
              Text(
                widget.cursoTitulo,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: appTheme.info.withOpacity(0.8),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _showSearchDialog(),
            ),
          ],
        ),
        body: Consumer<DiscussoesCursoViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading && !viewModel.hasDiscussoes) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.error != null && !viewModel.hasDiscussoes) {
              return _buildErrorState(viewModel);
            }

            return Column(
              children: [
                // Filtros
                _buildFilters(viewModel),

                // Busca ativa
                if (viewModel.termoBusca.isNotEmpty)
                  _buildSearchChip(viewModel),

                // Lista de discussões
                Expanded(
                  child: _buildDiscussoesList(viewModel),
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _onNovaDiscussao,
          backgroundColor: appTheme.primary,
          foregroundColor: appTheme.info,
          icon: const Icon(Icons.add),
          label: const Text('Nova Pergunta'),
        ),
      ),
    );
  }

  Widget _buildFilters(DiscussoesCursoViewModel viewModel) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: FiltroDiscussoes.values.map((filtro) {
          final isSelected = viewModel.filtroAtual == filtro;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(_getFiltroLabel(filtro, viewModel)),
              selected: isSelected,
              onSelected: (_) {
                final usuarioId = _usuarioId;
                if (usuarioId != null) {
                  viewModel.setFiltro(filtro, usuarioId);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getFiltroLabel(FiltroDiscussoes filtro, DiscussoesCursoViewModel viewModel) {
    switch (filtro) {
      case FiltroDiscussoes.todas:
        return 'Todas (${viewModel.totalDiscussoes})';
      case FiltroDiscussoes.minhas:
        return 'Minhas';
      case FiltroDiscussoes.abertas:
        return 'Abertas (${viewModel.totalAbertas})';
      case FiltroDiscussoes.fechadas:
        return 'Fechadas (${viewModel.totalFechadas})';
    }
  }

  Widget _buildSearchChip(DiscussoesCursoViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Chip(
              avatar: const Icon(Icons.search, size: 18),
              label: Text('Buscando: "${viewModel.termoBusca}"'),
              onDeleted: () => viewModel.limparBusca(),
              deleteIcon: const Icon(Icons.close, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscussoesList(DiscussoesCursoViewModel viewModel) {
    final discussoes = viewModel.discussoesFiltradas;
    final usuarioId = _usuarioId ?? '';

    if (discussoes.isEmpty) {
      return _buildEmptyState(viewModel);
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (_usuarioId != null) {
          await viewModel.refresh(_usuarioId!);
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80), // Espaço para FAB
        itemCount: discussoes.length,
        itemBuilder: (context, index) {
          final discussao = discussoes[index];
          return DiscussaoCard(
            discussao: discussao,
            usuarioId: usuarioId,
            onTap: () => _onDiscussaoTap(discussao.id),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(DiscussoesCursoViewModel viewModel) {
    final appTheme = AppTheme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.forum_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              viewModel.mensagemListaVazia,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            if (viewModel.termoBusca.isEmpty &&
                viewModel.filtroAtual == FiltroDiscussoes.todas)
              ElevatedButton.icon(
                onPressed: _onNovaDiscussao,
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.primary,
                  foregroundColor: appTheme.info,
                ),
                icon: const Icon(Icons.add),
                label: const Text('Fazer Pergunta'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(DiscussoesCursoViewModel viewModel) {
    final appTheme = AppTheme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            viewModel.error ?? 'Erro desconhecido',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_usuarioId != null) {
                viewModel.refresh(_usuarioId!);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appTheme.primary,
              foregroundColor: appTheme.info,
            ),
            child: const Text('Tentar Novamente'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    final appTheme = AppTheme.of(context);

    showDialog(
      context: context,
      builder: (context) {
        _searchController.text = _viewModel.termoBusca;
        return AlertDialog(
          title: const Text('Buscar Discussões'),
          content: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Digite sua busca...',
              prefixIcon: Icon(Icons.search),
            ),
            onSubmitted: (value) {
              _viewModel.setBusca(value);
              Navigator.of(context).pop();
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                _viewModel.limparBusca();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: appTheme.primary),
              child: const Text('Limpar'),
            ),
            ElevatedButton(
              onPressed: () {
                _viewModel.setBusca(_searchController.text);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.primary,
                foregroundColor: appTheme.info,
              ),
              child: const Text('Buscar'),
            ),
          ],
        );
      },
    );
  }
}
