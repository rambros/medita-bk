import 'package:flutter/material.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';

/// Reusable menu item widget for profile page
/// Used for navigation items like Country, Edit Profile, Support, etc.
class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 60.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: const [
              BoxShadow(
                blurRadius: 5.0,
                color: Color(0x3416202A),
                offset: Offset(0.0, 2.0),
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
                  icon,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                  child: Text(
                    title,
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
    );
  }
}
