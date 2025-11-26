import '/data/models/firebase/meditation_model.dart';
import '/ui/core/flutter_flow/flutter_flow_theme.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import '/core/utils/media/audio_utils.dart';
import '/ui/core/flutter_flow/custom_functions.dart' as functions;
import '/data/repositories/auth_repository.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'meditation_card_model.dart';
export 'meditation_card_model.dart';

class MeditationCardWidget extends StatefulWidget {
  const MeditationCardWidget({
    super.key,
    this.docMeditation,
  });

  final MeditationModel? docMeditation;

  @override
  State<MeditationCardWidget> createState() => _MeditationCardWidgetState();
}

class _MeditationCardWidgetState extends State<MeditationCardWidget> {
  late MeditationCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MeditationCardModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _refreshDownloadStatus();
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
    final imageUrl = widget.docMeditation?.imageUrl ?? '';
    final parsedUrl = Uri.tryParse(imageUrl);
    final hasImage = parsedUrl != null && parsedUrl.hasScheme && parsedUrl.host.isNotEmpty;
    final favorites = context.watch<AuthRepository>().currentUser?.favorites.toList() ?? [];

    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        await context.pushNamed(
          MeditationDetailsPage.routeName,
          queryParameters: {
            'meditationId': serializeParam(
              widget.docMeditation?.id,
              ParamType.String,
            ),
          }.withoutNulls,
          extra: <String, dynamic>{
            kTransitionInfoKey: const TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.leftToRight,
            ),
          },
        );
        await _refreshDownloadStatus();
      },
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: FlutterFlowTheme.of(context).primaryBackground,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16.0),
                bottomRight: Radius.circular(0.0),
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(0.0),
              ),
              child: Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(0.0),
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(0.0),
                  ),
                  shape: BoxShape.rectangle,
                ),
                child: hasImage
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16.0),
                          bottomRight: Radius.circular(0.0),
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(0.0),
                        ),
                        child: Image.network(
                          imageUrl,
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const _PlaceholderImage(),
                        ),
                      )
                    : const _PlaceholderImage(),
              ),
            ),
            Container(
              width: MediaQuery.sizeOf(context).width * 0.66,
              height: 100.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 4.0, 2.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      valueOrDefault<String>(
                        widget.docMeditation?.title,
                        'title',
                      ).maybeHandleOverflow(
                        maxChars: 150,
                      ),
                      maxLines: 2,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                            fontSize: 13.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                          ),
                    ),
                    Text(
                      valueOrDefault<String>(
                        widget.docMeditation?.authorName,
                        'author',
                      ),
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                            useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                          ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.98,
                        height: 28.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              valueOrDefault<String>(
                                widget.docMeditation?.callText,
                                'descriçao',
                              ),
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                    fontSize: 11.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        height: 20.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              valueOrDefault<String>(
                                '${widget.docMeditation!.audioDuration.substring(0, 2)}min',
                                'min',
                              ),
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                  ),
                            ),
                            Text(
                              '${widget.docMeditation?.numPlayed.toString()} reproduções',
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                  ),
                            ),
                            if (_model.isDownloaded == true)
                              Icon(
                                Icons.download_done_rounded,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 16.0,
                              ),
                            Container(
                              height: 20.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primaryBackground,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    valueOrDefault<String>(
                                      widget.docMeditation?.numLiked.toString(),
                                      '5',
                                    ),
                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                          fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                        ),
                                  ),
                                  Builder(
                                    builder: (context) {
                                      if (favorites.contains(widget.docMeditation?.id)) {
                                        return Icon(
                                          Icons.favorite,
                                          color: FlutterFlowTheme.of(context).primary,
                                          size: 16.0,
                                        );
                                      } else {
                                        return Icon(
                                          Icons.favorite_border,
                                          color: FlutterFlowTheme.of(context).primary,
                                          size: 16.0,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ].divide(const SizedBox(height: 0.0)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshDownloadStatus() async {
    final audioUrl = widget.docMeditation?.audioUrl ?? '';
    if (audioUrl.isEmpty) return;

    final resolvedPath = functions.getStringFromAudioPath(audioUrl) ?? audioUrl;
    final downloaded = await AudioUtils.isAudioDownloaded(resolvedPath);
    if (!mounted) return;

    _model.isAudioDownloaded = downloaded;
    _model.isDownloaded = downloaded;
    safeSetState(() {});
  }
}

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      color: FlutterFlowTheme.of(context).accent4,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: FlutterFlowTheme.of(context).primary,
        size: 32.0,
      ),
    );
  }
}
