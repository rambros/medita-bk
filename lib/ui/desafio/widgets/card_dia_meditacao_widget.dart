import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import 'package:medita_bk/core/enums/enums.dart';
import 'package:medita_bk/core/structs/index.dart';
import 'package:medita_bk/core/utils/media/audio_utils.dart';
import 'package:medita_bk/data/repositories/auth_repository.dart';
import 'package:medita_bk/ui/core/flutter_flow/custom_functions.dart' as functions;
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/ui/pages.dart';
import 'package:medita_bk/ui/desafio/widgets/status_meditacao_widget.dart';

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

  D21MeditationModelStruct? get _meditation => AppStateStore().desafio21.d21Meditations.elementAtOrNull(widget.dia - 1);

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

  bool _canNavigate() {
    final meditation = _meditation;
    if (meditation == null) return false;

    final status = meditation.meditationStatus;

    // Se já está completo, pode abrir
    if (status == D21Status.completed) return true;

    // Se é tester, pode abrir (exceto se estiver closed)
    final isTester = (context.read<AuthRepository>().currentUser?.userRole.toList() ?? [])
        .any((role) => role.toLowerCase() == 'tester');
    if (isTester && status != D21Status.closed) return true;

    // Verifica data de início
    final startDate = AppStateStore().diaInicioDesafio21;
    if (startDate != null && getCurrentTimestamp < startDate) return false;

    // Se está open, verifica as condições
    if (status == D21Status.open) {
      // Dia 1 sempre pode abrir
      if (widget.dia == 1) return true;

      // Verifica se o dia anterior foi completado
      final previousMeditation =
          AppStateStore().desafio21.d21Meditations.elementAtOrNull(widget.dia - 2)?.dateCompleted;
      return functions.checkNextDayMeditation(previousMeditation);
    }

    return false;
  }

  void _navigateToMeditation() {
    if (!_canNavigate()) return;

    context.pushNamed(
      DesafioPlayPage.routeName,
      queryParameters: {
        'indiceListaMeditacao': serializeParam(
          widget.dia - 1,
          ParamType.int,
        ),
      }.withoutNulls,
      extra: <String, dynamic>{
        kTransitionInfoKey: const TransitionInfo(
          hasTransition: true,
          transitionType: PageTransitionType.leftToRight,
        ),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppStateStore>();
    final meditation = _meditation;

    if (meditation == null) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: InkWell(
            onTap: _navigateToMeditation,
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
                        child: () {
                          final imageUrl = meditation.imageUrl;
                          final parsedUrl = Uri.tryParse(imageUrl);
                          final hasValidUrl = parsedUrl != null &&
                                              parsedUrl.hasScheme &&
                                              parsedUrl.host.isNotEmpty;

                          if (hasValidUrl) {
                            return Image.network(
                              imageUrl,
                              width: 200.0,
                              height: 203.0,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 200.0,
                                  height: 203.0,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.self_improvement, color: Colors.grey[600], size: 64),
                                );
                              },
                            );
                          } else {
                            return Container(
                              width: 200.0,
                              height: 203.0,
                              color: Colors.grey[300],
                              child: Icon(Icons.self_improvement, color: Colors.grey[600], size: 64),
                            );
                          }
                        }(),
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
        ),
      ],
    );
  }
}
