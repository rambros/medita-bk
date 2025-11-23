import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/modules/meditation/comment_dialog/comment_dialog_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'meditation_details_page_model.dart';
export 'meditation_details_page_model.dart';

class MeditationDetailsPageWidget extends StatefulWidget {
  const MeditationDetailsPageWidget({
    super.key,
    required this.meditationDocRef,
  });

  final DocumentReference? meditationDocRef;

  static String routeName = 'meditationDetailsPage';
  static String routePath = 'meditationDetailsPage';

  @override
  State<MeditationDetailsPageWidget> createState() =>
      _MeditationDetailsPageWidgetState();
}

class _MeditationDetailsPageWidgetState
    extends State<MeditationDetailsPageWidget> {
  late MeditationDetailsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MeditationDetailsPageModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'meditationDetailsPage'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.meditationDoc =
          await MeditationsRecord.getDocumentOnce(widget.meditationDocRef!);
      _model.isDownloaded = await actions.isAudioDownloaded(
        functions.getStringFromAudioPath(_model.meditationDoc!.audioUrl)!,
      );
      _model.isAudioDownloaded = _model.isDownloaded!;
      _model.favorito = (currentUserDocument?.favorites.toList() ?? [])
              .contains(_model.meditationDoc?.documentId)
          ? true
          : false;
      safeSetState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MeditationsRecord>(
      stream: MeditationsRecord.getDocument(widget.meditationDocRef!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }

        final meditationDetailsPageMeditationsRecord = snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: responsiveVisibility(
              context: context,
              tabletLandscape: false,
              desktop: false,
            )
                ? AppBar(
                    backgroundColor: FlutterFlowTheme.of(context).primary,
                    automaticallyImplyLeading: false,
                    leading: FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 30.0,
                      borderWidth: 1.0,
                      buttonSize: 60.0,
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: FlutterFlowTheme.of(context).info,
                        size: 30.0,
                      ),
                      onPressed: () async {
                        context.pop();
                      },
                    ),
                    title: Text(
                      'Detalhes da Meditação',
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).titleLargeFamily,
                            color: FlutterFlowTheme.of(context).info,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .titleLargeIsCustom,
                          ),
                    ),
                    actions: const [],
                    centerTitle: true,
                    elevation: 2.0,
                  )
                : null,
            body: SafeArea(
              top: true,
              child: Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: MediaQuery.sizeOf(context).height * 0.94,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 8.0),
                        child: Text(
                          meditationDetailsPageMeditationsRecord.title,
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .headlineMediumFamily,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .headlineMediumIsCustom,
                              ),
                        ),
                      ),
                      Text(
                        meditationDetailsPageMeditationsRecord.authorName,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 4.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              valueOrDefault<String>(
                                meditationDetailsPageMeditationsRecord
                                    .audioDuration,
                                '00:00',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                            Text(
                              '${meditationDetailsPageMeditationsRecord.numPlayed.toString()} reproduções',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                            Container(
                              width: 40.0,
                              height: 28.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    meditationDetailsPageMeditationsRecord
                                        .numLiked
                                        .toString(),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                  Icon(
                                    Icons.favorite,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 16.0,
                                  ),
                                ],
                              ),
                            ),
                            if (_model.isAudioDownloaded == true)
                              Align(
                                alignment: const AlignmentDirectional(1.0, -1.0),
                                child: Icon(
                                  Icons.download_done,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 26.0,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.9,
                        height: MediaQuery.sizeOf(context).height * 0.36,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        child: Stack(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Image.network(
                                meditationDetailsPageMeditationsRecord.imageUrl,
                                width: MediaQuery.sizeOf(context).width * 1.0,
                                height: MediaQuery.sizeOf(context).height * 1.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                var shouldSetState = false;
                                _model.hasInternetAccess =
                                    await actions.hasInternetAccess();
                                shouldSetState = true;
                                if (_model.hasInternetAccess == true) {
                                  _model.numPlayed =
                                      meditationDetailsPageMeditationsRecord
                                          .numPlayed;
                                  safeSetState(() {});
                                  // tem bug no update with increment que transforma em double.
                                  // jogo valor do numPlayed para um pageState e increment este depois update no filed numPlayed

                                  await meditationDetailsPageMeditationsRecord
                                      .reference
                                      .update(createMeditationsRecordData(
                                    numPlayed: (_model.numPlayed!) + 1,
                                  ));
                                } else {
                                  if (_model.isAudioDownloaded != true) {
                                    await showDialog(
                                      context: context,
                                      builder: (alertDialogContext) {
                                        return WebViewAware(
                                          child: AlertDialog(
                                            title:
                                                const Text('Sem acesso à internet'),
                                            content: const Text(
                                                'Parece que você está offline. Conecte-se à internet para continuar sua jornada com o MeditaBK.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    alertDialogContext),
                                                child: const Text('Ok'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                    if (shouldSetState) safeSetState(() {});
                                    return;
                                  }
                                }

                                context.pushNamed(
                                  MeditationPlayPageWidget.routeName,
                                  queryParameters: {
                                    'meditationDoc': serializeParam(
                                      meditationDetailsPageMeditationsRecord,
                                      ParamType.Document,
                                    ),
                                  }.withoutNulls,
                                  extra: <String, dynamic>{
                                    'meditationDoc':
                                        meditationDetailsPageMeditationsRecord,
                                    kTransitionInfoKey: const TransitionInfo(
                                      hasTransition: true,
                                      transitionType:
                                          PageTransitionType.leftToRight,
                                    ),
                                  },
                                );

                                if (shouldSetState) safeSetState(() {});
                              },
                              child: const Icon(
                                Icons.play_circle_outline_rounded,
                                color: Color(0xFEFFFFFF),
                                size: 72.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            16.0, 8.0, 16.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 2.0),
                              child: Text(
                                meditationDetailsPageMeditationsRecord
                                    .detailsText,
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodySmallFamily,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodySmallIsCustom,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Texto:  ${meditationDetailsPageMeditationsRecord.authorText}',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                      Text(
                        'Voz: ${meditationDetailsPageMeditationsRecord.authorName}',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                      Text(
                        'Música: ${meditationDetailsPageMeditationsRecord.authorMusic}',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: const Color(0x91000000),
                                context: context,
                                builder: (context) {
                                  return WebViewAware(
                                    child: GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      child: Padding(
                                        padding:
                                            MediaQuery.viewInsetsOf(context),
                                        child: CommentDialogWidget(
                                          meditationRef:
                                              widget.meditationDocRef!,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ).then((value) => safeSetState(() {}));

                              safeSetState(() {});
                            },
                            child: Icon(
                              Icons.comment_rounded,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 32.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                2.0, 0.0, 0.0, 0.0),
                            child: Text(
                              meditationDetailsPageMeditationsRecord
                                  .comments.length
                                  .toString(),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                          ),
                          Container(
                            width: 70.0,
                            height: 16.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          ToggleIcon(
                            onPressed: () async {
                              safeSetState(
                                  () => _model.favorito = !_model.favorito);
                              // tem bug no update with increment que transforma em double.
                              // jogo valor do numLiked para um pageState e increment este depois update no filed numLiked
                              _model.numLiked =
                                  meditationDetailsPageMeditationsRecord
                                      .numLiked;
                              safeSetState(() {});
                              if (_model.favorito == true) {
                                await widget.meditationDocRef!
                                    .update(createMeditationsRecordData(
                                  numLiked: (_model.numLiked!) + 1,
                                ));

                                safeSetState(() {});

                                await currentUserReference!.update({
                                  ...mapToFirestore(
                                    {
                                      'favorites': FieldValue.arrayUnion(
                                          [widget.meditationDocRef?.id]),
                                    },
                                  ),
                                });
                              } else {
                                await widget.meditationDocRef!
                                    .update(createMeditationsRecordData(
                                  numLiked: (_model.numLiked!) - 1,
                                ));

                                safeSetState(() {});

                                await currentUserReference!.update({
                                  ...mapToFirestore(
                                    {
                                      'favorites': FieldValue.arrayRemove([
                                        meditationDetailsPageMeditationsRecord
                                            .documentId
                                      ]),
                                    },
                                  ),
                                });
                              }
                            },
                            value: _model.favorito,
                            onIcon: Icon(
                              Icons.favorite_sharp,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 36.0,
                            ),
                            offIcon: Icon(
                              Icons.favorite_border,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 36.0,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 1.0,
                        indent: 16.0,
                        endIndent: 16.0,
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                      Builder(
                        builder: (context) {
                          if (meditationDetailsPageMeditationsRecord
                                  .comments.isNotEmpty) {
                            return Builder(
                              builder: (context) {
                                final comments =
                                    meditationDetailsPageMeditationsRecord
                                        .comments
                                        .toList();

                                return ListView.separated(
                                  padding: EdgeInsets.zero,
                                  reverse: true,
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: comments.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 8.0),
                                  itemBuilder: (context, commentsIndex) {
                                    final commentsItem =
                                        comments[commentsIndex];
                                    return Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 8.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Flexible(
                                              flex: 3,
                                              child: Container(
                                                width: 60.0,
                                                height: 60.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Builder(
                                                  builder: (context) {
                                                    if (commentsItem
                                                                .userImageUrl !=
                                                            '') {
                                                      return ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50.0),
                                                        child: Image.network(
                                                          commentsItem
                                                              .userImageUrl,
                                                          width: 100.0,
                                                          height: 100.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      );
                                                    } else {
                                                      return Icon(
                                                        Icons.location_history,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 50.0,
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 11,
                                              child: Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        8.0, 0.0, 8.0, 0.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      commentsItem.userName,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                    ),
                                                    Text(
                                                      valueOrDefault<String>(
                                                        functions.dataExtenso(
                                                            commentsItem
                                                                .commentDate),
                                                        'data do comentário',
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodySmall
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmallFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmallIsCustom,
                                                          ),
                                                    ),
                                                    Text(
                                                      commentsItem.comment,
                                                      maxLines: 6,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodySmall
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmallFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmallIsCustom,
                                                          ),
                                                    ),
                                                  ].divide(
                                                      const SizedBox(height: 4.0)),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  var confirmDialogResponse =
                                                      await showDialog<bool>(
                                                            context: context,
                                                            builder:
                                                                (alertDialogContext) {
                                                              return WebViewAware(
                                                                child:
                                                                    AlertDialog(
                                                                  title: const Text(
                                                                      'Confirmação'),
                                                                  content: const Text(
                                                                      'Tem certeza que quer deletar seu comentário?'),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed: () => Navigator.pop(
                                                                          alertDialogContext,
                                                                          false),
                                                                      child: const Text(
                                                                          'Cancelar'),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed: () => Navigator.pop(
                                                                          alertDialogContext,
                                                                          true),
                                                                      child: const Text(
                                                                          'Confirmar'),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ) ??
                                                          false;
                                                  if (confirmDialogResponse) {
                                                    await widget
                                                        .meditationDocRef!
                                                        .update({
                                                      ...mapToFirestore(
                                                        {
                                                          'comments': FieldValue
                                                              .arrayRemove([
                                                            getCommentFirestoreData(
                                                              updateCommentStruct(
                                                                commentsItem,
                                                                clearUnsetFields:
                                                                    false,
                                                              ),
                                                              true,
                                                            )
                                                          ]),
                                                        },
                                                      ),
                                                    });
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 24.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Seja o primeiro a comentar...',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ].divide(const SizedBox(height: 4.0)),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
