import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:provider/provider.dart';
import 'view_model/tc_music_picker_view_model.dart';
import 'widgets/tc_music_tile.dart';
import 'widgets/tc_category_chips.dart';

/// Página de seleção de música para o alarme
///
/// Permite:
/// - Buscar músicas por título/artista
/// - Filtrar por categoria
/// - Ouvir preview de qualquer música
/// - Selecionar música e retornar para o formulário
class TcMusicPickerPage extends StatefulWidget {
  const TcMusicPickerPage({super.key});

  static String routeName = 'TcMusicPickerPage';
  static String routePath = 'traffic-control/music-picker';

  @override
  State<TcMusicPickerPage> createState() => _TcMusicPickerPageState();
}

class _TcMusicPickerPageState extends State<TcMusicPickerPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'TcMusicPickerPage'});

    SchedulerBinding.instance.addPostFrameCallback((_) {
      // Carrega músicas se ainda não carregou
      final viewModel = context.read<TcMusicPickerViewModel>();
      if (viewModel.musics.isEmpty) {
        viewModel.refresh();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    // Para o preview ao sair (com try-catch para evitar erro se widget já desativado)
    try {
      context.read<TcMusicPickerViewModel>().stopPreview();
    } catch (e) {
      // Widget já foi desativado, ignora
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TcMusicPickerViewModel>();

    return WillPopScope(
      onWillPop: () async {
        await viewModel.stopPreview();
        return true;
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).info,
              size: 30.0,
            ),
            onPressed: () async {
              await viewModel.stopPreview();
              context.pop();
            },
          ),
          title: Text(
            'Selecionar Música',
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                  color: FlutterFlowTheme.of(context).info,
                  letterSpacing: 0.0,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).titleLargeIsCustom,
                ),
          ),
          actions: [
            // Botão limpar filtros
            if (viewModel.searchQuery.isNotEmpty ||
                viewModel.selectedCategory != null)
              IconButton(
                icon: Icon(
                  Icons.clear_all,
                  color: FlutterFlowTheme.of(context).info,
                ),
                onPressed: () {
                  searchController.clear();
                  viewModel.clearFilters();
                },
                tooltip: 'Limpar filtros',
              ),
          ],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: _buildBody(context, viewModel),
        bottomNavigationBar: _buildBottomBar(context, viewModel),
      ),
    );
  }

  Widget _buildBody(BuildContext context, TcMusicPickerViewModel viewModel) {
    return Column(
      children: [
        // Campo de busca
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Buscar por título ou artista...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        viewModel.search('');
                      },
                    )
                  : null,
            ),
            onChanged: viewModel.search,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                  letterSpacing: 0.0,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                ),
          ),
        ),

        // Chips de categoria
        TcCategoryChips(
          categories: viewModel.categories,
          selectedCategory: viewModel.selectedCategory,
          onCategorySelected: viewModel.filterByCategory,
        ),

        // Loading state
        if (viewModel.isLoading)
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        // Lista de músicas
        else if (viewModel.musics.isEmpty)
          _buildEmptyState(context)
        else
          Expanded(
            child: RefreshIndicator(
              onRefresh: viewModel.refresh,
              color: FlutterFlowTheme.of(context).primary,
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 16.0),
                itemCount: viewModel.musics.length,
                itemBuilder: (context, index) {
                  final music = viewModel.musics[index];
                  final isSelected = viewModel.selectedMusic?.id == music.id;
                  final isPlaying =
                      viewModel.previewingMusicId == music.id &&
                          viewModel.isPlaying;
                  final isLoading =
                      viewModel.previewingMusicId == music.id &&
                          viewModel.isLoadingPreview;

                  return TcMusicTile(
                    music: music,
                    isSelected: isSelected,
                    isPlaying: isPlaying,
                    isLoading: isLoading,
                    progress: viewModel.previewingMusicId == music.id
                        ? viewModel.previewProgress
                        : 0.0,
                    onTap: () => viewModel.selectMusic(music),
                    onPlayPause: () => viewModel.togglePreview(music),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.music_off,
                size: 64.0,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Nenhuma música encontrada',
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily:
                          FlutterFlowTheme.of(context).titleMediumFamily,
                      color: FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).titleMediumIsCustom,
                    ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Tente buscar com outros termos ou limpe os filtros',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily:
                          FlutterFlowTheme.of(context).bodyMediumFamily,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(
      BuildContext context, TcMusicPickerViewModel viewModel) {
    final hasSelection = viewModel.selectedMusic != null;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Música selecionada
            if (hasSelection) ...[
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selecionado:',
                          style:
                              FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodySmallFamily,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodySmallIsCustom,
                                  ),
                        ),
                        Text(
                          viewModel.selectedMusic!.title,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color:
                                    FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
            ],

            // Botão confirmar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: hasSelection
                    ? () async {
                        await viewModel.stopPreview();
                        if (context.mounted) {
                          context.pop(viewModel.confirmSelection());
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 2.0,
                ),
                child: Text(
                  hasSelection ? 'Confirmar Seleção' : 'Selecione uma Música',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).titleMediumFamily,
                        color: Colors.white,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).titleMediumIsCustom,
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
