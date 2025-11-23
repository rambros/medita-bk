import '/auth/firebase_auth/auth_util.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:aligned_tooltip/aligned_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'status_meditacao_model.dart';
export 'status_meditacao_model.dart';

class StatusMeditacaoWidget extends StatefulWidget {
  const StatusMeditacaoWidget({
    super.key,
    required this.statusMeditacao,
    required this.dia,
  });

  final D21Status? statusMeditacao;
  final int? dia;

  @override
  State<StatusMeditacaoWidget> createState() => _StatusMeditacaoWidgetState();
}

class _StatusMeditacaoWidgetState extends State<StatusMeditacaoWidget> {
  late StatusMeditacaoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StatusMeditacaoModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return
        // para aqueles que estao com status open, se for dia seguinte da anterior, habilita open full, se não coloca um open com outra cor...
        Builder(
      builder: (context) {
        if (widget.statusMeditacao == D21Status.open) {
          return Builder(
            builder: (context) {
              if ((currentUserDocument?.userRole.toList() ?? [])
                      .contains('Tester') ==
                  true) {
                return InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed(
                      DesafioPlayPageWidget.routeName,
                      queryParameters: {
                        'indiceListaMeditacao': serializeParam(
                          (widget.dia!) - 1,
                          ParamType.int,
                        ),
                      }.withoutNulls,
                      extra: <String, dynamic>{
                        kTransitionInfoKey: const TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.fade,
                          duration: Duration(milliseconds: 0),
                        ),
                      },
                    );
                  },
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: FlutterFlowTheme.of(context).info,
                    size: 38.0,
                  ),
                );
              } else if (getCurrentTimestamp <
                  FFAppState().diaInicioDesafio21!) {
                return AlignedTooltip(
                  content: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Aguarde até ${dateTimeFormat(
                        "d/M/y",
                        FFAppState().diaInicioDesafio21,
                        locale: FFLocalizations.of(context).languageCode,
                      )} para iniciar o desafio.',
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyLargeFamily,
                            letterSpacing: 0.0,
                            useGoogleFonts:
                                !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                          ),
                    ),
                  ),
                  offset: 4.0,
                  preferredDirection: AxisDirection.down,
                  borderRadius: BorderRadius.circular(8.0),
                  backgroundColor:
                      FlutterFlowTheme.of(context).secondaryBackground,
                  elevation: 4.0,
                  tailBaseWidth: 24.0,
                  tailLength: 12.0,
                  waitDuration: const Duration(milliseconds: 100),
                  showDuration: const Duration(milliseconds: 1500),
                  triggerMode: TooltipTriggerMode.tap,
                  child: FaIcon(
                    FontAwesomeIcons.lock,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 32.0,
                  ),
                );
              } else if (widget.dia == 1) {
                return InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed(
                      DesafioPlayPageWidget.routeName,
                      queryParameters: {
                        'indiceListaMeditacao': serializeParam(
                          (widget.dia!) - 1,
                          ParamType.int,
                        ),
                      }.withoutNulls,
                      extra: <String, dynamic>{
                        kTransitionInfoKey: const TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.fade,
                          duration: Duration(milliseconds: 0),
                        ),
                      },
                    );
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: FlutterFlowTheme.of(context).info,
                    size: 32.0,
                  ),
                );
              } else if (functions.checkNextDayMeditation(FFAppState()
                  .desafio21
                  .d21Meditations
                  .elementAtOrNull((widget.dia!) - 2)
                  ?.dateCompleted)) {
                return InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed(
                      DesafioPlayPageWidget.routeName,
                      queryParameters: {
                        'indiceListaMeditacao': serializeParam(
                          (widget.dia!) - 1,
                          ParamType.int,
                        ),
                      }.withoutNulls,
                      extra: <String, dynamic>{
                        kTransitionInfoKey: const TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.fade,
                          duration: Duration(milliseconds: 0),
                        ),
                      },
                    );
                  },
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: FlutterFlowTheme.of(context).info,
                    size: 38.0,
                  ),
                );
              } else {
                return AlignedTooltip(
                  content: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Precisa aguardar o próximo dia para fazer esta meditação',
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyLargeFamily,
                            letterSpacing: 0.0,
                            useGoogleFonts:
                                !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                          ),
                    ),
                  ),
                  offset: 4.0,
                  preferredDirection: AxisDirection.down,
                  borderRadius: BorderRadius.circular(8.0),
                  backgroundColor:
                      FlutterFlowTheme.of(context).secondaryBackground,
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
                    onTap: () async {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Precisa aguardar o próximo dia para fazer esta meditação',
                            style: TextStyle(
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                          duration: const Duration(milliseconds: 4000),
                          backgroundColor:
                              FlutterFlowTheme.of(context).secondary,
                        ),
                      );

                      safeSetState(() {});
                    },
                    child: FaIcon(
                      FontAwesomeIcons.lock,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 32.0,
                    ),
                  ),
                );
              }
            },
          );
        } else if (widget.statusMeditacao == D21Status.closed) {
          return Icon(
            Icons.lock_outline_rounded,
            color: FlutterFlowTheme.of(context).white70,
            size: 32.0,
          );
        } else {
          return InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              context.pushNamed(
                DesafioPlayPageWidget.routeName,
                queryParameters: {
                  'indiceListaMeditacao': serializeParam(
                    (widget.dia!) - 1,
                    ParamType.int,
                  ),
                }.withoutNulls,
                extra: <String, dynamic>{
                  kTransitionInfoKey: const TransitionInfo(
                    hasTransition: true,
                    transitionType: PageTransitionType.fade,
                    duration: Duration(milliseconds: 0),
                  ),
                },
              );
            },
            child: Icon(
              Icons.check_rounded,
              color: FlutterFlowTheme.of(context).secondary,
              size: 32.0,
            ),
          );
        }
      },
    );
  }
}
