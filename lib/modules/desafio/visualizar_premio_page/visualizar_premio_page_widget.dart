import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_pdf_viewer.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'visualizar_premio_page_model.dart';
export 'visualizar_premio_page_model.dart';

class VisualizarPremioPageWidget extends StatefulWidget {
  const VisualizarPremioPageWidget({
    super.key,
    required this.indiceBrasao,
  });

  final int? indiceBrasao;

  static String routeName = 'visualizarPremioPage';
  static String routePath = 'visualizarPremioPage';

  @override
  State<VisualizarPremioPageWidget> createState() =>
      _VisualizarPremioPageWidgetState();
}

class _VisualizarPremioPageWidgetState
    extends State<VisualizarPremioPageWidget> {
  late VisualizarPremioPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VisualizarPremioPageModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'visualizarPremioPage'});
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
                        const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 2.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0.0, 1.0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context.safePop();
                                  },
                                  child: Icon(
                                    Icons.chevron_left,
                                    color: FlutterFlowTheme.of(context).info,
                                    size: 24.0,
                                  ),
                                ),
                                Text(
                                  'Desafio 21 dias',
                                  style: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .titleLargeFamily,
                                        color:
                                            FlutterFlowTheme.of(context).info,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .titleLargeIsCustom,
                                      ),
                                ),
                                FlutterFlowIconButton(
                                  borderColor: Colors.transparent,
                                  borderRadius: 20.0,
                                  borderWidth: 1.0,
                                  buttonSize: 40.0,
                                  icon: Icon(
                                    Icons.download,
                                    color: FlutterFlowTheme.of(context).info,
                                    size: 32.0,
                                  ),
                                  onPressed: () async {
                                    await downloadFile(
                                      filename: FFAppState()
                                          .desafio21
                                          .listaBrasoes
                                          .elementAtOrNull(
                                              widget.indiceBrasao!)!
                                          .pdfFilename,
                                      url: FFAppState()
                                          .desafio21
                                          .listaBrasoes
                                          .elementAtOrNull(
                                              widget.indiceBrasao!)!
                                          .pdfUrl,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                              alignment: const AlignmentDirectional(0.0, -1.0),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    4.0, 0.0, 4.0, 0.0),
                                child: FlutterFlowPdfViewer(
                                  networkPath: FFAppState()
                                      .desafio21
                                      .listaBrasoes
                                      .elementAtOrNull(widget.indiceBrasao!)!
                                      .pdfUrl,
                                  width: double.infinity,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.8,
                                  horizontalScroll: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
