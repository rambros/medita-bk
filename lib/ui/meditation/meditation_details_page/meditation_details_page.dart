import 'package:medita_bk/core/structs/comment_struct.dart';
import 'package:medita_bk/data/models/firebase/meditation_model.dart';
import 'package:medita_bk/data/repositories/meditation_repository.dart';
import 'package:medita_bk/data/repositories/user_repository.dart';
import 'package:medita_bk/data/services/firebase/firestore_service.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_toggle_icon.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/ui/meditation/widgets/comment_dialog.dart';
import 'package:medita_bk/core/utils/network_utils.dart';
import 'package:medita_bk/core/utils/media/audio_utils.dart';
import 'package:medita_bk/ui/core/flutter_flow/custom_functions.dart' as functions;
import 'package:medita_bk/data/repositories/auth_repository.dart';
import 'package:medita_bk/ui/pages.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MeditationDetailsPage extends StatefulWidget {
  const MeditationDetailsPage({
    super.key,
    required this.meditationDocRef,
  });

  final DocumentReference? meditationDocRef;

  static String routeName = 'meditationDetailsPage';
  static String routePath = 'meditationDetailsPage';

  @override
  State<MeditationDetailsPage> createState() => _MeditationDetailsPageState();
}

class _MeditationDetailsPageState extends State<MeditationDetailsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FirestoreService _firestoreService = FirestoreService();
  final MeditationRepository _meditationRepository = MeditationRepositoryImpl();
  final UserRepository _userRepository = UserRepository();

  // Local state
  MeditationModel? _meditationDoc;
  bool _isAudioDownloaded = false;
  bool _isFavorite = false;
  String? _lastCheckedAudioUrl;

  @override
  void initState() {
    super.initState();

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'meditationDetailsPage'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final meditationRef = widget.meditationDocRef;
      if (meditationRef == null) {
        return;
      }
      _meditationDoc = await _meditationRepository.getMeditationById(meditationRef.id);
      if (!mounted) return;
      await _checkDownloadStatus(_meditationDoc?.audioUrl);
      // TODO: Migrate isAudioDownloaded to AudioService
      // final isDownloaded = await actions.isAudioDownloaded(
      //   functions.getStringFromAudioPath(_meditationDoc!.audioUrl)!,
      // );
      // _isAudioDownloaded = isDownloaded;
      final userFavorites = context.read<AuthRepository>().currentUser?.favorites.toList() ?? [];
      _isFavorite = userFavorites.contains(_meditationDoc?.documentId);
      safeSetState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _checkDownloadStatus(String? audioUrl) async {
    if (audioUrl == null || audioUrl.trim().isEmpty) return;
    if (_lastCheckedAudioUrl == audioUrl && _isAudioDownloaded) return;

    _lastCheckedAudioUrl = audioUrl;

    final resolvedPath = functions.getStringFromAudioPath(audioUrl) ?? audioUrl;
    final downloaded = await AudioUtils.isAudioDownloaded(resolvedPath);
    if (!mounted) return;
    if (downloaded != _isAudioDownloaded) {
      setState(() {
        _isAudioDownloaded = downloaded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.meditationDocRef == null) {
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Meditação não encontrada.',
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
          ),
        ),
      );
    }

    return StreamBuilder<MeditationModel?>(
      stream: _meditationRepository.streamMeditationById(widget.meditationDocRef!.id),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData || snapshot.data == null) {
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

        final meditationDetailsPageMeditation = snapshot.data!;
        SchedulerBinding.instance.addPostFrameCallback(
          (_) => _checkDownloadStatus(meditationDetailsPageMeditation.audioUrl),
        );

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
                            fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                            color: FlutterFlowTheme.of(context).info,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
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
                        padding: const EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 8.0),
                        child: Text(
                          meditationDetailsPageMeditation.title,
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context).headlineMedium.override(
                                fontFamily: FlutterFlowTheme.of(context).headlineMediumFamily,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context).headlineMediumIsCustom,
                              ),
                        ),
                      ),
                      Text(
                        meditationDetailsPageMeditation.authorName,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                            ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 4.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              valueOrDefault<String>(
                                meditationDetailsPageMeditation.audioDuration,
                                '00:00',
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                  ),
                            ),
                            Text(
                              '${meditationDetailsPageMeditation.numPlayed.toString()} reproduções',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                  ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  meditationDetailsPageMeditation.numLiked.toString(),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                      ),
                                ),
                                const SizedBox(width: 2),
                                Icon(
                                  Icons.favorite,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 16.0,
                                ),
                              ],
                            ),
                            if (_isAudioDownloaded == true)
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
                            Builder(builder: (context) {
                              final imageUrl = meditationDetailsPageMeditation.imageUrl;
                              final parsedUrl = Uri.tryParse(imageUrl);
                              final hasImage = parsedUrl != null && parsedUrl.hasScheme && parsedUrl.host.isNotEmpty;
                              if (!hasImage) {
                                return Container(
                                  width: double.infinity,
                                  height: MediaQuery.sizeOf(context).height * 1.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).accent4,
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 48.0,
                                  ),
                                );
                              }
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Image.network(
                                  imageUrl,
                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                  height: MediaQuery.sizeOf(context).height * 1.0,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: double.infinity,
                                    height: MediaQuery.sizeOf(context).height * 1.0,
                                    color: FlutterFlowTheme.of(context).accent4,
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.broken_image_outlined,
                                      color: FlutterFlowTheme.of(context).primary,
                                      size: 48.0,
                                    ),
                                  ),
                                ),
                              );
                            }),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                var shouldSetState = false;
                                final hasInternetAccess = await NetworkUtils.hasInternetAccess();
                                shouldSetState = true;
                                if (hasInternetAccess == true) {
                                final numPlayed = meditationDetailsPageMeditation.numPlayed;
                                await _firestoreService.updateDocument(
                                  collectionPath: 'meditations',
                                  documentId: meditationDetailsPageMeditation.id,
                                  data: {'numPlayed': numPlayed + 1},
                                );
                                } else {
                                  if (_isAudioDownloaded != true) {
                                    if (!context.mounted) return;
                                    await showDialog(
                                      context: context,
                                      builder: (alertDialogContext) {
                                        return AlertDialog(
                                          title: const Text('Sem acesso à internet'),
                                          content: const Text(
                                              'Parece que você está offline. Conecte-se à internet para continuar sua jornada com o MeditaBK.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(alertDialogContext),
                                              child: const Text('Ok'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (shouldSetState) safeSetState(() {});
                                    return;
                                  }
                                }

                                if (!context.mounted) return;
                                context.pushNamed(
                                  MeditationPlayPage.routeName,
                                  queryParameters: {
                                    'meditationId': serializeParam(
                                      meditationDetailsPageMeditation.id,
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                  extra: <String, dynamic>{
                                    'meditationId': meditationDetailsPageMeditation.id,
                                    kTransitionInfoKey: const TransitionInfo(
                                      hasTransition: true,
                                      transitionType: PageTransitionType.leftToRight,
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
                        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 2.0),
                              child: Text(
                                meditationDetailsPageMeditation.detailsText,
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                      fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Texto:  ${meditationDetailsPageMeditation.authorText}',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                            ),
                      ),
                      Text(
                        'Voz: ${meditationDetailsPageMeditation.authorName}',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                            ),
                      ),
                      Text(
                        'Música: ${meditationDetailsPageMeditation.authorMusic}',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
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
                                  return GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      FocusManager.instance.primaryFocus?.unfocus();
                                    },
                                    child: Padding(
                                      padding: MediaQuery.viewInsetsOf(context),
                                      child: CommentDialogWidget(
                                        meditationRef: widget.meditationDocRef!,
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
                            padding: const EdgeInsetsDirectional.fromSTEB(2.0, 0.0, 0.0, 0.0),
                            child: Text(
                              meditationDetailsPageMeditation.comments.length.toString(),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                  ),
                            ),
                          ),
                          Container(
                            width: 70.0,
                            height: 16.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primaryBackground,
                            ),
                          ),
                          ToggleIcon(
                            onPressed: () async {
                              final userId = context.read<AuthRepository>().currentUserUid;
                              if (userId.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Faça login para curtir meditações.',
                                      style: FlutterFlowTheme.of(context).titleSmall.override(
                                            fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                            color: FlutterFlowTheme.of(context).info,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                          ),
                                    ),
                                    backgroundColor: FlutterFlowTheme.of(context).primary,
                                  ),
                                );
                                return;
                              }
                              safeSetState(() => _isFavorite = !_isFavorite);

                              if (_isFavorite == true) {
                                await _meditationRepository.incrementLikeCount(meditationDetailsPageMeditation.id);
                                await _userRepository.addToFavorites(userId, meditationDetailsPageMeditation.id);
                              } else {
                                await _meditationRepository.decrementLikeCount(meditationDetailsPageMeditation.id);
                                await _userRepository.removeFromFavorites(userId, meditationDetailsPageMeditation.id);
                              }
                            },
                            value: _isFavorite,
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
                          if (meditationDetailsPageMeditation.comments.isNotEmpty) {
                            return Builder(
                              builder: (context) {
                                final comments = meditationDetailsPageMeditation.comments.toList();

                                return ListView.separated(
                                  padding: EdgeInsets.zero,
                                  reverse: true,
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: comments.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 8.0),
                                  itemBuilder: (context, commentsIndex) {
                                    final commentsItem = comments[commentsIndex];
                                    return Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      color: FlutterFlowTheme.of(context).primaryBackground,
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 8.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Flexible(
                                              flex: 3,
                                              child: Container(
                                                width: 60.0,
                                                height: 60.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(context).primaryBackground,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Builder(
                                                  builder: (context) {
                                                    if (commentsItem.userImageUrl != '') {
                                                      return ClipRRect(
                                                        borderRadius: BorderRadius.circular(50.0),
                                                        child: Image.network(
                                                          commentsItem.userImageUrl,
                                                          width: 100.0,
                                                          height: 100.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      );
                                                    } else {
                                                      return Icon(
                                                        Icons.location_history,
                                                        color: FlutterFlowTheme.of(context).primaryText,
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
                                                padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      commentsItem.userName,
                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                          ),
                                                    ),
                                                    Text(
                                                      valueOrDefault<String>(
                                                        functions.dataExtenso(commentsItem.commentDate),
                                                        'data do comentário',
                                                      ),
                                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                                            fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                          ),
                                                    ),
                                                    Text(
                                                      commentsItem.comment,
                                                      maxLines: 6,
                                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                                            fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                          ),
                                                    ),
                                                  ].divide(const SizedBox(height: 4.0)),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor: Colors.transparent,
                                                onTap: () async {
                                                  var confirmDialogResponse = await showDialog<bool>(
                                                        context: context,
                                                        builder: (alertDialogContext) {
                                                          return AlertDialog(
                                                            title: const Text('Confirmação'),
                                                            content: const Text(
                                                                'Tem certeza que quer deletar seu comentário?'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(alertDialogContext, false),
                                                                child: const Text('Cancelar'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(alertDialogContext, true),
                                                                child: const Text('Confirmar'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ) ??
                                                      false;
                                                  if (confirmDialogResponse) {
                                                    await _firestoreService.updateDocument(
                                                      collectionPath: 'meditations',
                                                      documentId: meditationDetailsPageMeditation.id,
                                                      data: {
                                                        'comments': FieldValue.arrayRemove([
                                                          getCommentFirestoreData(
                                                            updateCommentStruct(
                                                              commentsItem,
                                                              clearUnsetFields: false,
                                                            ),
                                                            true,
                                                          )
                                                        ]),
                                                      },
                                                    );
                                                 }
                                               },
                                                child: Icon(
                                                  Icons.delete,
                                                  color: FlutterFlowTheme.of(context).primary,
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
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Seja o primeiro a comentar...',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
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
