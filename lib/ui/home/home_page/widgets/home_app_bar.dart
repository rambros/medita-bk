import 'package:flutter/material.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/ui/core/widgets/notification_badge_icon.dart';
import 'package:medita_bk/ui/pages.dart';
import 'package:medita_bk/core/utils/logger.dart';

/// Custom app bar for home page
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      automaticallyImplyLeading: false,
      actions: const [],
      flexibleSpace: FlexibleSpaceBar(
        background: Align(
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
                  onTap: () async {
                    context.pushNamed(
                      ConfigPage.routeName,
                      extra: <String, dynamic>{
                        kTransitionInfoKey: const TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.leftToRight,
                        ),
                      },
                    );
                  },
                  child: Icon(
                    Icons.menu,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 24.0,
                  ),
                ),
                Text(
                  'Início',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: FlutterFlowTheme.of(context).headlineMediumFamily,
                        color: FlutterFlowTheme.of(context).primary,
                        letterSpacing: 0.0,
                        useGoogleFonts: !FlutterFlowTheme.of(context).headlineMediumIsCustom,
                      ),
                ),
                NotificationBadgeIcon(
                  iconSize: 24.0,
                  iconColor: FlutterFlowTheme.of(context).primary,
                  badgeColor: FlutterFlowTheme.of(context).error,
                  onPressed: () {
                    logDebug('Notification icon pressed - navigating to notifications page');
                    context.pushNamed('notificacoes');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      centerTitle: true,
      elevation: 0.0,
    );
  }
}
