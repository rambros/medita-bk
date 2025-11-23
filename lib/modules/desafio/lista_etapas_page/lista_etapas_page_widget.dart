import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/modules/desafio/card_dia_meditacao/card_dia_meditacao_widget.dart';
import '/modules/desafio/confirma_reset_desafio/confirma_reset_desafio_widget.dart';
import '/modules/desafio/get_mandala/get_mandala_widget.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'lista_etapas_page_model.dart';
export 'lista_etapas_page_model.dart';

class ListaEtapasPageWidget extends StatefulWidget {
  const ListaEtapasPageWidget({super.key});

  static String routeName = 'listaEtapasPage';
  static String routePath = 'listaEtapasPage';

  @override
  State<ListaEtapasPageWidget> createState() => _ListaEtapasPageWidgetState();
}

class _ListaEtapasPageWidgetState extends State<ListaEtapasPageWidget> {
  late ListaEtapasPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListaEtapasPageModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'listaEtapasPage'});
    _model.expandableExpandableController1 =
        ExpandableController(initialExpanded: false);
    _model.expandableExpandableController2 =
        ExpandableController(initialExpanded: false);
    _model.expandableExpandableController3 =
        ExpandableController(initialExpanded: false);
    _model.expandableExpandableController4 =
        ExpandableController(initialExpanded: false);
    _model.expandableExpandableController5 =
        ExpandableController(initialExpanded: false);
    _model.expandableExpandableController6 =
        ExpandableController(initialExpanded: false);
    _model.expandableExpandableController7 =
        ExpandableController(initialExpanded: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        FlutterFlowTheme.of(context).d21Top,
                        FlutterFlowTheme.of(context).d21Botton
                      ],
                      stops: const [0.0, 1.0],
                      begin: const AlignmentDirectional(0.0, -1.0),
                      end: const AlignmentDirectional(0, 1.0),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0.0, 1.0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  4.0, 0.0, 4.0, 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      if (Navigator.of(context).canPop()) {
                                        context.pop();
                                      }
                                      context.pushNamed(
                                        HomePageWidget.routeName,
                                        extra: <String, dynamic>{
                                          kTransitionInfoKey: const TransitionInfo(
                                            hasTransition: true,
                                            transitionType:
                                                PageTransitionType.fade,
                                            duration: Duration(milliseconds: 0),
                                          ),
                                        },
                                      );
                                    },
                                    child: Icon(
                                      Icons.chevron_left,
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 32.0,
                                    ),
                                  ),
                                  Text(
                                    'Desafio 21 dias',
                                    style: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .titleLargeFamily,
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .titleLargeIsCustom,
                                        ),
                                  ),
                                  if ((currentUserDocument?.userRole
                                                  .toList() ??
                                              [])
                                          .contains('Tester') ==
                                      true)
                                    AuthUserStreamWidget(
                                      builder: (context) =>
                                          FlutterFlowIconButton(
                                        borderColor: Colors.transparent,
                                        borderRadius: 20.0,
                                        borderWidth: 1.0,
                                        buttonSize: 40.0,
                                        icon: Icon(
                                          Icons.lock_reset_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          size: 24.0,
                                        ),
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
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        MediaQuery.viewInsetsOf(
                                                            context),
                                                    child:
                                                        const ConfirmaResetDesafioWidget(),
                                                  ),
                                                ),
                                              );
                                            },
                                          ).then(
                                              (value) => safeSetState(() {}));
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF83193F), Color(0xFFB0373E)],
                                stops: [0.0, 1.0],
                                begin: AlignmentDirectional(0.0, -1.0),
                                end: AlignmentDirectional(0, 1.0),
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).info,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 4.0),
                              child: Container(
                                width: double.infinity,
                                color: const Color(0x00000000),
                                child: ExpandableNotifier(
                                  controller:
                                      _model.expandableExpandableController1,
                                  child: ExpandablePanel(
                                    header: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  32.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            'Etapa 1',
                                            style: FlutterFlowTheme.of(context)
                                                .titleLarge
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleLargeFamily,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .info,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .titleLargeIsCustom,
                                                ),
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                          child: Image.network(
                                            functions.getURLMandala(
                                                1,
                                                FFAppState()
                                                    .desafio21
                                                    .diasCompletados,
                                                FFAppState()
                                                    .listaEtapasMandalas
                                                    .toList())!,
                                            width: 30.0,
                                            height: 30.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                    collapsed: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [],
                                    ),
                                    expanded: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  32.0, 16.0, 32.0, 32.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              wrapWithModel(
                                                model: _model.getMandalaModel1,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child: GetMandalaWidget(
                                                  etapa: 1,
                                                  diaCompletado:
                                                      valueOrDefault<int>(
                                                    FFAppState()
                                                        .desafio21
                                                        .diasCompletados,
                                                    0,
                                                  ),
                                                  listaEtapasMandalas:
                                                      FFAppState()
                                                          .listaEtapasMandalas,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        wrapWithModel(
                                          model: _model.cardDiaMeditacaoModel1,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: const CardDiaMeditacaoWidget(
                                            dia: 1,
                                          ),
                                        ),
                                        wrapWithModel(
                                          model: _model.cardDiaMeditacaoModel2,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: const CardDiaMeditacaoWidget(
                                            dia: 2,
                                          ),
                                        ),
                                        wrapWithModel(
                                          model: _model.cardDiaMeditacaoModel3,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: const CardDiaMeditacaoWidget(
                                            dia: 3,
                                          ),
                                        ),
                                      ],
                                    ),
                                    theme: ExpandableThemeData(
                                      tapHeaderToExpand: true,
                                      tapBodyToExpand: false,
                                      tapBodyToCollapse: false,
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      hasIcon: true,
                                      expandIcon: Icons.chevron_right_rounded,
                                      collapseIcon:
                                          Icons.keyboard_arrow_down_rounded,
                                      iconSize: 24.0,
                                      iconColor:
                                          FlutterFlowTheme.of(context).info,
                                      iconPadding: const EdgeInsets.all(8.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF83193F), Color(0xFFB0373E)],
                                stops: [0.0, 1.0],
                                begin: AlignmentDirectional(0.0, -1.0),
                                end: AlignmentDirectional(0, 1.0),
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).info,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 4.0),
                              child: Container(
                                width: double.infinity,
                                color: const Color(0x00000000),
                                child: ExpandableNotifier(
                                  controller:
                                      _model.expandableExpandableController2,
                                  child: ExpandablePanel(
                                    header: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  32.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            'Etapa 2',
                                            style: FlutterFlowTheme.of(context)
                                                .titleLarge
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleLargeFamily,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .info,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .titleLargeIsCustom,
                                                ),
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                          child: Image.network(
                                            functions.getURLMandala(
                                                2,
                                                FFAppState()
                                                    .desafio21
                                                    .diasCompletados,
                                                FFAppState()
                                                    .listaEtapasMandalas
                                                    .toList())!,
                                            width: 30.0,
                                            height: 30.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                    collapsed: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [],
                                    ),
                                    expanded: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  32.0, 16.0, 32.0, 32.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              wrapWithModel(
                                                model: _model.getMandalaModel2,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child: GetMandalaWidget(
                                                  etapa: 2,
                                                  diaCompletado:
                                                      valueOrDefault<int>(
                                                    FFAppState()
                                                        .desafio21
                                                        .diasCompletados,
                                                    0,
                                                  ),
                                                  listaEtapasMandalas:
                                                      FFAppState()
                                                          .listaEtapasMandalas,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        wrapWithModel(
                                          model: _model.cardDiaMeditacaoModel4,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: const CardDiaMeditacaoWidget(
                                            dia: 4,
                                          ),
                                        ),
                                        wrapWithModel(
                                          model: _model.cardDiaMeditacaoModel5,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: const CardDiaMeditacaoWidget(
                                            dia: 5,
                                          ),
                                        ),
                                        wrapWithModel(
                                          model: _model.cardDiaMeditacaoModel6,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: const CardDiaMeditacaoWidget(
                                            dia: 6,
                                          ),
                                        ),
                                      ],
                                    ),
                                    theme: ExpandableThemeData(
                                      tapHeaderToExpand: true,
                                      tapBodyToExpand: false,
                                      tapBodyToCollapse: false,
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      hasIcon: true,
                                      expandIcon: Icons.chevron_right_rounded,
                                      collapseIcon:
                                          Icons.keyboard_arrow_down_rounded,
                                      iconSize: 24.0,
                                      iconColor:
                                          FlutterFlowTheme.of(context).info,
                                      iconPadding: const EdgeInsets.all(8.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF83193F), Color(0xFFB0373E)],
                                stops: [0.0, 1.0],
                                begin: AlignmentDirectional(0.0, -1.0),
                                end: AlignmentDirectional(0, 1.0),
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).info,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 4.0),
                              child: Container(
                                width: double.infinity,
                                color: const Color(0x00000000),
                                child: ExpandableNotifier(
                                  controller:
                                      _model.expandableExpandableController3,
                                  child: ExpandablePanel(
                                    header: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  32.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            'Etapa 3',
                                            style: FlutterFlowTheme.of(context)
                                                .titleLarge
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleLargeFamily,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .info,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .titleLargeIsCustom,
                                                ),
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                          child: Image.network(
                                            functions.getURLMandala(
                                                3,
                                                FFAppState()
                                                    .desafio21
                                                    .diasCompletados,
                                                FFAppState()
                                                    .listaEtapasMandalas
                                                    .toList())!,
                                            width: 30.0,
                                            height: 30.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                    collapsed: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [],
                                    ),
                                    expanded: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  32.0, 16.0, 32.0, 32.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              wrapWithModel(
                                                model: _model.getMandalaModel3,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child: GetMandalaWidget(
                                                  etapa: 3,
                                                  diaCompletado:
                                                      valueOrDefault<int>(
                                                    FFAppState()
                                                        .desafio21
                                                        .diasCompletados,
                                                    0,
                                                  ),
                                                  listaEtapasMandalas:
                                                      FFAppState()
                                                          .listaEtapasMandalas,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        wrapWithModel(
                                          model: _model.cardDiaMeditacaoModel7,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: const CardDiaMeditacaoWidget(
                                            dia: 7,
                                          ),
                                        ),
                                        wrapWithModel(
                                          model: _model.cardDiaMeditacaoModel8,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: const CardDiaMeditacaoWidget(
                                            dia: 8,
                                          ),
                                        ),
                                        wrapWithModel(
                                          model: _model.cardDiaMeditacaoModel9,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: const CardDiaMeditacaoWidget(
                                            dia: 9,
                                          ),
                                        ),
                                      ],
                                    ),
                                    theme: ExpandableThemeData(
                                      tapHeaderToExpand: true,
                                      tapBodyToExpand: false,
                                      tapBodyToCollapse: false,
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      hasIcon: true,
                                      expandIcon: Icons.chevron_right_rounded,
                                      collapseIcon:
                                          Icons.keyboard_arrow_down_rounded,
                                      iconSize: 24.0,
                                      iconColor:
                                          FlutterFlowTheme.of(context).info,
                                      iconPadding: const EdgeInsets.all(8.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF83193F), Color(0xFFB0373E)],
                                stops: [0.0, 1.0],
                                begin: AlignmentDirectional(0.0, -1.0),
                                end: AlignmentDirectional(0, 1.0),
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).info,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 4.0),
                              child: Container(
                                width: double.infinity,
                                color: const Color(0x00000000),
                                child: ExpandableNotifier(
                                  controller:
                                      _model.expandableExpandableController4,
                                  child: ExpandablePanel(
                                    header: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  32.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            'Etapa 4',
                                            style: FlutterFlowTheme.of(context)
                                                .titleLarge
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleLargeFamily,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .info,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .titleLargeIsCustom,
                                                ),
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                          child: Image.network(
                                            functions.getURLMandala(
                                                4,
                                                FFAppState()
                                                    .desafio21
                                                    .diasCompletados,
                                                FFAppState()
                                                    .listaEtapasMandalas
                                                    .toList())!,
                                            width: 30.0,
                                            height: 30.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                    collapsed: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [],
                                    ),
                                    expanded: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  32.0, 16.0, 32.0, 32.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              wrapWithModel(
                                                model: _model.getMandalaModel4,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child: GetMandalaWidget(
                                                  etapa: 4,
                                                  diaCompletado:
                                                      valueOrDefault<int>(
                                                    FFAppState()
                                                        .desafio21
                                                        .diasCompletados,
                                                    0,
                                                  ),
                                                  listaEtapasMandalas:
                                                      FFAppState()
                                                          .listaEtapasMandalas,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        wrapWithModel(
                                          model: _model.cardDiaMeditacaoModel10,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: const CardDiaMeditacaoWidget(
                                            dia: 10,
                                          ),
                                        ),
                                        wrapWithModel(
                                          model: _model.cardDiaMeditacaoModel11,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: const CardDiaMeditacaoWidget(
                                            dia: 11,
                                          ),
                                        ),
                                        wrapWithModel(
                                          model: _model.cardDiaMeditacaoModel12,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: const CardDiaMeditacaoWidget(
                                            dia: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    theme: ExpandableThemeData(
                                      tapHeaderToExpand: true,
                                      tapBodyToExpand: false,
                                      tapBodyToCollapse: false,
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      hasIcon: true,
                                      expandIcon: Icons.chevron_right_rounded,
                                      collapseIcon:
                                          Icons.keyboard_arrow_down_rounded,
                                      iconSize: 24.0,
                                      iconColor:
                                          FlutterFlowTheme.of(context).info,
                                      iconPadding: const EdgeInsets.all(8.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF83193F), Color(0xFFB0373E)],
                                stops: [0.0, 1.0],
                                begin: AlignmentDirectional(0.0, -1.0),
                                end: AlignmentDirectional(0, 1.0),
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).info,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 4.0),
                              child: Container(
                                width: double.infinity,
                                color: const Color(0x00000000),
                                child: ExpandableNotifier(
                                  controller:
                                      _model.expandableExpandableController5,
                                  child: ExpandablePanel(
                                    header: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  32.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            'Etapa 5',
                                            style: FlutterFlowTheme.of(context)
                                                .titleLarge
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleLargeFamily,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .info,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .titleLargeIsCustom,
                                                ),
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                          child: Image.network(
                                            functions.getURLMandala(
                                                5,
                                                FFAppState()
                                                    .desafio21
                                                    .diasCompletados,
                                                FFAppState()
                                                    .listaEtapasMandalas
                                                    .toList())!,
                                            width: 30.0,
                                            height: 30.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                    collapsed: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [],
                                    ),
                                    expanded: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  32.0, 16.0, 32.0, 32.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              wrapWithModel(
                                                model: _model.getMandalaModel5,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child: GetMandalaWidget(
                                                  etapa: 5,
                                                  diaCompletado:
                                                      valueOrDefault<int>(
                                                    FFAppState()
                                                        .desafio21
                                                        .diasCompletados,
                                                    0,
                                                  ),
                                                  listaEtapasMandalas:
                                                      FFAppState()
                                                          .listaEtapasMandalas,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        wrapWithModel(
                                          model: _model.cardDiaMeditacaoModel13,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: const CardDiaMeditacaoWidget(
                                            dia: 13,
                                          ),
                                        ),
                                        wrapWithModel(
                                          model: _model.cardDiaMeditacaoModel14,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: const CardDiaMeditacaoWidget(
                                            dia: 14,
                                          ),
                                        ),
                                        wrapWithModel(
                                          model: _model.cardDiaMeditacaoModel15,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: const CardDiaMeditacaoWidget(
                                            dia: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    theme: ExpandableThemeData(
                                      tapHeaderToExpand: true,
                                      tapBodyToExpand: false,
                                      tapBodyToCollapse: false,
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      hasIcon: true,
                                      expandIcon: Icons.chevron_right_rounded,
                                      collapseIcon:
                                          Icons.keyboard_arrow_down_rounded,
                                      iconSize: 24.0,
                                      iconColor:
                                          FlutterFlowTheme.of(context).info,
                                      iconPadding: const EdgeInsets.all(8.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF83193F), Color(0xFFB0373E)],
                                stops: [0.0, 1.0],
                                begin: AlignmentDirectional(0.0, -1.0),
                                end: AlignmentDirectional(0, 1.0),
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).info,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 4.0),
                              child: Container(
                                width: double.infinity,
                                color: const Color(0x00000000),
                                child: ExpandableNotifier(
                                  controller:
                                      _model.expandableExpandableController6,
                                  child: ExpandablePanel(
                                    header: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  32.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            'Etapa 6',
                                            style: FlutterFlowTheme.of(context)
                                                .titleLarge
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleLargeFamily,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .info,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .titleLargeIsCustom,
                                                ),
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                          child: Image.network(
                                            functions.getURLMandala(
                                                6,
                                                FFAppState()
                                                    .desafio21
                                                    .diasCompletados,
                                                FFAppState()
                                                    .listaEtapasMandalas
                                                    .toList())!,
                                            width: 30.0,
                                            height: 30.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                    collapsed: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [],
                                    ),
                                    expanded: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  32.0, 16.0, 32.0, 32.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              wrapWithModel(
                                                model: _model.getMandalaModel6,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child: GetMandalaWidget(
                                                  etapa: 6,
                                                  diaCompletado:
                                                      valueOrDefault<int>(
                                                    FFAppState()
                                                        .desafio21
                                                        .diasCompletados,
                                                    0,
                                                  ),
                                                  listaEtapasMandalas:
                                                      FFAppState()
                                                          .listaEtapasMandalas,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        wrapWithModel(
                                          model: _model.cardDiaMeditacaoModel16,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: const CardDiaMeditacaoWidget(
                                            dia: 16,
                                          ),
                                        ),
                                        wrapWithModel(
                                          model: _model.cardDiaMeditacaoModel17,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: const CardDiaMeditacaoWidget(
                                            dia: 17,
                                          ),
                                        ),
                                        wrapWithModel(
                                          model: _model.cardDiaMeditacaoModel18,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: const CardDiaMeditacaoWidget(
                                            dia: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    theme: ExpandableThemeData(
                                      tapHeaderToExpand: true,
                                      tapBodyToExpand: false,
                                      tapBodyToCollapse: false,
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      hasIcon: true,
                                      expandIcon: Icons.chevron_right_rounded,
                                      collapseIcon:
                                          Icons.keyboard_arrow_down_rounded,
                                      iconSize: 24.0,
                                      iconColor:
                                          FlutterFlowTheme.of(context).info,
                                      iconPadding: const EdgeInsets.all(8.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF83193F), Color(0xFFB0373E)],
                                stops: [0.0, 1.0],
                                begin: AlignmentDirectional(0.0, -1.0),
                                end: AlignmentDirectional(0, 1.0),
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).info,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 4.0),
                              child: Container(
                                width: double.infinity,
                                color: const Color(0x00000000),
                                child: ExpandableNotifier(
                                  controller:
                                      _model.expandableExpandableController7,
                                  child: ExpandablePanel(
                                    header: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  32.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            'Etapa 7',
                                            style: FlutterFlowTheme.of(context)
                                                .titleLarge
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleLargeFamily,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .info,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .titleLargeIsCustom,
                                                ),
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                          child: Image.network(
                                            functions.getURLMandala(
                                                7,
                                                FFAppState()
                                                    .desafio21
                                                    .diasCompletados,
                                                FFAppState()
                                                    .listaEtapasMandalas
                                                    .toList())!,
                                            width: 32.0,
                                            height: 32.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                    collapsed: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [],
                                    ),
                                    expanded: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  32.0, 16.0, 32.0, 32.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              wrapWithModel(
                                                model: _model.getMandalaModel7,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child: GetMandalaWidget(
                                                  etapa: 7,
                                                  diaCompletado:
                                                      valueOrDefault<int>(
                                                    FFAppState()
                                                        .desafio21
                                                        .diasCompletados,
                                                    0,
                                                  ),
                                                  listaEtapasMandalas:
                                                      FFAppState()
                                                          .listaEtapasMandalas,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        wrapWithModel(
                                          model: _model.cardDiaMeditacaoModel19,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: const CardDiaMeditacaoWidget(
                                            dia: 19,
                                          ),
                                        ),
                                        wrapWithModel(
                                          model: _model.cardDiaMeditacaoModel20,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: const CardDiaMeditacaoWidget(
                                            dia: 20,
                                          ),
                                        ),
                                        wrapWithModel(
                                          model: _model.cardDiaMeditacaoModel21,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: const CardDiaMeditacaoWidget(
                                            dia: 21,
                                          ),
                                        ),
                                      ],
                                    ),
                                    theme: ExpandableThemeData(
                                      tapHeaderToExpand: true,
                                      tapBodyToExpand: false,
                                      tapBodyToCollapse: false,
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      hasIcon: true,
                                      expandIcon: Icons.chevron_right_rounded,
                                      collapseIcon:
                                          Icons.keyboard_arrow_down_rounded,
                                      iconSize: 24.0,
                                      iconColor:
                                          FlutterFlowTheme.of(context).info,
                                      iconPadding: const EdgeInsets.all(8.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ].divide(const SizedBox(height: 16.0)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
