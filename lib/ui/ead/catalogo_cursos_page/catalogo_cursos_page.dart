import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:medita_bk/data/repositories/auth_repository.dart';
import 'package:medita_bk/routing/ead_routes.dart';
import 'package:medita_bk/ui/core/theme/app_theme.dart';
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
    final authRepo = context.read<AuthRepository>();
    final usuarioId = authRepo.currentUserUid.isEmpty ? null : authRepo.currentUserUid;
    await _viewModel.carregarCursos(usuarioId: usuarioId);
  }

  Future<void> _navegarParaDetalhes(String cursoId) async {
    await context.pushNamed(
      EadRoutes.cursoDetalhes,
      pathParameters: {'cursoId': cursoId},
    );
    // Recarrega os dados ao voltar para atualizar o progresso
    await _recarregarDados();
  }

  Future<void> _recarregarDados() async {
    final authRepo = context.read<AuthRepository>();
    final usuarioId = authRepo.currentUserUid.isEmpty ? null : authRepo.currentUserUid;
    await _viewModel.refresh(usuarioId: usuarioId);
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: appTheme.primaryBackground,
        appBar: _buildAppBar(appTheme),
        body: Consumer<CatalogoCursosViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Center(
                child: CircularProgressIndicator(color: appTheme.primary),
              );
            }

            if (viewModel.error != null) {
              return _buildError(viewModel);
            }

            if (viewModel.cursosFiltrados.isEmpty) {
              return _buildEmpty(viewModel);
            }

            return RefreshIndicator(
              onRefresh: () {
                final authRepo = context.read<AuthRepository>();
                final usuarioId = authRepo.currentUserUid.isEmpty ? null : authRepo.currentUserUid;
                return viewModel.refresh(usuarioId: usuarioId);
              },
              child: _buildLista(viewModel),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppTheme appTheme) {
    return AppBar(
      backgroundColor: appTheme.primary,
      foregroundColor: appTheme.info,
      elevation: 2.0,
      title: _showSearch
          ? _buildSearchField(appTheme)
          : Text(
              'Cursos',
              style: appTheme.headlineMedium.copyWith(
                color: appTheme.info,
              ),
            ),
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

  Widget _buildSearchField(AppTheme appTheme) {
    return TextField(
      controller: _searchController,
      autofocus: true,
      style: appTheme.bodyLarge.copyWith(color: appTheme.info),
      cursorColor: appTheme.info,
      decoration: InputDecoration(
        hintText: 'Buscar cursos...',
        hintStyle: appTheme.bodyLarge.copyWith(color: appTheme.info.withOpacity(0.7)),
        border: InputBorder.none,
      ),
      onChanged: _viewModel.buscar,
    );
  }

  Widget _buildError(CatalogoCursosViewModel viewModel) {
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

  Widget _buildEmpty(CatalogoCursosViewModel viewModel) {
    final appTheme = AppTheme.of(context);
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
              color: appTheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              isSearching
                  ? 'Nenhum curso encontrado para "${viewModel.searchQuery}"'
                  : 'Nenhum curso disponível no momento',
              textAlign: TextAlign.center,
              style: appTheme.bodyLarge,
            ),
            if (isSearching) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  _searchController.clear();
                  viewModel.limparBusca();
                },
                style: TextButton.styleFrom(foregroundColor: appTheme.primary),
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
            totalTopicosReal: viewModel.getTotalTopicosReal(curso.id),
            onTap: () => _navegarParaDetalhes(curso.id),
          ),
        );
      },
    );
  }
}
