import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/backend/backend.dart';
import '/ui/core/flutter_flow/flutter_flow_theme.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import '/ui/core/flutter_flow/flutter_flow_animations.dart';

/// Reusable notification card widget
/// Displays a notification in a card format with image, title, content, and metadata
class NotificationCard extends StatelessWidget {
  final NotificationsRecord notification;
  final VoidCallback? onTap;
  final AnimationInfo? animation;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 12.0, 8.0),
      child: Material(
        color: Colors.transparent,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: 270.0,
            height: 150.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image section
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 110.0,
                    height: 110.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32.0),
                      child: Image.network(
                        notification.imagePath,
                        width: 110.0,
                        height: 110.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                // Content section
                Expanded(
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.6,
                    height: 0.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            notification.title,
                            style: FlutterFlowTheme.of(context).titleMedium.override(
                                  font: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 18.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                ),
                          ),

                          // Content
                          Expanded(
                            child: Align(
                              alignment: const AlignmentDirectional(-1.0, -1.0),
                              child: SelectionArea(
                                child: Text(
                                  notification.content.maybeHandleOverflow(
                                    maxChars: 280,
                                    replacement: '…',
                                  ),
                                  maxLines: 3,
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        font: GoogleFonts.outfit(
                                          fontWeight: FontWeight.normal,
                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context).primaryText,
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                      ),
                                ),
                              ),
                            ),
                          ),

                          // Recipients
                          Align(
                            alignment: const AlignmentDirectional(-1.0, -1.0),
                            child: SelectionArea(
                              child: Text(
                                notification.typeRecipients == 'Usuário específico'
                                    ? 'Destinatário: ${notification.recipientEmail}'
                                    : 'Destinatários: Todos os usuários',
                                maxLines: 1,
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: GoogleFonts.outfit(
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context).primaryText,
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                    ),
                              ),
                            ),
                          ),

                          // Date and Type
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Data de envio: ${dateTimeFormat(
                                    "d/M/y",
                                    notification.dataEnvio,
                                    locale: FFLocalizations.of(context).languageCode,
                                  )}',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                      ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  notification.type,
                                  style: FlutterFlowTheme.of(context).titleSmall.override(
                                        fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                      ),
                                ),
                              ),
                            ].divide(const SizedBox(width: 8.0)),
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
      ).animateOnPageLoad(animation ??
          AnimationInfo(
            trigger: AnimationTrigger.onPageLoad,
            effectsBuilder: () => [
              FadeEffect(
                curve: Curves.easeInOut,
                delay: 0.0.ms,
                duration: 600.0.ms,
                begin: 0.0,
                end: 1.0,
              ),
              MoveEffect(
                curve: Curves.easeInOut,
                delay: 0.0.ms,
                duration: 600.0.ms,
                begin: const Offset(30.0, 0.0),
                end: const Offset(0.0, 0.0),
              ),
            ],
          )),
    );
  }
}
