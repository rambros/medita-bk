import 'package:flutter/material.dart';

import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/desafio/constants/desafio_strings.dart';
import 'package:medita_bk/core/utils/logger.dart';

/// Header widget for Desafio 21 dias pages
///
/// Displays a consistent header with:
/// - Back button on the left
/// - Title in the center
/// - Notification icon (placeholder) on the right
class DesafioHeaderWidget extends StatelessWidget {
  const DesafioHeaderWidget({
    super.key,
    this.onBackPressed,
    this.title,
  });

  final VoidCallback? onBackPressed;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.0, 1.0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: onBackPressed ?? () => Navigator.of(context).pop(),
              child: Icon(
                Icons.chevron_left,
                color: FlutterFlowTheme.of(context).info,
                size: 32.0,
              ),
            ),
            Text(
              title ?? DesafioStrings.desafioTitle,
              style: FlutterFlowTheme.of(context).titleLarge.override(
                    fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                    color: FlutterFlowTheme.of(context).info,
                    letterSpacing: 0.0,
                    useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
                  ),
            ),
            FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 20.0,
              borderWidth: 1.0,
              buttonSize: 40.0,
              icon: const Icon(
                Icons.notifications_none,
                color: Color(0x00FFFFFF),
                size: 24.0,
              ),
              onPressed: () {
                logDebug('IconButton pressed ...');
              },
            ),
          ],
        ),
      ),
    );
  }
}
