import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '/backend/schema/structs/index.dart';
import '/core/utils/media/audio_utils.dart';
import '/ui/core/flutter_flow/custom_functions.dart' as functions;
import '/ui/core/flutter_flow/flutter_flow_theme.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import '/ui/desafio/widgets/status_meditacao_widget.dart';

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
  bool isDownloaded = false;

  D21MeditationModelStruct? get _meditation =>
      FFAppState().desafio21.d21Meditations.elementAtOrNull(widget.dia - 1);

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _checkDownload();
    });
  }

  Future<void> _checkDownload() async {
    final meditation = _meditation;
    if (meditation == null) {
      return;
    }

    final audioPath = functions.getStringFromAudioPath(meditation.audioUrl);
    if (audioPath == null) {
      return;
    }

    final downloaded = await AudioUtils.isAudioDownloaded(audioPath);
    if (!mounted) return;
    setState(() {
      isDownloaded = downloaded;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final meditation = _meditation;

    if (meditation == null) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Container(
            width: MediaQuery.sizeOf(context).width,
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        meditation.imageUrl,
                        width: 200.0,
                        height: 203.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'Dia ${widget.dia}',
                          maxLines: 2,
                          minFontSize: 14.0,
                          style: FlutterFlowTheme.of(context).labelLarge.override(
                                fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                color: FlutterFlowTheme.of(context).info,
                                fontSize: 18.0,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                              ),
                        ),
                        AutoSizeText(
                          meditation.titulo.maybeHandleOverflow(maxChars: 55),
                          maxLines: 2,
                          minFontSize: 14.0,
                          style: FlutterFlowTheme.of(context).labelLarge.override(
                                fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                color: FlutterFlowTheme.of(context).info,
                                fontSize: 18.0,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                              ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              functions.transformSeconds(
                                valueOrDefault<int>(meditation.audioDuration, 120),
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                    color: FlutterFlowTheme.of(context).info,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                  ),
                            ),
                            if (isDownloaded)
                              Icon(
                                Icons.download_done_rounded,
                                color: FlutterFlowTheme.of(context).info,
                                size: 24.0,
                              ),
                          ],
                        ),
                      ],
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
                      StatusMeditacaoWidget(
                        statusMeditacao: meditation.meditationStatus,
                        dia: widget.dia,
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
