import 'package:flutter/material.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_widgets.dart';

/// Header section for profile page showing "Your Courses" title and Add Course button
class ProfileHeader extends StatelessWidget {
  final VoidCallback onAddCourse;

  const ProfileHeader({
    super.key,
    required this.onAddCourse,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 1.0, 0.0, 0.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 0.0,
              color: FlutterFlowTheme.of(context).lineColor,
              offset: const Offset(0.0, 1.0),
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
                onPressed: onAddCourse,
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
    );
  }
}
