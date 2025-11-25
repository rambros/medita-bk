import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '/ui/core/flutter_flow/flutter_flow_animations.dart';
import '/ui/core/flutter_flow/flutter_flow_theme.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';

/// Theme toggle widget that switches between light and dark modes
/// Includes animated toggle switch
class ThemeToggleWidget extends StatelessWidget {
  final Map<String, AnimationInfo> animationsMap;
  final bool hasContainerTriggered1;
  final bool hasContainerTriggered2;
  final Function(bool) onTrigger1Changed;
  final Function(bool) onTrigger2Changed;

  const ThemeToggleWidget({
    super.key,
    required this.animationsMap,
    required this.hasContainerTriggered1,
    required this.hasContainerTriggered2,
    required this.onTrigger1Changed,
    required this.onTrigger2Changed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          if (isLightMode) {
            // Switch to dark mode
            setDarkModeSetting(context, ThemeMode.dark);
            if (animationsMap['containerOnActionTriggerAnimation2'] != null) {
              onTrigger2Changed(true);
              SchedulerBinding.instance.addPostFrameCallback((_) async =>
                  await animationsMap['containerOnActionTriggerAnimation2']!.controller.forward(from: 0.0));
            }
          } else {
            // Switch to light mode
            setDarkModeSetting(context, ThemeMode.light);
            if (animationsMap['containerOnActionTriggerAnimation1'] != null) {
              onTrigger1Changed(true);
              SchedulerBinding.instance.addPostFrameCallback((_) async =>
                  await animationsMap['containerOnActionTriggerAnimation1']!.controller.forward(from: 0.0));
            }
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
                offset: Offset(0.0, 2.0),
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
                  isLightMode ? 'Switch to Dark Mode' : 'Switch to Light Mode',
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
                      // Icon (moon for light mode, sun for dark mode)
                      Align(
                        alignment:
                            isLightMode ? const AlignmentDirectional(0.95, 0.0) : const AlignmentDirectional(-0.9, 0.0),
                        child: Padding(
                          padding: isLightMode
                              ? const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0)
                              : const EdgeInsetsDirectional.fromSTEB(8.0, 2.0, 0.0, 0.0),
                          child: Icon(
                            isLightMode ? Icons.nights_stay : Icons.wb_sunny_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: isLightMode ? 20.0 : 24.0,
                          ),
                        ),
                      ),
                      // Animated toggle button
                      Align(
                        alignment:
                            isLightMode ? const AlignmentDirectional(-0.85, 0.0) : const AlignmentDirectional(0.9, 0.0),
                        child: Container(
                          width: 36.0,
                          height: 36.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 4.0,
                                color: Color(0x430B0D0F),
                                offset: Offset(0.0, 2.0),
                              )
                            ],
                            borderRadius: BorderRadius.circular(30.0),
                            shape: BoxShape.rectangle,
                          ),
                        ).animateOnActionTrigger(
                          isLightMode
                              ? animationsMap['containerOnActionTriggerAnimation1']!
                              : animationsMap['containerOnActionTriggerAnimation2']!,
                          hasBeenTriggered: isLightMode ? hasContainerTriggered1 : hasContainerTriggered2,
                        ),
                      ),
                    ],
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
