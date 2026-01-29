import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/authentication/social_login/social_login_page.dart';

/// Helper para exibir SnackBars clicáveis que redirecionam para login
class LoginSnackBar {
  /// Mostra um SnackBar que redireciona para a tela de login quando clicado
  ///
  /// [context] - BuildContext para exibir o SnackBar
  /// [message] - Mensagem a ser exibida
  /// [duration] - Duração do SnackBar (padrão: 4 segundos)
  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: GestureDetector(
          onTap: () {
            // Fecha o SnackBar
            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            // Navega para a tela de login
            context.pushNamed(SocialLoginPage.routeName);
          },
          child: Row(
            children: [
              Expanded(
                child: Text(
                  message,
                  style: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                        color: FlutterFlowTheme.of(context).info,
                        letterSpacing: 0.0,
                        useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                      ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_rounded,
                color: FlutterFlowTheme.of(context).info,
                size: 20,
              ),
            ],
          ),
        ),
        backgroundColor: FlutterFlowTheme.of(context).primary,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'ENTRAR',
          textColor: FlutterFlowTheme.of(context).info,
          onPressed: () {
            context.pushNamed(SocialLoginPage.routeName);
          },
        ),
      ),
    );
  }
}
