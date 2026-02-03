import 'package:flutter/material.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_widgets.dart';
import 'package:medita_bk/ui/desafio/widgets/confirma_reset_desafio_widget.dart';
import 'package:medita_bk/ui/pages.dart';

/// Widget displayed when the Desafio 21 dias is completed
///
/// Shows:
/// - Congratulations message
/// - Option to redo a meditation
/// - Option to reset the challenge
class DesafioCompletedViewWidget extends StatelessWidget {
  const DesafioCompletedViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              height: 440.0,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xCC83193F), Color(0xCBB0373E)],
                  stops: [0.0, 1.0],
                  begin: AlignmentDirectional(0.0, -1.0),
                  end: AlignmentDirectional(0, 1.0),
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                      child: Text(
                        'Você já concluiu o desafio',
                        style: FlutterFlowTheme.of(context).labelLarge.override(
                              fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                              color: FlutterFlowTheme.of(context).info,
                              fontSize: 22.0,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                            ),
                      ),
                    ),

                    // Actions
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Question
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 32.0),
                              child: Text(
                                'O que você deseja fazer?',
                                style: FlutterFlowTheme.of(context).labelLarge.override(
                                      fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                      color: FlutterFlowTheme.of(context).info,
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                                    ),
                              ),
                            ),
                          ],
                        ),

                        // Redo meditation button
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 32.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              context.pushNamed(
                                ListaEtapasPage.routeName,
                                extra: <String, dynamic>{
                                  kTransitionInfoKey: const TransitionInfo(
                                    hasTransition: true,
                                    transitionType: PageTransitionType.fade,
                                    duration: Duration(milliseconds: 0),
                                  ),
                                },
                              );
                            },
                            text: 'Refazer uma meditação',
                            options: FFButtonOptions(
                              height: 40.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).d21Orange,
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
                        ),

                        // Reset challenge button
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 32.0),
                          child: FFButtonWidget(
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
                                        child: const ConfirmaResetDesafioWidget(),
                                      ),
                                    ),
                                  );
                                },
                              ).then((value) => setState(() {}));
                            },
                            text: 'Reiniciar o desafio',
                            options: FFButtonOptions(
                              height: 40.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).d21Orange,
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to trigger setState in parent
  void setState(VoidCallback fn) {
    fn();
  }
}
