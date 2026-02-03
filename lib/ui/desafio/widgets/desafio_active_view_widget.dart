import 'package:flutter/material.dart';

import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_widgets.dart';
import 'package:medita_bk/ui/core/flutter_flow/custom_functions.dart' as functions;
import 'package:medita_bk/ui/pages.dart';
import 'package:medita_bk/ui/desafio/home_desafio_page/view_model/home_desafio_view_model.dart';

/// Widget displayed when the Desafio 21 dias is active
///
/// Shows:
/// - Current stage number
/// - Mandala image
/// - Start button (if not started) or Continue button (if started)
class DesafioActiveViewWidget extends StatelessWidget {
  const DesafioActiveViewWidget({
    super.key,
    required this.viewModel,
  });

  final HomeDesafioViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
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
              height: MediaQuery.sizeOf(context).height < 800.0 ? 358.0 : 440.0,
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
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Stage title
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                    child: Text(
                      'Etapa ${valueOrDefault<String>(
                        viewModel.etapaAtual.toString(),
                        '1',
                      )}',
                      style: FlutterFlowTheme.of(context).labelLarge.override(
                            fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                            color: FlutterFlowTheme.of(context).info,
                            fontSize: 22.0,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                          ),
                    ),
                  ),

                  // Content based on started state
                  Builder(
                    builder: (context) {
                      if (!viewModel.isDesafioStarted) {
                        return _buildNotStartedContent(context);
                      } else {
                        return _buildStartedContent(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Content shown when desafio has not been started
  Widget _buildNotStartedContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Mandala image
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 24.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              functions.getURLMandala(viewModel.etapaAtual, viewModel.diasCompletados, viewModel.listaEtapasMandalas)!,
              width: MediaQuery.sizeOf(context).height < 800.0 ? 180.0 : 250.0,
              height: MediaQuery.sizeOf(context).height < 800.0 ? 180.0 : 250.0,
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Start button
        FFButtonWidget(
          onPressed: () async {
            await viewModel.startDesafio();

            if (!context.mounted) return;
            context.pushNamed(
              DesafioOnboardingPage.routeName,
              extra: <String, dynamic>{
                kTransitionInfoKey: const TransitionInfo(
                  hasTransition: true,
                  transitionType: PageTransitionType.fade,
                  duration: Duration(milliseconds: 0),
                ),
              },
            );
          },
          text: 'Iniciar',
          options: FFButtonOptions(
            height: 40.0,
            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
            iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            color: const Color(0xFFF9A61A),
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
    );
  }

  /// Content shown when desafio has been started
  Widget _buildStartedContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Mandala image
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 32.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              functions.getURLMandala(viewModel.etapaAtual, viewModel.diasCompletados, viewModel.listaEtapasMandalas)!,
              width: MediaQuery.sizeOf(context).height < 800.0 ? 180.0 : 250.0,
              height: MediaQuery.sizeOf(context).height < 800.0 ? 180.0 : 250.0,
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Continue button
        FFButtonWidget(
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
      ],
    );
  }
}
