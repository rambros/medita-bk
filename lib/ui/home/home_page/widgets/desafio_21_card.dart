import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:medita_b_k/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_b_k/ui/core/flutter_flow/flutter_flow_animations.dart';

/// Large featured card for Desafio 21 dias
class Desafio21Card extends StatelessWidget {
  final VoidCallback onTap;
  final AnimationInfo? animation;

  const Desafio21Card({
    super.key,
    required this.onTap,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Material(
          color: Colors.transparent,
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xCD83193F), Color(0xFFB0373E)],
                stops: [0.0, 1.0],
                begin: AlignmentDirectional(0.0, -1.0),
                end: AlignmentDirectional(0, 1.0),
              ),
              borderRadius: BorderRadius.circular(8.0),
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
                      Icons.filter_vintage,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 24.0,
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
                    'Desafio 21 dias',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 24.0,
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
      ),
    );
  }
}
