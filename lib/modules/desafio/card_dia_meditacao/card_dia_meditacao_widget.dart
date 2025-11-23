import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/modules/desafio/status_meditacao/status_meditacao_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'card_dia_meditacao_model.dart';
export 'card_dia_meditacao_model.dart';

class CardDiaMeditacaoWidget extends StatefulWidget {
  const CardDiaMeditacaoWidget({
    super.key,
    int? dia,
  }) : dia = dia ?? 1;

  final int dia;

  @override
  State<CardDiaMeditacaoWidget> createState() => _CardDiaMeditacaoWidgetState();
}

class _CardDiaMeditacaoWidgetState extends State<CardDiaMeditacaoWidget> {
  late CardDiaMeditacaoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CardDiaMeditacaoModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.isAudioDownloaded = await actions.isAudioDownloaded(
        functions.getStringFromAudioPath(FFAppState()
            .desafio21
            .d21Meditations
            .elementAtOrNull(widget.dia - 1)!
            .audioUrl)!,
      );
      _model.isDownloaded = _model.isAudioDownloaded!;
      safeSetState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Container(
            width: MediaQuery.sizeOf(context).width * 1.0,
            height: 130.0,
            decoration: BoxDecoration(
              border: Border.all(
                color: FlutterFlowTheme.of(context).info,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: const BoxDecoration(),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          FFAppState()
                              .desafio21
                              .d21Meditations
                              .elementAtOrNull(widget.dia - 1)!
                              .imageUrl,
                          width: 200.0,
                          height: 203.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: Container(
                    decoration: const BoxDecoration(),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (false)
                            AutoSizeText(
                              'Dia ${widget.dia.toString()}: ${FFAppState().desafio21.d21Meditations.elementAtOrNull(widget.dia - 1)?.titulo}'
                                  .maybeHandleOverflow(
                                maxChars: 55,
                              ),
                              maxLines: 2,
                              minFontSize: 14.0,
                              style: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelLargeFamily,
                                    color: FlutterFlowTheme.of(context).info,
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .labelLargeIsCustom,
                                  ),
                            ),
                          AutoSizeText(
                            'Dia ${widget.dia.toString()}'.maybeHandleOverflow(
                              maxChars: 55,
                            ),
                            maxLines: 2,
                            minFontSize: 14.0,
                            style: FlutterFlowTheme.of(context)
                                .labelLarge
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .labelLargeFamily,
                                  color: FlutterFlowTheme.of(context).info,
                                  fontSize: 18.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .labelLargeIsCustom,
                                ),
                          ),
                          AutoSizeText(
                            '${FFAppState().desafio21.d21Meditations.elementAtOrNull(widget.dia - 1)?.titulo}'
                                .maybeHandleOverflow(
                              maxChars: 55,
                            ),
                            maxLines: 2,
                            minFontSize: 14.0,
                            style: FlutterFlowTheme.of(context)
                                .labelLarge
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .labelLargeFamily,
                                  color: FlutterFlowTheme.of(context).info,
                                  fontSize: 18.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .labelLargeIsCustom,
                                ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                functions.transformSeconds(valueOrDefault<int>(
                                  FFAppState()
                                      .desafio21
                                      .d21Meditations
                                      .elementAtOrNull(widget.dia - 1)
                                      ?.audioDuration,
                                  120,
                                )),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: FlutterFlowTheme.of(context).info,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                              if (_model.isDownloaded == true)
                                Align(
                                  alignment: const AlignmentDirectional(0.0, 0.0),
                                  child: Icon(
                                    Icons.download_done_rounded,
                                    color: FlutterFlowTheme.of(context).info,
                                    size: 24.0,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      wrapWithModel(
                        model: _model.statusMeditacaoModel,
                        updateCallback: () => safeSetState(() {}),
                        child: StatusMeditacaoWidget(
                          statusMeditacao: FFAppState()
                              .desafio21
                              .d21Meditations
                              .elementAtOrNull(widget.dia - 1)!
                              .meditationStatus,
                          dia: widget.dia,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
