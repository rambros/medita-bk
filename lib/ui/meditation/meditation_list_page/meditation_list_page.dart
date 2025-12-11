import 'package:medita_bk/data/models/firebase/meditation_model.dart';
import 'package:medita_bk/ui/meditation/widgets/filter_meditations_dialog.dart';
import 'package:medita_bk/ui/meditation/widgets/meditation_card_widget.dart';
import 'package:medita_bk/ui/meditation/widgets/sort_meditations_dialog.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'view_model/meditation_list_view_model.dart';

class MeditationListPage extends StatefulWidget {
  const MeditationListPage({super.key});

  static String routeName = 'meditationListPage';
  static String routePath = 'meditationListPage';

  @override
  State<MeditationListPage> createState() => _MeditationListPageState();
}

class _MeditationListPageState extends State<MeditationListPage> {
  late MeditationListViewModel _viewModel;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<MeditationListViewModel>(context, listen: false);
    _viewModel.initState();

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'meditationListPage'});

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    // ViewModel disposal is handled by the Provider
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MeditationListViewModel>(
      builder: (context, viewModel, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: responsiveVisibility(
              context: context,
              tabletLandscape: false,
              desktop: false,
            )
                ? AppBar(
                    backgroundColor: FlutterFlowTheme.of(context).primary,
                    automaticallyImplyLeading: false,
                    actions: const [],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Align(
                        alignment: const AlignmentDirectional(0.0, 1.0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FlutterFlowIconButton(
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
                                  context.pop();
                                },
                              ),
                              Text(
                                'Meditações',
                                style: FlutterFlowTheme.of(context).titleLarge.override(
                                      fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                                      color: FlutterFlowTheme.of(context).info,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
                                    ),
                              ),
                              FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 30.0,
                                borderWidth: 1.0,
                                buttonSize: 60.0,
                                icon: Icon(
                                  viewModel.isFavourites ? Icons.favorite : Icons.favorite_border,
                                  color: FlutterFlowTheme.of(context).info,
                                  size: 26.0,
                                ),
                                onPressed: () async {
                                  await viewModel.toggleFavorites();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    centerTitle: true,
                    elevation: 2.0,
                  )
                : null,
            body: SafeArea(
              top: true,
              child: Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: MediaQuery.sizeOf(context).height * 0.94,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 4.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FFButtonWidget(
                                onPressed: () async {
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    enableDrag: false,
                                    context: context,
                                    builder: (context) {
                                      return WebViewAware(
                                        child: GestureDetector(
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            FocusManager.instance.primaryFocus?.unfocus();
                                          },
                                          child: Padding(
                                            padding: MediaQuery.viewInsetsOf(context),
                                            child: const SortMeditationsDialogWidget(),
                                          ),
                                        ),
                                      );
                                    },
                                  ).then((value) {
                                    if (value != null) {
                                      viewModel.applySort(value);
                                    }
                                  });
                                },
                                text: 'Ordenar',
                                options: FFButtonOptions(
                                  height: 36.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                  iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                        fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                      ),
                                  elevation: 3.0,
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              FFButtonWidget(
                                onPressed: () async {
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    enableDrag: false,
                                    context: context,
                                    builder: (context) {
                                      return WebViewAware(
                                        child: GestureDetector(
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            FocusManager.instance.primaryFocus?.unfocus();
                                          },
                                          child: Padding(
                                            padding: MediaQuery.viewInsetsOf(context),
                                            child: const FilterMeditationsDialogWidget(),
                                          ),
                                        ),
                                      );
                                    },
                                  ).then((value) {
                                    if (value != null) {
                                      viewModel.applyFilter(value);
                                    }
                                  });
                                },
                                text: 'Filtrar',
                                options: FFButtonOptions(
                                  height: 36.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                  iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                        fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                      ),
                                  elevation: 3.0,
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              FFButtonWidget(
                                onPressed: () async {
                                  viewModel.toggleSearching();
                                },
                                text: 'Pesquisar',
                                options: FFButtonOptions(
                                  height: 36.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                  iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                        fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                      ),
                                  elevation: 3.0,
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (viewModel.isSearching)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: viewModel.textSearchFieldTextController,
                                    focusNode: viewModel.textSearchFieldFocusNode,
                                    onFieldSubmitted: (_) async {
                                      await viewModel.search(viewModel.textSearchFieldTextController!.text);
                                    },
                                    autofocus: true,
                                    textInputAction: TextInputAction.search,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: 'Digite o texto para pesquisa',
                                      hintStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                                            fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context).primary,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(24.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context).primary,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(24.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(24.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(24.0),
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                                          fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                        ),
                                    validator: viewModel.textSearchFieldTextControllerValidator?.asValidator(context),
                                  ),
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    viewModel.cancelSearching();
                                  },
                                  child: Icon(
                                    Icons.cancel_outlined,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 38.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        _buildContent(context, viewModel),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, MeditationListViewModel viewModel) {
    if (viewModel.isSearching) {
      return _buildList(context, viewModel.algoliaSearchResults, 'Resultados da pesquisa');
    } else if (viewModel.isFiltered) {
      return _buildList(context, viewModel.listFiltered, 'Meditações com filtro = ${viewModel.listaCategorias}');
    } else if (viewModel.isOrdered) {
      List<MeditationModel>? list;
      String title = 'Meditações';
      if (viewModel.orderString == 'orderByNumPlayed') {
        list = viewModel.listNumPlayed;
        title = 'Meditações mais reproduzidas';
      } else if (viewModel.orderString == 'orderByNewest') {
        list = viewModel.listNewest;
        title = 'Meditações mais recentes';
      } else if (viewModel.orderString == 'orderByFavourites') {
        list = viewModel.listFavourites;
        title = 'Meditações mais favoritas';
      } else if (viewModel.orderString == 'orderByLongest') {
        list = viewModel.listLongest;
        title = 'Meditações mais longas';
      } else if (viewModel.orderString == 'orderByShortest') {
        list = viewModel.listShortest;
        title = 'Meditações mais curtas';
      }
      return _buildList(context, list, title);
    } else if (viewModel.isFavourites) {
      return _buildList(context, viewModel.userFavorites, 'Minhas Favoritas');
    } else {
      // Default Stream
      return StreamBuilder<List<MeditationModel>>(
        stream: viewModel.meditationsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: FlutterFlowTheme.of(context).error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Erro ao carregar meditações',
                      style: FlutterFlowTheme.of(context).titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodySmall,
                    ),
                  ],
                ),
              ),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            );
          }
          final listDocs = snapshot.data!;
          if (listDocs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.self_improvement_outlined,
                    size: 64,
                    color: FlutterFlowTheme.of(context).primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma meditação disponível',
                    style: FlutterFlowTheme.of(context).titleMedium,
                  ),
                ],
              ),
            );
          }
          return _buildList(context, listDocs, 'Lista de Meditações');
        },
      );
    }
  }

  Widget _buildList(BuildContext context, List<MeditationModel>? list, String title) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(4.0, 8.0, 0.0, 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: FlutterFlowTheme.of(context).labelLarge.override(
                      fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                      color: FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                    ),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.sizeOf(context).width * 1.0,
          height: MediaQuery.sizeOf(context).height * 0.86,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
          ),
          child: list == null
              ? Center(
                  child: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                )
              : _buildListView(list),
        ),
      ],
    );
  }

  Widget _buildListView(List<MeditationModel> listDocs) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      primary: false,
      scrollDirection: Axis.vertical,
      itemCount: listDocs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 0.0),
      itemBuilder: (context, listDocsIndex) {
        final listDocsItem = listDocs[listDocsIndex];
        return MeditationCardWidget(
          key: Key('meditation_${listDocsItem.id}'),
          docMeditation: listDocsItem,
        );
      },
    );
  }
}
