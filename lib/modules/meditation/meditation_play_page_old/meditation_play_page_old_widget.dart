import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'meditation_play_page_old_model.dart';
export 'meditation_play_page_old_model.dart';

class MeditationPlayPageOldWidget extends StatefulWidget {
  const MeditationPlayPageOldWidget({
    super.key,
    required this.meditationDoc,
  });

  final MeditationsRecord? meditationDoc;

  static String routeName = 'meditationPlayPageOld';
  static String routePath = 'meditationPlayPageOld';

  @override
  State<MeditationPlayPageOldWidget> createState() =>
      _MeditationPlayPageOldWidgetState();
}

class _MeditationPlayPageOldWidgetState
    extends State<MeditationPlayPageOldWidget> with TickerProviderStateMixin {
  late MeditationPlayPageOldModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MeditationPlayPageOldModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'meditationPlayPageOld'});
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
                  'Meditação',
                  style: FlutterFlowTheme.of(context).titleLarge.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).titleLargeFamily,
                        color: FlutterFlowTheme.of(context).info,
                        letterSpacing: 0.0,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).titleLargeIsCustom,
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
                    'assets/images/Shiva-08-mobile.jpg',
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
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            24.0, 38.0, 24.0, 32.0),
                        child: Text(
                          valueOrDefault<String>(
                            widget.meditationDoc?.title,
                            'meditação',
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: FlutterFlowTheme.of(context)
                              .titleLarge
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .titleLargeFamily,
                                color: FlutterFlowTheme.of(context).info,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .titleLargeIsCustom,
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
                          child: custom_widgets.AudioPlayerWidget(
                            width: 600.0,
                            height: 600.0,
                            audioTitle: widget.meditationDoc!.title,
                            audioUrl: widget.meditationDoc!.audioUrl,
                            audioArt: widget.meditationDoc!.imageUrl,
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
