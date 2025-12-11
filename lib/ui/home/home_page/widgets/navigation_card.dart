import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_animations.dart';
import 'package:medita_bk/ui/core/flutter_flow/custom_icons.dart';

/// Reusable navigation card widget for home page grid
class NavigationCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Color> gradientColors;
  final List<double> gradientStops;
  final AlignmentDirectional gradientBegin;
  final AlignmentDirectional gradientEnd;
  final VoidCallback onTap;
  final AnimationInfo? animation;

  const NavigationCard({
    super.key,
    required this.title,
    required this.icon,
    required this.gradientColors,
    required this.gradientStops,
    required this.gradientBegin,
    required this.gradientEnd,
    required this.onTap,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: const Color(0xFFECCB9E),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          width: 100.0,
          height: 90.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              stops: gradientStops,
              begin: gradientBegin,
              end: gradientEnd,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42.0,
                  height: 42.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).info,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Icon(
                    icon,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: icon == FFIcons.kselfImprovementBlack24dp ? 32.0 : 24.0,
                  ),
                ).animateOnPageLoad(animation ??
                    AnimationInfo(
                      trigger: AnimationTrigger.onPageLoad,
                      effectsBuilder: () => [
                        MoveEffect(
                          curve: Curves.easeInOut,
                          delay: 0.0.ms,
                          duration: 800.0.ms,
                          begin: const Offset(18.0, 18.0),
                          end: const Offset(0.0, 0.0),
                        ),
                      ],
                    )),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                        color: FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
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
