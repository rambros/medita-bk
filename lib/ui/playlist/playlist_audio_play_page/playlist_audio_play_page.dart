import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_animations.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/ui/core/widgets/f_f_audio_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'view_model/playlist_audio_play_page_view_model.dart';

class PlaylistAudioPlayPage extends StatefulWidget {
  const PlaylistAudioPlayPage({
    super.key,
    required this.audio,
    required this.title,
    required this.header,
  });

  final String? audio;
  final String? title;
  final String? header;

  static String routeName = 'playlistAudioPlayPage';
  static String routePath = 'playlistAudioPlayPage';

  @override
  State<PlaylistAudioPlayPage> createState() => _PlaylistAudioPlayPageState();
}

class _PlaylistAudioPlayPageState extends State<PlaylistAudioPlayPage> with TickerProviderStateMixin {
  late PlaylistAudioPlayPageViewModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = PlaylistAudioPlayPageViewModel()..init(context);

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'playlistAudioPlayPage'});
    animationsMap.addAll({
      'imageOnPageLoadAnimation': AnimationInfo(
        loop: true,
        reverse: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.linear,
            delay: 0.0.ms,
            duration: 90000.0.ms,
            begin: const Offset(1.0, 1.0),
            end: const Offset(4.0, 4.0),
          ),
        ],
      ),
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
                  'Música selecionada',
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
                    width: 300.0,
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation']!),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(24.0, 38.0, 24.0, 32.0),
                        child: Text(
                          valueOrDefault<String>(
                            widget.title,
                            'Title',
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: FlutterFlowTheme.of(context).titleLarge.override(
                                fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                                color: FlutterFlowTheme.of(context).info,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
                              ),
                        ),
                      ),
                    ),
                    const Spacer(flex: 4),
                    Flexible(
                      flex: 2,
                      child: Container(
                        width: 600.0,
                        height: 140.0,
                        decoration: const BoxDecoration(),
                        child: SizedBox(
                          width: 600.0,
                          height: 600.0,
                          child: FFAudioPlayerWidget(
                            width: 600.0,
                            height: 600.0,
                            audioTitle: widget.title!,
                            audioUrl: widget.audio!,
                            audioArt:
                                'https://firebasestorage.googleapis.com/v0/b/meditabk2020.appspot.com/o/cms_uploads%2Fimages%2F1660244657182000%2Fanubhav-saxena-HAGq70L1MXc-unsplash.jpg?alt=media&token=e5b9ef63-5347-4e64-99c1-3ccbe36a5f6a',
                            colorButton: FlutterFlowTheme.of(context).info,
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
