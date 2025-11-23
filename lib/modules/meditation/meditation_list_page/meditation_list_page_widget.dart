import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/componentes/meditation_card/meditation_card_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/modules/meditation/filter_meditations_dialog/filter_meditations_dialog_widget.dart';
import '/modules/meditation/sort_meditations_dialog/sort_meditations_dialog_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'meditation_list_page_model.dart';
export 'meditation_list_page_model.dart';

class MeditationListPageWidget extends StatefulWidget {
  const MeditationListPageWidget({super.key});

  static String routeName = 'meditationListPage';
  static String routePath = 'meditationListPage';

  @override
  State<MeditationListPageWidget> createState() =>
      _MeditationListPageWidgetState();
}

class _MeditationListPageWidgetState extends State<MeditationListPageWidget> {
  late MeditationListPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MeditationListPageModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'meditationListPage'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.isOrdered = false;
      _model.isFavourites = false;
      safeSetState(() {});
    });

    _model.textSearchFieldTextController ??= TextEditingController();
    _model.textSearchFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MeditationsRecord>>(
      stream: FFAppState().listMeditations(
        requestFn: () => queryMeditationsRecord(
          queryBuilder: (meditationsRecord) =>
              meditationsRecord.orderBy('date', descending: true),
        ),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }
        List<MeditationsRecord> meditationListPageMeditationsRecordList =
            snapshot.data!;

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
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 4.0, 0.0),
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
                                style: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .titleLargeFamily,
                                      color: FlutterFlowTheme.of(context).info,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .titleLargeIsCustom,
                                    ),
                              ),
                              FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 30.0,
                                borderWidth: 1.0,
                                buttonSize: 60.0,
                                icon: Icon(
                                  Icons.favorite_border,
                                  color: FlutterFlowTheme.of(context).info,
                                  size: 26.0,
                                ),
                                onPressed: () async {
                                  // faz um toogle pq na interface nao tem um clear nem um disable favorites...
                                  _model.isFavourites = !_model.isFavourites;
                                  _model.isSearching = false;
                                  _model.isFiltered = false;
                                  _model.isOrdered = false;
                                  safeSetState(() {});
                                  if (_model.isFavourites == false) {
                                    _model.listFavorites = [];
                                  } else {
                                    // pesquisa favoritas do user
                                    _model.listaMediticaoesFavoritas =
                                        await actions.getFavoritesMeditations(
                                      currentUserUid,
                                    );
                                    _model.listFavorites = _model
                                        .listaMediticaoesFavoritas!
                                        .toList()
                                        .cast<MeditationsRecord>();
                                    safeSetState(() {});
                                  }

                                  if (_model.listFavorites.isNotEmpty) {
                                    // Tem favoritos
                                    _model.isFavourites = true;
                                    safeSetState(() {});
                                  } else {
                                    // Não tem
                                    _model.isFavourites = false;
                                    safeSetState(() {});
                                  }

                                  safeSetState(() {});
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
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 16.0),
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
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                          child: Padding(
                                            padding: MediaQuery.viewInsetsOf(
                                                context),
                                            child:
                                                const SortMeditationsDialogWidget(),
                                          ),
                                        ),
                                      );
                                    },
                                  ).then((value) => safeSetState(
                                      () => _model.orderString = value));

                                  _model.order = _model.orderString!;
                                  _model.isFiltered = false;
                                  _model.isSearching = false;
                                  _model.isFavourites = false;
                                  if (_model.order == 'orderByNumPlayed') {
                                    _model.listNumPlayed =
                                        await queryMeditationsRecordOnce(
                                      queryBuilder: (meditationsRecord) =>
                                          meditationsRecord.orderBy('numPlayed',
                                              descending: true),
                                    );
                                  } else {
                                    if (_model.order == 'orderByNewest') {
                                      _model.listNewest =
                                          await queryMeditationsRecordOnce(
                                        queryBuilder: (meditationsRecord) =>
                                            meditationsRecord.orderBy('date',
                                                descending: true),
                                      );
                                    } else {
                                      if (_model.order == 'orderByFavourites') {
                                        _model.listFavourites =
                                            await queryMeditationsRecordOnce(
                                          queryBuilder: (meditationsRecord) =>
                                              meditationsRecord.orderBy(
                                                  'numLiked',
                                                  descending: true),
                                        );
                                      } else {
                                        if (_model.order == 'orderByLongest') {
                                          _model.listLongest =
                                              await queryMeditationsRecordOnce(
                                            queryBuilder: (meditationsRecord) =>
                                                meditationsRecord.orderBy(
                                                    'audioDuration',
                                                    descending: true),
                                          );
                                        } else {
                                          if (_model.order ==
                                              'orderByShortest') {
                                            _model.listShortest =
                                                await queryMeditationsRecordOnce(
                                              queryBuilder:
                                                  (meditationsRecord) =>
                                                      meditationsRecord.orderBy(
                                                          'audioDuration'),
                                            );
                                          }
                                        }
                                      }
                                    }
                                  }

                                  _model.isOrdered = true;
                                  safeSetState(() {});

                                  safeSetState(() {});
                                },
                                text: 'Ordenar',
                                options: FFButtonOptions(
                                  height: 36.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .titleSmallFamily,
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .titleSmallIsCustom,
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
                                  var shouldSetState = false;
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
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                          child: Padding(
                                            padding: MediaQuery.viewInsetsOf(
                                                context),
                                            child:
                                                const FilterMeditationsDialogWidget(),
                                          ),
                                        ),
                                      );
                                    },
                                  ).then((value) => safeSetState(
                                      () => _model.listaCategorias = value));

                                  shouldSetState = true;
                                  if (_model.listaCategorias == '') {
                                    _model.isFiltered = false;
                                    safeSetState(() {});
                                    if (shouldSetState) safeSetState(() {});
                                    return;
                                  }
                                  _model.isFiltered = true;
                                  _model.isSearching = false;
                                  _model.isFavourites = false;
                                  safeSetState(() {});
                                  _model.listFiltered =
                                      await queryMeditationsRecordOnce(
                                    queryBuilder: (meditationsRecord) =>
                                        meditationsRecord.where(
                                      'category',
                                      arrayContains: _model.listaCategorias,
                                    ),
                                  );
                                  shouldSetState = true;
                                  if (shouldSetState) safeSetState(() {});
                                },
                                text: 'Filtrar',
                                options: FFButtonOptions(
                                  height: 36.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .titleSmallFamily,
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .titleSmallIsCustom,
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
                                  _model.isSearching = true;
                                  safeSetState(() {});
                                },
                                text: 'Pesquisar',
                                options: FFButtonOptions(
                                  height: 36.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .titleSmallFamily,
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .titleSmallIsCustom,
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
                        if (_model.isSearching == true)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller:
                                        _model.textSearchFieldTextController,
                                    focusNode: _model.textSearchFieldFocusNode,
                                    onFieldSubmitted: (_) async {
                                      if (_model.textSearchFieldTextController
                                                  .text !=
                                              '') {
                                        safeSetState(() =>
                                            _model.algoliaSearchResults = null);
                                        await MeditationsRecord.search(
                                          term: _model
                                              .textSearchFieldTextController
                                              .text,
                                        )
                                            .then((r) =>
                                                _model.algoliaSearchResults = r)
                                            .onError((_, __) => _model
                                                .algoliaSearchResults = [])
                                            .whenComplete(
                                                () => safeSetState(() {}));
                                      }
                                    },
                                    autofocus: true,
                                    textInputAction: TextInputAction.search,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: 'Digite o texto para pesquisa',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLargeFamily,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyLargeIsCustom,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyLargeFamily,
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyLargeIsCustom,
                                        ),
                                    validator: _model
                                        .textSearchFieldTextControllerValidator
                                        .asValidator(context),
                                  ),
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    _model.isSearching = false;
                                    _model.textToSearch = '';
                                    safeSetState(() {});
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
                        Builder(
                          builder: (context) {
                            if (_model.isSearching == true) {
                              return Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        4.0, 8.0, 0.0, 8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Resultados da pesquisa',
                                          style: FlutterFlowTheme.of(context)
                                              .labelLarge
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLargeFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .labelLargeIsCustom,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 1.0,
                                    height: MediaQuery.sizeOf(context).height *
                                        0.86,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                    ),
                                    child: Builder(
                                      builder: (context) {
                                        if (_model.algoliaSearchResults ==
                                            null) {
                                          return Center(
                                            child: SizedBox(
                                              width: 50.0,
                                              height: 50.0,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        final listDocs = _model
                                                .algoliaSearchResults
                                                ?.toList() ??
                                            [];

                                        return ListView.separated(
                                          padding: EdgeInsets.zero,
                                          primary: false,
                                          scrollDirection: Axis.vertical,
                                          itemCount: listDocs.length,
                                          separatorBuilder: (_, __) =>
                                              const SizedBox(height: 0.0),
                                          itemBuilder:
                                              (context, listDocsIndex) {
                                            final listDocsItem =
                                                listDocs[listDocsIndex];
                                            return MeditationCardWidget(
                                              key: Key(
                                                  'Keycyj_${listDocsIndex}_of_${listDocs.length}'),
                                              docMeditation: listDocsItem,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            } else if (_model.isFiltered == true) {
                              return Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        4.0, 8.0, 0.0, 8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Meditações com filtro = ${_model.listaCategorias}',
                                          style: FlutterFlowTheme.of(context)
                                              .labelLarge
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLargeFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .labelLargeIsCustom,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 1.0,
                                    height: MediaQuery.sizeOf(context).height *
                                        0.86,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                    ),
                                    child: Builder(
                                      builder: (context) {
                                        final listDocs =
                                            _model.listFiltered?.toList() ?? [];

                                        return ListView.separated(
                                          padding: EdgeInsets.zero,
                                          primary: false,
                                          scrollDirection: Axis.vertical,
                                          itemCount: listDocs.length,
                                          separatorBuilder: (_, __) =>
                                              const SizedBox(height: 0.0),
                                          itemBuilder:
                                              (context, listDocsIndex) {
                                            final listDocsItem =
                                                listDocs[listDocsIndex];
                                            return MeditationCardWidget(
                                              key: Key(
                                                  'Key53z_${listDocsIndex}_of_${listDocs.length}'),
                                              docMeditation: listDocsItem,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            } else if (_model.isOrdered == true) {
                              return Builder(
                                builder: (context) {
                                  if (_model.order == 'orderByNumPlayed') {
                                    return Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  4.0, 8.0, 0.0, 8.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Meditações mais reproduzidas',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .labelLarge
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLargeFamily,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLargeIsCustom,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  1.0,
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.86,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                          ),
                                          child: Builder(
                                            builder: (context) {
                                              final listMedNumPlayed = _model
                                                      .listNumPlayed
                                                      ?.toList() ??
                                                  [];

                                              return ListView.separated(
                                                padding: EdgeInsets.zero,
                                                primary: false,
                                                scrollDirection: Axis.vertical,
                                                itemCount:
                                                    listMedNumPlayed.length,
                                                separatorBuilder: (_, __) =>
                                                    const SizedBox(height: 0.0),
                                                itemBuilder: (context,
                                                    listMedNumPlayedIndex) {
                                                  final listMedNumPlayedItem =
                                                      listMedNumPlayed[
                                                          listMedNumPlayedIndex];
                                                  return MeditationCardWidget(
                                                    key: Key(
                                                        'Key70k_${listMedNumPlayedIndex}_of_${listMedNumPlayed.length}'),
                                                    docMeditation:
                                                        listMedNumPlayedItem,
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  } else if (_model.order == 'orderByNewest') {
                                    return Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  4.0, 8.0, 0.0, 8.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Meditações mais recentes',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .labelLarge
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLargeFamily,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLargeIsCustom,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  1.0,
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.86,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                          ),
                                          child: Builder(
                                            builder: (context) {
                                              final listMeditations =
                                                  _model.listNewest?.toList() ??
                                                      [];

                                              return ListView.separated(
                                                padding: EdgeInsets.zero,
                                                primary: false,
                                                scrollDirection: Axis.vertical,
                                                itemCount:
                                                    listMeditations.length,
                                                separatorBuilder: (_, __) =>
                                                    const SizedBox(height: 0.0),
                                                itemBuilder: (context,
                                                    listMeditationsIndex) {
                                                  final listMeditationsItem =
                                                      listMeditations[
                                                          listMeditationsIndex];
                                                  return MeditationCardWidget(
                                                    key: Key(
                                                        'Keyvxf_${listMeditationsIndex}_of_${listMeditations.length}'),
                                                    docMeditation:
                                                        listMeditationsItem,
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  } else if (_model.order ==
                                      'orderByFavourites') {
                                    return Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  4.0, 8.0, 0.0, 8.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Meditações mais favoritadas',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .labelLarge
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLargeFamily,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLargeIsCustom,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  1.0,
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.86,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                          ),
                                          child: Builder(
                                            builder: (context) {
                                              final listMeditations = _model
                                                      .listFavourites
                                                      ?.toList() ??
                                                  [];

                                              return ListView.separated(
                                                padding: EdgeInsets.zero,
                                                primary: false,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount:
                                                    listMeditations.length,
                                                separatorBuilder: (_, __) =>
                                                    const SizedBox(height: 0.0),
                                                itemBuilder: (context,
                                                    listMeditationsIndex) {
                                                  final listMeditationsItem =
                                                      listMeditations[
                                                          listMeditationsIndex];
                                                  return MeditationCardWidget(
                                                    key: Key(
                                                        'Keyxne_${listMeditationsIndex}_of_${listMeditations.length}'),
                                                    docMeditation:
                                                        listMeditationsItem,
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  } else if (_model.order == 'orderByLongest') {
                                    return Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  4.0, 8.0, 0.0, 8.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Meditações de maior duração',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .labelLarge
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLargeFamily,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLargeIsCustom,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  1.0,
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.86,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                          ),
                                          child: Builder(
                                            builder: (context) {
                                              final listMeditations = _model
                                                      .listLongest
                                                      ?.toList() ??
                                                  [];

                                              return ListView.separated(
                                                padding: EdgeInsets.zero,
                                                primary: false,
                                                scrollDirection: Axis.vertical,
                                                itemCount:
                                                    listMeditations.length,
                                                separatorBuilder: (_, __) =>
                                                    const SizedBox(height: 0.0),
                                                itemBuilder: (context,
                                                    listMeditationsIndex) {
                                                  final listMeditationsItem =
                                                      listMeditations[
                                                          listMeditationsIndex];
                                                  return MeditationCardWidget(
                                                    key: Key(
                                                        'Keyi4f_${listMeditationsIndex}_of_${listMeditations.length}'),
                                                    docMeditation:
                                                        listMeditationsItem,
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  } else if (_model.order ==
                                      'orderByShortest') {
                                    return Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  4.0, 8.0, 0.0, 8.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Meditações de menor duração',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .labelLarge
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLargeFamily,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLargeIsCustom,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  1.0,
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.86,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                          ),
                                          child: Builder(
                                            builder: (context) {
                                              final listMeditations = _model
                                                      .listShortest
                                                      ?.toList() ??
                                                  [];

                                              return ListView.separated(
                                                padding: EdgeInsets.zero,
                                                primary: false,
                                                scrollDirection: Axis.vertical,
                                                itemCount:
                                                    listMeditations.length,
                                                separatorBuilder: (_, __) =>
                                                    const SizedBox(height: 0.0),
                                                itemBuilder: (context,
                                                    listMeditationsIndex) {
                                                  final listMeditationsItem =
                                                      listMeditations[
                                                          listMeditationsIndex];
                                                  return MeditationCardWidget(
                                                    key: Key(
                                                        'Keyqj3_${listMeditationsIndex}_of_${listMeditations.length}'),
                                                    docMeditation:
                                                        listMeditationsItem,
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Container(
                                      width: 362.0,
                                      height: 639.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                    );
                                  }
                                },
                              );
                            } else if (_model.isFavourites == true) {
                              return Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        4.0, 8.0, 0.0, 8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Lista das suas meditações favoritas',
                                          style: FlutterFlowTheme.of(context)
                                              .labelLarge
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLargeFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .labelLargeIsCustom,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 1.0,
                                    height: MediaQuery.sizeOf(context).height *
                                        0.86,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                    ),
                                    child: Builder(
                                      builder: (context) {
                                        final listDocs =
                                            _model.listFavorites.toList();

                                        return ListView.separated(
                                          padding: EdgeInsets.zero,
                                          primary: false,
                                          scrollDirection: Axis.vertical,
                                          itemCount: listDocs.length,
                                          separatorBuilder: (_, __) =>
                                              const SizedBox(height: 0.0),
                                          itemBuilder:
                                              (context, listDocsIndex) {
                                            final listDocsItem =
                                                listDocs[listDocsIndex];
                                            return MeditationCardWidget(
                                              key: Key(
                                                  'Keylxf_${listDocsIndex}_of_${listDocs.length}'),
                                              docMeditation: listDocsItem,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        4.0, 8.0, 0.0, 8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Lista de Meditações ',
                                          style: FlutterFlowTheme.of(context)
                                              .labelLarge
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLargeFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .labelLargeIsCustom,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 1.0,
                                    height: MediaQuery.sizeOf(context).height *
                                        0.86,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                    ),
                                    child: Builder(
                                      builder: (context) {
                                        final listMedNumPlayed =
                                            meditationListPageMeditationsRecordList
                                                .toList();

                                        return ListView.separated(
                                          padding: EdgeInsets.zero,
                                          primary: false,
                                          scrollDirection: Axis.vertical,
                                          itemCount: listMedNumPlayed.length,
                                          separatorBuilder: (_, __) =>
                                              const SizedBox(height: 0.0),
                                          itemBuilder:
                                              (context, listMedNumPlayedIndex) {
                                            final listMedNumPlayedItem =
                                                listMedNumPlayed[
                                                    listMedNumPlayedIndex];
                                            return MeditationCardWidget(
                                              key: Key(
                                                  'Key1a1_${listMedNumPlayedIndex}_of_${listMedNumPlayed.length}'),
                                              docMeditation:
                                                  listMedNumPlayedItem,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
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
}
