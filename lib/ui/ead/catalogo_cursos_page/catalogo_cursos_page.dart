import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app_state.dart';
import '../../../routing/ead_routes.dart';
import 'view_model/catalogo_cursos_view_model.dart';
import 'widgets/curso_card.dart';

/// Página de catálogo de cursos disponíveis
class CatalogoCursosPage extends StatefulWidget {
  const CatalogoCursosPage({super.key});

  static const String routeName = EadRoutes.catalogoCursos;
  static const String routePath = EadRoutes.catalogoCursosPath;

  @override
  State<CatalogoCursosPage> createState() => _CatalogoCursosPageState();
}

class _CatalogoCursosPageState extends State<CatalogoCursosPage> {
  late final CatalogoCursosViewModel _viewModel;
  final _searchController = TextEditingController();
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    _viewModel = CatalogoCursosViewModel();
    _carregarDados();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _carregarDados() async {
    final usuarioId = FFAppState().currentUser?.uid;
    await _viewModel.carregarCursos(usuarioId: usuarioId);
  }

  void _navegarParaDetalhes(String cursoId) {
    context.pushNamed(
      EadRoutes.cursoDetalhes,
      pathParameters: {'cursoId': cursoId},
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Consumer<CatalogoCursosViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.error != null) {
              return _buildError(viewModel);
            }

            if (viewModel.cursosFiltrados.isEmpty) {
              return _buildEmpty(viewModel);
            }

            return RefreshIndicator(
              onRefresh: () => viewModel.refresh(
                usuarioId: FFAppState().currentUser?.uid,
              ),
              child: _buildLista(viewModel),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: _showSearch ? _buildSearchField() : const Text('Cursos'),
      actions: [
        IconButton(
          icon: Icon(_showSearch ? Icons.close : Icons.search),
          onPressed: () {
            setState(() {
              _showSearch = !_showSearch;
              if (!_showSearch) {
                _searchController.clear();
                _viewModel.limparBusca();
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Buscar cursos...',
        border: InputBorder.none,
      ),
      onChanged: _viewModel.buscar,
    );
  }

  Widget _buildError(CatalogoCursosViewModel viewModel) {
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

  Widget _buildEmpty(CatalogoCursosViewModel viewModel) {
    final isSearching = viewModel.searchQuery.isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching ? Icons.search_off : Icons.school_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              isSearching
                  ? 'Nenhum curso encontrado para "${viewModel.searchQuery}"'
                  : 'Nenhum curso disponível no momento',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (isSearching) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  _searchController.clear();
                  viewModel.limparBusca();
                },
                child: const Text('Limpar busca'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLista(CatalogoCursosViewModel viewModel) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.cursosFiltrados.length,
      itemBuilder: (context, index) {
        final curso = viewModel.cursosFiltrados[index];
        final inscricao = viewModel.getInscricao(curso.id);

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CursoCard(
            curso: curso,
            inscricao: inscricao,
            onTap: () => _navegarParaDetalhes(curso.id),
          ),
        );
      },
    );
  }
}
