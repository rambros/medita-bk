import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfilePageWidget extends StatefulWidget {
  const ProfilePageWidget({super.key});

  static String routeName = 'profilePage';
  static String routePath = 'profilePage';

  @override
  State<ProfilePageWidget> createState() => _ProfilePageWidgetState();
}

class _ProfilePageWidgetState extends State<ProfilePageWidget> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var hasContainerTriggered1 = false;
  var hasContainerTriggered2 = false;
  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'profilePage'});
    animationsMap.addAll({
      'containerOnActionTriggerAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: false,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 350.0.ms,
            begin: const Offset(40.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnActionTriggerAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: false,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 350.0.ms,
            begin: const Offset(-40.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) => anim.trigger == AnimationTrigger.onActionTrigger || !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
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
        body: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (responsiveVisibility(
                    context: context,
                    tabletLandscape: false,
                    desktop: false,
                  ))
                    Align(
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        height: 44.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        alignment: const AlignmentDirectional(0.0, 0.0),
                      ),
                    ),
                  Align(
                    alignment: const AlignmentDirectional(0.0, 0.0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 32.0, 16.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4.0,
                              color: Color(0x33000000),
                              offset: Offset(
                                0.0,
                                2.0,
                              ),
                            )
                          ],
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        alignment: const AlignmentDirectional(0.0, -1.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 1.0, 0.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 0.0,
                                        color: FlutterFlowTheme.of(context).lineColor,
                                        offset: const Offset(
                                          0.0,
                                          1.0,
                                        ),
                                      )
                                    ],
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(0.0),
                                      bottomRight: Radius.circular(0.0),
                                      topLeft: Radius.circular(16.0),
                                      topRight: Radius.circular(16.0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Your Courses',
                                              style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                    fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                  ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                              child: Text(
                                                'Below you will find a summary of your courses',
                                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                                      fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        FFButtonWidget(
                                          onPressed: () {
                                            print('Button pressed ...');
                                          },
                                          text: 'Add Course',
                                          icon: const Icon(
                                            Icons.add_rounded,
                                            size: 15.0,
                                          ),
                                          options: FFButtonOptions(
                                            width: 150.0,
                                            height: 40.0,
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
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
                                            borderRadius: BorderRadius.circular(50.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 0.0, 0.0),
                                child: Text(
                                  'Account',
                                  style: FlutterFlowTheme.of(context).titleSmall.override(
                                        fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    if (Theme.of(context).brightness == Brightness.light)
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          setDarkModeSetting(context, ThemeMode.dark);
                                          if (animationsMap['containerOnActionTriggerAnimation2'] != null) {
                                            safeSetState(() => hasContainerTriggered2 = true);
                                            SchedulerBinding.instance.addPostFrameCallback((_) async =>
                                                await animationsMap['containerOnActionTriggerAnimation2']!
                                                    .controller
                                                    .forward(from: 0.0));
                                          }
                                        },
                                        child: Container(
                                          width: MediaQuery.sizeOf(context).width * 1.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                            boxShadow: const [
                                              BoxShadow(
                                                blurRadius: 4.0,
                                                color: Color(0x33000000),
                                                offset: Offset(
                                                  0.0,
                                                  2.0,
                                                ),
                                              )
                                            ],
                                            borderRadius: BorderRadius.circular(12.0),
                                            border: Border.all(
                                              color: FlutterFlowTheme.of(context).lineColor,
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 12.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Switch to Dark Mode',
                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                        fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                      ),
                                                ),
                                                Container(
                                                  width: 80.0,
                                                  height: 40.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(context).lineColor,
                                                    borderRadius: BorderRadius.circular(20.0),
                                                  ),
                                                  child: Stack(
                                                    alignment: const AlignmentDirectional(0.0, 0.0),
                                                    children: [
                                                      Align(
                                                        alignment: const AlignmentDirectional(0.95, 0.0),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                                                          child: Icon(
                                                            Icons.nights_stay,
                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                            size: 20.0,
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: const AlignmentDirectional(-0.85, 0.0),
                                                        child: Container(
                                                          width: 36.0,
                                                          height: 36.0,
                                                          decoration: BoxDecoration(
                                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                blurRadius: 4.0,
                                                                color: Color(0x430B0D0F),
                                                                offset: Offset(
                                                                  0.0,
                                                                  2.0,
                                                                ),
                                                              )
                                                            ],
                                                            borderRadius: BorderRadius.circular(30.0),
                                                            shape: BoxShape.rectangle,
                                                          ),
                                                        ).animateOnActionTrigger(
                                                            animationsMap['containerOnActionTriggerAnimation1']!,
                                                            hasBeenTriggered: hasContainerTriggered1),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (Theme.of(context).brightness == Brightness.dark)
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          setDarkModeSetting(context, ThemeMode.light);
                                          if (animationsMap['containerOnActionTriggerAnimation1'] != null) {
                                            safeSetState(() => hasContainerTriggered1 = true);
                                            SchedulerBinding.instance.addPostFrameCallback((_) async =>
                                                await animationsMap['containerOnActionTriggerAnimation1']!
                                                    .controller
                                                    .forward(from: 0.0));
                                          }
                                        },
                                        child: Container(
                                          width: MediaQuery.sizeOf(context).width * 1.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                            boxShadow: const [
                                              BoxShadow(
                                                blurRadius: 4.0,
                                                color: Color(0x33000000),
                                                offset: Offset(
                                                  0.0,
                                                  2.0,
                                                ),
                                              )
                                            ],
                                            borderRadius: BorderRadius.circular(12.0),
                                            border: Border.all(
                                              color: FlutterFlowTheme.of(context).lineColor,
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 12.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Switch to Light Mode',
                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                        fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                      ),
                                                ),
                                                Container(
                                                  width: 80.0,
                                                  height: 40.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(context).lineColor,
                                                    borderRadius: BorderRadius.circular(20.0),
                                                  ),
                                                  child: Stack(
                                                    alignment: const AlignmentDirectional(0.0, 0.0),
                                                    children: [
                                                      Align(
                                                        alignment: const AlignmentDirectional(-0.9, 0.0),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional.fromSTEB(8.0, 2.0, 0.0, 0.0),
                                                          child: Icon(
                                                            Icons.wb_sunny_rounded,
                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                            size: 24.0,
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: const AlignmentDirectional(0.9, 0.0),
                                                        child: Container(
                                                          width: 36.0,
                                                          height: 36.0,
                                                          decoration: BoxDecoration(
                                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                blurRadius: 4.0,
                                                                color: Color(0x430B0D0F),
                                                                offset: Offset(
                                                                  0.0,
                                                                  2.0,
                                                                ),
                                                              )
                                                            ],
                                                            borderRadius: BorderRadius.circular(30.0),
                                                            shape: BoxShape.rectangle,
                                                          ),
                                                        ).animateOnActionTrigger(
                                                            animationsMap['containerOnActionTriggerAnimation2']!,
                                                            hasBeenTriggered: hasContainerTriggered2),
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
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 5.0,
                                        color: Color(0x3416202A),
                                        offset: Offset(
                                          0.0,
                                          2.0,
                                        ),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(12.0),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context).lineColor,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          Icons.language_outlined,
                                          color: FlutterFlowTheme.of(context).secondaryText,
                                          size: 24.0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            'Country',
                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: const AlignmentDirectional(0.9, 0.0),
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              size: 18.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 5.0,
                                        color: Color(0x3416202A),
                                        offset: Offset(
                                          0.0,
                                          2.0,
                                        ),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(12.0),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context).lineColor,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          Icons.account_circle_outlined,
                                          color: FlutterFlowTheme.of(context).secondaryText,
                                          size: 24.0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            'Edit Profile',
                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: const AlignmentDirectional(0.9, 0.0),
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              size: 18.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 0.0, 0.0),
                                child: Text(
                                  'General',
                                  style: FlutterFlowTheme.of(context).titleSmall.override(
                                        fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 5.0,
                                        color: Color(0x3416202A),
                                        offset: Offset(
                                          0.0,
                                          2.0,
                                        ),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(12.0),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context).lineColor,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          Icons.help_outline_rounded,
                                          color: FlutterFlowTheme.of(context).secondaryText,
                                          size: 24.0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            'Support',
                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: const AlignmentDirectional(0.9, 0.0),
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              size: 18.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 5.0,
                                        color: Color(0x3416202A),
                                        offset: Offset(
                                          0.0,
                                          2.0,
                                        ),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(12.0),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context).lineColor,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          Icons.privacy_tip_rounded,
                                          color: FlutterFlowTheme.of(context).secondaryText,
                                          size: 24.0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            'Terms of Service',
                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: const AlignmentDirectional(0.9, 0.0),
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              size: 18.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 24.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 5.0,
                                        color: Color(0x3416202A),
                                        offset: Offset(
                                          0.0,
                                          2.0,
                                        ),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(12.0),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context).lineColor,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          Icons.ios_share,
                                          color: FlutterFlowTheme.of(context).secondaryText,
                                          size: 24.0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            'Invite Friends',
                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: const AlignmentDirectional(0.9, 0.0),
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              size: 18.0,
                                            ),
                                          ),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
