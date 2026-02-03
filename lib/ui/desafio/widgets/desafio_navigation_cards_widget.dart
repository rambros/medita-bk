import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/ui/pages.dart';

/// Navigation cards widget for Desafio home page
///
/// Displays two cards side by side:
/// - Conquistas & Metas
/// - Diário de meditação
class DesafioNavigationCardsWidget extends StatelessWidget {
  const DesafioNavigationCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Conquistas Card
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  context.pushNamed(
                    ConquistasPage.routeName,
                    extra: <String, dynamic>{
                      kTransitionInfoKey: const TransitionInfo(
                        hasTransition: true,
                        transitionType: PageTransitionType.fade,
                        duration: Duration(milliseconds: 0),
                      ),
                    },
                  );
                },
                child: Material(
                  color: Colors.transparent,
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 160.0,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xCC83193F), Color(0xCBB0373E)],
                        stops: [0.0, 1.0],
                        begin: AlignmentDirectional(0.0, -1.0),
                        end: AlignmentDirectional(0, 1.0),
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    alignment: const AlignmentDirectional(0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                          child: AutoSizeText(
                            'Conquistas',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            minFontSize: 18.0,
                            style: FlutterFlowTheme.of(context).labelLarge.override(
                                  fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                  color: FlutterFlowTheme.of(context).info,
                                  fontSize: 22.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 2.0, 12.0, 0.0),
                          child: AutoSizeText(
                            '& Metas',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            minFontSize: 18.0,
                            style: FlutterFlowTheme.of(context).labelLarge.override(
                                  fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                  color: FlutterFlowTheme.of(context).info,
                                  fontSize: 22.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Diário Card
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  context.pushNamed(
                    DiarioMeditacaoPage.routeName,
                    extra: <String, dynamic>{
                      kTransitionInfoKey: const TransitionInfo(
                        hasTransition: true,
                        transitionType: PageTransitionType.fade,
                        duration: Duration(milliseconds: 0),
                      ),
                    },
                  );
                },
                child: Material(
                  color: Colors.transparent,
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 160.0,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xCC83193F), Color(0xCBB0373E)],
                        stops: [0.0, 1.0],
                        begin: AlignmentDirectional(0.0, -1.0),
                        end: AlignmentDirectional(0, 1.0),
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    alignment: const AlignmentDirectional(0.0, 0.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: AutoSizeText(
                        'Diário de meditação',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        minFontSize: 18.0,
                        style: FlutterFlowTheme.of(context).labelLarge.override(
                              fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                              color: FlutterFlowTheme.of(context).info,
                              fontSize: 22.0,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
