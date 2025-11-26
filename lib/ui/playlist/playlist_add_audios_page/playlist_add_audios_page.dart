import '/core/structs/index.dart';
import '/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import '/ui/core/flutter_flow/flutter_flow_theme.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import '/ui/core/flutter_flow/flutter_flow_widgets.dart';
import '/ui/playlist/select_audio_dialog/select_audio_dialog.dart';
import '/ui/core/utils/ui_utils.dart';
import '/ui/core/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'view_model/playlist_add_audios_page_view_model.dart';

class PlaylistAddAudiosPage extends StatefulWidget {
  const PlaylistAddAudiosPage({super.key});

  static String routeName = 'playlistAddAudiosPage';
  static String routePath = 'playlistAddAudiosPage';

  @override
  State<PlaylistAddAudiosPage> createState() => _PlaylistAddAudiosPageState();
}

class _PlaylistAddAudiosPageState extends State<PlaylistAddAudiosPage> {
  late PlaylistAddAudiosPageViewModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = PlaylistAddAudiosPageViewModel()..init(context);

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'playlistAddAudiosPage'});
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
                  'Criar uma Playlist',
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: MediaQuery.sizeOf(context).height * 0.94,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 4.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
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
                                                child: const SelectAudioDialogWidget(),
                                              ),
                                            ),
                                          );
                                        },
                                      ).then((value) => safeSetState(() {}));
                                    },
                                    text: 'Incluir Som/Música/Silêncio',
                                    options: FFButtonOptions(
                                      height: 40.0,
                                      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                      color: FlutterFlowTheme.of(context).primary,
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
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Builder(
                                builder: (context) {
                                  final listAudios = AppStateStore().listAudiosSelected.toList();

                                  return InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onLongPress: () async {},
                                    child: ReorderableListView.builder(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      proxyDecorator: (Widget child, int index, Animation<double> animation) =>
                                          Material(color: Colors.transparent, child: child),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: listAudios.length,
                                      itemBuilder: (context, listAudiosIndex) {
                                        final listAudiosItem = listAudios[listAudiosIndex];
                                        return Container(
                                          key: ValueKey('ListView_h62s1qyo_${listAudiosIndex.toString()}'),
                                          child: Align(
                                            alignment: const AlignmentDirectional(0.0, 0.0),
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 4.0),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                  borderRadius: BorderRadius.circular(8.0),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(context).primary,
                                                    width: 2.0,
                                                  ),
                                                ),
                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                child: Align(
                                                  alignment: const AlignmentDirectional(0.0, 0.0),
                                                  child: Padding(
                                                    padding: const EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 8.0, 8.0),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.max,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsetsDirectional.fromSTEB(
                                                                    0.0, 0.0, 0.0, 2.0),
                                                                child: Text(
                                                                  functions.getAudioType(listAudiosItem.audioType),
                                                                  style: FlutterFlowTheme.of(context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily: FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                        fontSize: 12.0,
                                                                        letterSpacing: 0.0,
                                                                        useGoogleFonts: !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                      ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsetsDirectional.fromSTEB(
                                                                    0.0, 0.0, 0.0, 2.0),
                                                                child: Text(
                                                                  listAudiosItem.title,
                                                                  style: FlutterFlowTheme.of(context)
                                                                      .bodyLarge
                                                                      .override(
                                                                        fontFamily: FlutterFlowTheme.of(context)
                                                                            .bodyLargeFamily,
                                                                        fontSize: 12.0,
                                                                        letterSpacing: 0.0,
                                                                        useGoogleFonts: !FlutterFlowTheme.of(context)
                                                                            .bodyLargeIsCustom,
                                                                      ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsetsDirectional.fromSTEB(
                                                                    0.0, 0.0, 0.0, 2.0),
                                                                child: Text(
                                                                  functions.transformSeconds(listAudiosItem.duration),
                                                                  style: FlutterFlowTheme.of(context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily: FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                        fontSize: 12.0,
                                                                        letterSpacing: 0.0,
                                                                        useGoogleFonts: !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons.play_arrow,
                                                          color: FlutterFlowTheme.of(context).primary,
                                                          size: 38.0,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      onReorder: (int reorderableOldIndex, int reorderableNewIndex) async {
                                        _model.newList = await UIUtils.reorderItems(
                                          listAudios.toList(),
                                          reorderableNewIndex,
                                          reorderableOldIndex,
                                        );
                                        AppStateStore().listAudiosSelected =
                                            _model.newList!.toList().cast<AudioModelStruct>();
                                        safeSetState(() {});

                                        safeSetState(() {});
                                      },
                                    ),
                                  );
                                },
                              ),
                              Builder(
                                builder: (context) {
                                  if (AppStateStore().listAudiosSelected.isNotEmpty) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 4.0),
                                          child: Text(
                                            '(Arraste para deletar, pressione para ordenar)',
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                  fontSize: 12.0,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 4.0),
                                          child: Text(
                                            'Esta playlist está com uma duração de ${functions.transformSeconds(functions.getDurationPlaylist(AppStateStore().listAudiosSelected.toList())!)}',
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(32.0, 16.0, 32.0, 16.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    context.pushNamed(
                                                      PlaylistSavePage.routeName,
                                                      extra: <String, dynamic>{
                                                        kTransitionInfoKey: const TransitionInfo(
                                                          hasTransition: true,
                                                          transitionType: PageTransitionType.fade,
                                                          duration: Duration(milliseconds: 0),
                                                        ),
                                                      },
                                                    );
                                                  },
                                                  text: 'Salvar Playlist',
                                                  options: FFButtonOptions(
                                                    height: 40.0,
                                                    padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                                    iconPadding:
                                                        const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                    color: FlutterFlowTheme.of(context).primary,
                                                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                          fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                                          color: Colors.white,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme.of(context).titleSmallIsCustom,
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
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                                      child: Text(
                                        'Monte sua Playlist incluindo sons e músicas.',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                            ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
