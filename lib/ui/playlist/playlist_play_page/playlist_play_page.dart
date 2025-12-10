import 'package:medita_b_k/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import 'package:medita_b_k/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_b_k/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_b_k/ui/core/widgets/f_f_playlist_player_widget.dart';
import 'package:medita_b_k/ui/core/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_model/playlist_play_page_view_model.dart';

class PlaylistPlayPage extends StatefulWidget {
  const PlaylistPlayPage({super.key});

  static String routeName = 'playlistPlayPage';
  static String routePath = 'playlistPlayPage';

  @override
  State<PlaylistPlayPage> createState() => _PlaylistPlayPageState();
}

class _PlaylistPlayPageState extends State<PlaylistPlayPage> {
  late PlaylistPlayPageViewModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = PlaylistPlayPageViewModel()..init(context);

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'playlistPlayPage'});
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppStateStore>();

    return PopScope(
      canPop: false,
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
                  'Playlist',
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
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/images/Shiva-12-new.jpg',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 24.0, 8.0),
                          child: Text(
                            AppStateStore().tempPlaylist.title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: FlutterFlowTheme.of(context).titleLarge.override(
                                  fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                                  color: FlutterFlowTheme.of(context).info,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 8.0),
                          child: Text(
                            'Duração total desta playlist  ${functions.transformSeconds(AppStateStore().tempPlaylist.duration)}',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: FlutterFlowTheme.of(context).titleLarge.override(
                                  fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                                  color: FlutterFlowTheme.of(context).info,
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
                                ),
                          ),
                        ),
                        Container(
                          height: 400.0,
                          decoration: const BoxDecoration(),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lista de áudios desta playlist',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                        color: FlutterFlowTheme.of(context).primaryBackground,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                      ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                                    child: Builder(
                                      builder: (context) {
                                        final listAudiosChecked = AppStateStore().listAudiosReadyToPlay.toList();

                                        return ListView.separated(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: listAudiosChecked.length,
                                          separatorBuilder: (_, __) => const SizedBox(height: 8.0),
                                          itemBuilder: (context, listAudiosCheckedIndex) {
                                            final listAudiosCheckedItem = listAudiosChecked[listAudiosCheckedIndex];
                                            return Text(
                                              '${listAudiosCheckedItem.title} - ${functions.transformSeconds(listAudiosCheckedItem.duration)}',
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                    color: FlutterFlowTheme.of(context).primaryBackground,
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                  ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                        child: Container(
                          width: 600.0,
                          height: 180.0,
                          decoration: const BoxDecoration(),
                          child: SizedBox(
                            width: 400.0,
                            height: 400.0,
                            child: FFPlaylistPlayerWidget(
                              width: 400.0,
                              height: 400.0,
                              playlistTitle: AppStateStore().tempPlaylist.title,
                              playlistArt: AppStateStore().tempPlaylist.imageUrl,
                              colorButton: FlutterFlowTheme.of(context).primary,
                              listAudios: AppStateStore().listAudiosReadyToPlay,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
