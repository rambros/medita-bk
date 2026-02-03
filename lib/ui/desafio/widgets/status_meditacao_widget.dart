import 'package:aligned_tooltip/aligned_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:medita_bk/core/enums/enums.dart';
import 'package:medita_bk/data/repositories/auth_repository.dart';
import 'package:medita_bk/ui/pages.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/ui/core/flutter_flow/custom_functions.dart' as functions;
import 'package:medita_bk/ui/desafio/constants/desafio_strings.dart';

class StatusMeditacaoWidget extends StatelessWidget {
  const StatusMeditacaoWidget({
    super.key,
    required this.statusMeditacao,
    required this.dia,
  });

  final D21Status? statusMeditacao;
  final int? dia;

  @override
  Widget build(BuildContext context) {
    // Listen to app state for challenge data changes.
    context.watch<AppStateStore>();
    final isTester = (context.read<AuthRepository>().currentUser?.userRole.toList() ?? [])
        .any((role) => role.toLowerCase() == 'tester');

    // Testers can always access the meditation (unless it's already completed, then show the check).
    if (isTester) {
      if (statusMeditacao == D21Status.completed) {
        return _buildCompletedStatus(context);
      }
      return _buildPlay(context, dia ?? 0);
    }

    // Check start date globally - blocks everything if future
    final startDate = AppStateStore().diaInicioDesafio21;
    if (startDate != null && getCurrentTimestamp < startDate) {
      final formattedDate = dateTimeFormat("d/M/y", startDate, locale: FFLocalizations.of(context).languageCode);
      return _buildTooltip(
        context,
        message: DesafioStrings.waitUntilDate(formattedDate),
      );
    }

    if (statusMeditacao == D21Status.open) {
      return _buildOpenStatus(context);
    }

    if (statusMeditacao == D21Status.closed) {
      String message = DesafioStrings.completePreviousDay;
      bool isPermanentLock = true;

      final currentDay = dia ?? 0;
      if (currentDay > 1) {
        final previousMeditation = AppStateStore().desafio21.d21Meditations.elementAtOrNull(currentDay - 2);

        // Se a anterior foi completada (por data ou status), a trava aqui é de tempo (dia seguinte)
        if (previousMeditation != null &&
            (previousMeditation.dateCompleted != null || previousMeditation.meditationStatus == D21Status.completed)) {
          message = DesafioStrings.waitNextDay;
          isPermanentLock = false; // Bloqueio temporal
        }
      }

      return _buildLockedWarning(
        context,
        message: message,
        isPermanent: isPermanentLock,
      );
    }

    return _buildCompletedStatus(context);
  }

  Widget _buildOpenStatus(BuildContext context) {
    final day = dia ?? 0;
    final startDate = AppStateStore().diaInicioDesafio21;

    if (startDate == null) {
      return Icon(
        Icons.error_outline,
        color: FlutterFlowTheme.of(context).error,
        size: 32.0,
      );
    }

    if (getCurrentTimestamp < startDate) {
      return _buildTooltip(
        context,
        message:
            'Aguarde até ${dateTimeFormat("d/M/y", startDate, locale: FFLocalizations.of(context).languageCode)} para iniciar o desafio.',
      );
    }

    if (day == 1) {
      return _buildPlay(context, day);
    }

    final previousMeditation = AppStateStore().desafio21.d21Meditations.elementAtOrNull(day - 2)?.dateCompleted;

    if (functions.checkNextDayMeditation(previousMeditation)) {
      return _buildPlay(context, day);
    }

    return _buildLockedWarning(context);
  }

  Widget _buildCompletedStatus(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => _navigateToMeditation(context),
      child: Icon(
        Icons.check_circle,
        color: Colors.white,
        size: 36.0,
      ),
    );
  }

  Widget _buildPlay(BuildContext context, int day) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => _navigateToMeditation(context),
      child: Icon(
        Icons.play_circle_outline,
        color: FlutterFlowTheme.of(context).info,
        size: 38.0,
      ),
    );
  }

  Widget _buildLockedWarning(BuildContext context, {String? message, bool isPermanent = false}) {
    final msg = message ?? 'Precisa aguardar o próximo dia para fazer esta meditação';
    return AlignedTooltip(
      content: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          msg,
          style: FlutterFlowTheme.of(context).bodyLarge.override(
                fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                letterSpacing: 0.0,
                useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
              ),
        ),
      ),
      offset: 4.0,
      preferredDirection: AxisDirection.down,
      borderRadius: BorderRadius.circular(8.0),
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      elevation: 4.0,
      tailBaseWidth: 24.0,
      tailLength: 12.0,
      waitDuration: const Duration(milliseconds: 100),
      showDuration: const Duration(milliseconds: 1500),
      triggerMode: TooltipTriggerMode.tap,
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                msg,
                style: TextStyle(
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
              duration: const Duration(milliseconds: 4000),
              backgroundColor: FlutterFlowTheme.of(context).secondary,
            ),
          );
        },
        child: Icon(
          isPermanent ? Icons.lock : Icons.lock_clock,
          color: isPermanent ? FlutterFlowTheme.of(context).secondaryText : FlutterFlowTheme.of(context).white70,
          size: 32.0,
        ),
      ),
    );
  }

  Widget _buildTooltip(BuildContext context, {required String message}) {
    return AlignedTooltip(
      content: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          message,
          style: FlutterFlowTheme.of(context).bodyLarge.override(
                fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                letterSpacing: 0.0,
                useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
              ),
        ),
      ),
      offset: 4.0,
      preferredDirection: AxisDirection.down,
      borderRadius: BorderRadius.circular(8.0),
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      elevation: 4.0,
      tailBaseWidth: 24.0,
      tailLength: 12.0,
      waitDuration: const Duration(milliseconds: 100),
      showDuration: const Duration(milliseconds: 1500),
      triggerMode: TooltipTriggerMode.tap,
      child: Icon(
        Icons.schedule,
        color: FlutterFlowTheme.of(context).warning,
        size: 32.0,
      ),
    );
  }

  void _navigateToMeditation(BuildContext context) {
    final day = dia ?? 0;

    context.pushNamed(
      DesafioPlayPage.routeName,
      queryParameters: {
        'indiceListaMeditacao': serializeParam(
          (day) - 1,
          ParamType.int,
        ),
      }.withoutNulls,
      extra: <String, dynamic>{
        kTransitionInfoKey: const TransitionInfo(
          hasTransition: true,
          transitionType: PageTransitionType.leftToRight,
        ),
      },
    );
  }
}
