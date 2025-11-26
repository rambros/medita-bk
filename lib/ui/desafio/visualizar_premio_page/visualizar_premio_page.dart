import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import '/ui/core/flutter_flow/flutter_flow_pdf_viewer.dart';
import '/ui/core/flutter_flow/flutter_flow_theme.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';

class VisualizarPremioPage extends StatefulWidget {
  const VisualizarPremioPage({
    super.key,
    required this.indiceBrasao,
  });

  final int? indiceBrasao;

  static String routeName = 'visualizarPremioPage';
  static String routePath = 'visualizarPremioPage';

  @override
  State<VisualizarPremioPage> createState() => _VisualizarPremioPageState();
}

class _VisualizarPremioPageState extends State<VisualizarPremioPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    logFirebaseEvent('screen_view', parameters: {'screen_name': 'visualizarPremioPage'});
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppStateStore>();
    final premio = AppStateStore().desafio21.listaBrasoes.elementAtOrNull(widget.indiceBrasao ?? 0);

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
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 2.0),
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
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () => context.safePop(),
                                  child: Icon(
                                    Icons.chevron_left,
                                    color: FlutterFlowTheme.of(context).info,
                                    size: 24.0,
                                  ),
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
                                  icon: Icon(
                                    Icons.download,
                                    color: FlutterFlowTheme.of(context).info,
                                    size: 32.0,
                                  ),
                                  onPressed: premio == null
                                      ? null
                                      : () async {
                                          await downloadFile(
                                            filename: premio.pdfFilename,
                                            url: premio.pdfUrl,
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
                                padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 0.0),
                                child: premio == null
                                    ? Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: Text(
                                          'Prêmio não encontrado',
                                          style: FlutterFlowTheme.of(context).bodyLarge,
                                        ),
                                      )
                                    : FlutterFlowPdfViewer(
                                        networkPath: premio.pdfUrl,
                                        width: double.infinity,
                                        height: MediaQuery.sizeOf(context).height * 0.8,
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
