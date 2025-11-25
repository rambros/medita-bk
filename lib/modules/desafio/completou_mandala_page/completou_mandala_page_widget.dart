import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/core/utils/ui_utils.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'completou_mandala_page_model.dart';
export 'completou_mandala_page_model.dart';

class CompletouMandalaPageWidget extends StatefulWidget {
  const CompletouMandalaPageWidget({
    super.key,
    required this.diaCompletado,
    required this.etapaCompletada,
    required this.parmMandalaUrl,
  });

  final int? diaCompletado;
  final int? etapaCompletada;
  final String? parmMandalaUrl;

  static String routeName = 'completouMandalaPage';
  static String routePath = 'completouMandalaPage';

  @override
  State<CompletouMandalaPageWidget> createState() => _CompletouMandalaPageWidgetState();
}

class _CompletouMandalaPageWidgetState extends State<CompletouMandalaPageWidget> {
  late CompletouMandalaPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CompletouMandalaPageModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'completouMandalaPage'});
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
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [FlutterFlowTheme.of(context).d21Top, FlutterFlowTheme.of(context).d21Botton],
                      stops: const [0.0, 1.0],
                      begin: const AlignmentDirectional(0.0, -1.0),
                      end: const AlignmentDirectional(0, 1.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0.0, 1.0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    Icons.chevron_left,
                                    color: Colors.transparent,
                                    size: 24.0,
                                  ),
                                  Text(
                                    'Desafio 21 dias',
                                    style: FlutterFlowTheme.of(context).titleLarge.override(
                                          fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                                          color: FlutterFlowTheme.of(context).info,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
                                        ),
                                  ),
                                  FlutterFlowIconButton(
                                    borderColor: Colors.transparent,
                                    borderRadius: 20.0,
                                    borderWidth: 1.0,
                                    buttonSize: 40.0,
                                    icon: const Icon(
                                      Icons.notifications_none,
                                      color: Color(0x00FFFFFF),
                                      size: 24.0,
                                    ),
                                    onPressed: () {
                                      print('IconButton pressed ...');
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                      child: Material(
                                        color: Colors.transparent,
                                        elevation: 4.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [Color(0xCC83193F), Color(0xCBB0373E)],
                                              stops: [0.0, 1.0],
                                              begin: AlignmentDirectional(0.0, -1.0),
                                              end: AlignmentDirectional(0, 1.0),
                                            ),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 0.0),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                                                      child: Text(
                                                        'Dia ${((widget.diaCompletado!) + 1).toString()}: ${valueOrDefault<String>(
                                                          FFAppState()
                                                              .desafio21
                                                              .d21Meditations
                                                              .elementAtOrNull(widget.diaCompletado!)
                                                              ?.titulo,
                                                          '1',
                                                        )}',
                                                        textAlign: TextAlign.center,
                                                        style: FlutterFlowTheme.of(context).labelLarge.override(
                                                              fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                                              color: FlutterFlowTheme.of(context).info,
                                                              fontSize: 22.0,
                                                              letterSpacing: 0.0,
                                                              useGoogleFonts:
                                                                  !FlutterFlowTheme.of(context).labelLargeIsCustom,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 32.0),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(8.0),
                                                      child: Image.network(
                                                        widget.parmMandalaUrl!,
                                                        width:
                                                            MediaQuery.sizeOf(context).height < 800.0 ? 150.0 : 250.0,
                                                        height:
                                                            MediaQuery.sizeOf(context).height < 800.0 ? 150.0 : 250.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                                                child: Text(
                                                  'Excelente!',
                                                  style: FlutterFlowTheme.of(context).titleLarge.override(
                                                        fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                                                        color: FlutterFlowTheme.of(context).info,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme.of(context).titleLargeIsCustom,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 16.0),
                                                child: Text(
                                                  FFAppState()
                                                      .listaEtapasMandalas
                                                      .elementAtOrNull((widget.etapaCompletada!) - 1)!
                                                      .textoMandalaCompleta,
                                                  textAlign: TextAlign.center,
                                                  style: FlutterFlowTheme.of(context).labelLarge.override(
                                                        fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                                        color: FlutterFlowTheme.of(context).info,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme.of(context).labelLargeIsCustom,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
                                                child: Text(
                                                  'Compartilhe sua conquista!',
                                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                        fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                                        color: FlutterFlowTheme.of(context).info,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                                          child: FFButtonWidget(
                                            onPressed: () async {
                                              await UIUtils.shareImageAndText(
                                                functions.getStringFromImagePath(FFAppState()
                                                    .listaEtapasMandalas
                                                    .elementAtOrNull((widget.etapaCompletada!) - 1)!
                                                    .listaMandalas
                                                    .lastOrNull!
                                                    .mandalaUrl)!,
                                                '${FFAppState().listaEtapasMandalas.elementAtOrNull((widget.etapaCompletada!) - 1)?.textoCompartilharMandala} Baixe no link a seguir o  App MEDITABK da Brahma Kumaris, é 100% gratuito.${'\n'}https://c5dad.app.link/meditabk',
                                              );
                                            },
                                            text: 'Compartilhar',
                                            options: FFButtonOptions(
                                              height: 40.0,
                                              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                              iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              color: FlutterFlowTheme.of(context).info,
                                              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                    fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                                    color: const Color(0xFFF9A61A),
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
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                                          child: FFButtonWidget(
                                            onPressed: () async {
                                              if (widget.diaCompletado == 2) {
                                                // bronze

                                                context.pushNamed(
                                                  CompletouBrasaoPageWidget.routeName,
                                                  queryParameters: {
                                                    'indiceBrasao': serializeParam(
                                                      0,
                                                      ParamType.int,
                                                    ),
                                                  }.withoutNulls,
                                                  extra: <String, dynamic>{
                                                    kTransitionInfoKey: const TransitionInfo(
                                                      hasTransition: true,
                                                      transitionType: PageTransitionType.fade,
                                                      duration: Duration(milliseconds: 0),
                                                    ),
                                                  },
                                                );
                                              } else if (widget.diaCompletado == 8) {
                                                // prata

                                                context.pushNamed(
                                                  CompletouBrasaoPageWidget.routeName,
                                                  queryParameters: {
                                                    'indiceBrasao': serializeParam(
                                                      1,
                                                      ParamType.int,
                                                    ),
                                                  }.withoutNulls,
                                                  extra: <String, dynamic>{
                                                    kTransitionInfoKey: const TransitionInfo(
                                                      hasTransition: true,
                                                      transitionType: PageTransitionType.fade,
                                                      duration: Duration(milliseconds: 0),
                                                    ),
                                                  },
                                                );
                                              } else if (widget.diaCompletado == 20) {
                                                // ouro

                                                context.pushNamed(
                                                  CompletouBrasaoPageWidget.routeName,
                                                  queryParameters: {
                                                    'indiceBrasao': serializeParam(
                                                      2,
                                                      ParamType.int,
                                                    ),
                                                  }.withoutNulls,
                                                  extra: <String, dynamic>{
                                                    kTransitionInfoKey: const TransitionInfo(
                                                      hasTransition: true,
                                                      transitionType: PageTransitionType.fade,
                                                      duration: Duration(milliseconds: 0),
                                                    ),
                                                  },
                                                );
                                              } else {
                                                context.goNamed(
                                                  HomeDesafioPageWidget.routeName,
                                                  extra: <String, dynamic>{
                                                    kTransitionInfoKey: const TransitionInfo(
                                                      hasTransition: true,
                                                      transitionType: PageTransitionType.fade,
                                                      duration: Duration(milliseconds: 0),
                                                    ),
                                                  },
                                                );
                                              }
                                            },
                                            text: 'Continuar',
                                            options: FFButtonOptions(
                                              height: 40.0,
                                              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                              iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              color: const Color(0xFFF9A61A),
                                              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                    fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                                    color: FlutterFlowTheme.of(context).info,
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
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
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
