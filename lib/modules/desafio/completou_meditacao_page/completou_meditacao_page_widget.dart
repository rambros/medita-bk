import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'completou_meditacao_page_model.dart';
export 'completou_meditacao_page_model.dart';

class CompletouMeditacaoPageWidget extends StatefulWidget {
  const CompletouMeditacaoPageWidget({
    super.key,
    required this.parmDiaCompletado,
  });

  final int? parmDiaCompletado;

  static String routeName = 'completouMeditacaoPage';
  static String routePath = 'completouMeditacaoPage';

  @override
  State<CompletouMeditacaoPageWidget> createState() =>
      _CompletouMeditacaoPageWidgetState();
}

class _CompletouMeditacaoPageWidgetState
    extends State<CompletouMeditacaoPageWidget> {
  late CompletouMeditacaoPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CompletouMeditacaoPageModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'completouMeditacaoPage'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.isMeditacaoJaFeita = FFAppState()
              .desafio21
              .d21Meditations
              .elementAtOrNull(widget.parmDiaCompletado!)
              ?.meditationStatus ==
          D21Status.completed;
      if (_model.isMeditacaoJaFeita == true) {
        // get MandalaUrl
        _model.mandalaURL = functions.getURLMandala(
            (((widget.parmDiaCompletado!)) ~/ 3) + 1,
            (widget.parmDiaCompletado!) + 1,
            FFAppState().listaEtapasMandalas.toList());
        safeSetState(() {});
        return;
      }
      // update meditação feita
      FFAppState().updateDesafio21Struct(
        (e) => e
          ..updateD21Meditations(
            (e) => e[widget.parmDiaCompletado!]
              ..dateCompleted = getCurrentTimestamp
              ..meditationStatus = D21Status.completed,
          ),
      );
      safeSetState(() {});
      if (widget.parmDiaCompletado! >= 20) {
        // atualiza dados desafio
        FFAppState().updateDesafio21Struct(
          (e) => e
            ..diasCompletados = 21
            ..diaAtual = 21
            ..etapasCompletadas = 7
            ..etapaAtual = 7
            ..dateCompleted = getCurrentTimestamp,
        );
        // completa Desafio
        FFAppState().updateDesafio21Struct(
          (e) => e
            ..dateCompleted = getCurrentTimestamp
            ..d21Status = D21Status.completed
            ..isD21Completed = true,
        );
        // get MandalaUrl
        _model.mandalaURL = functions.getURLMandala(
            7, 21, FFAppState().listaEtapasMandalas.toList());
        safeSetState(() {});
      } else {
        // open next meditation
        FFAppState().updateDesafio21Struct(
          (e) => e
            ..updateD21Meditations(
              (e) => e[(widget.parmDiaCompletado!) + 1]
                ..meditationStatus = D21Status.open,
            ),
        );
        // atualiza dados dias Desafio
        FFAppState().updateDesafio21Struct(
          (e) => e
            ..incrementDiasCompletados(1)
            ..incrementDiaAtual(1),
        );
        // get MandalaUrl
        _model.mandalaURL = functions.getURLMandala(
            FFAppState().desafio21.etapaAtual,
            FFAppState().desafio21.diasCompletados,
            FFAppState().listaEtapasMandalas.toList());
        safeSetState(() {});
        // pega proxima etapa
        _model.proximaEtapa = FFAppState()
            .desafio21
            .d21Meditations
            .elementAtOrNull((widget.parmDiaCompletado!) + 1)
            ?.etapa;
        // atualiza dados etapa Desafio
        FFAppState().updateDesafio21Struct(
          (e) => e
            ..etapasCompletadas = (_model.proximaEtapa!) - 1
            ..etapaAtual = _model.proximaEtapa,
        );
      }

      // persist user desafio

      await currentUserReference!.update(createUsersRecordData(
        desafio21: updateD21ModelStruct(
          FFAppState().desafio21,
          clearUnsetFields: false,
        ),
      ));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        FlutterFlowTheme.of(context).d21Top,
                        FlutterFlowTheme.of(context).d21Botton
                      ],
                      stops: const [0.0, 1.0],
                      begin: const AlignmentDirectional(0.0, -1.0),
                      end: const AlignmentDirectional(0, 1.0),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0.0, 1.0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    Icons.chevron_left,
                                    color: Colors.transparent,
                                    size: 24.0,
                                  ),
                                  Text(
                                    'Desafio 21 dias',
                                    style: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .titleLargeFamily,
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .titleLargeIsCustom,
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
                                      print('IconButton pressed ...');
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 32.0, 0.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      child: Material(
                                        color: Colors.transparent,
                                        elevation: 4.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xCC83193F),
                                                Color(0xCBB0373E)
                                              ],
                                              stops: [0.0, 1.0],
                                              begin: AlignmentDirectional(
                                                  0.0, -1.0),
                                              end: AlignmentDirectional(0, 1.0),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        4.0, 0.0, 4.0, 0.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          const AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    32.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          'Dia ${((widget.parmDiaCompletado!) + 1).toString()}: ${valueOrDefault<String>(
                                                            FFAppState()
                                                                .desafio21
                                                                .d21Meditations
                                                                .elementAtOrNull(
                                                                    widget
                                                                        .parmDiaCompletado!)
                                                                ?.titulo,
                                                            '1',
                                                          )}',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .labelLarge
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLargeFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .info,
                                                                fontSize: 22.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelLargeIsCustom,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 32.0,
                                                                0.0, 32.0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: Image.network(
                                                        valueOrDefault<String>(
                                                          _model.mandalaURL,
                                                          'https://firebasestorage.googleapis.com/v0/b/meditabk2020.appspot.com/o/desafio%2Fetapa2%2FMandala%202-1.png?alt=media&token=638044ff-ef95-4407-ac8d-ce982370f135',
                                                        ),
                                                        width: MediaQuery.sizeOf(
                                                                        context)
                                                                    .height <
                                                                800.0
                                                            ? 150.0
                                                            : 250.0,
                                                        height: MediaQuery.sizeOf(
                                                                        context)
                                                                    .height <
                                                                800.0
                                                            ? 150.0
                                                            : 250.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 16.0),
                                                child: Text(
                                                  'Meditação concluída!',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleLarge
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleLargeFamily,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .info,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .titleLargeIsCustom,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        8.0, 0.0, 8.0, 16.0),
                                                child: Text(
                                                  'A meditação Raja Yoga nos permite sair de uma situação desconfortável para viver uma experiência de calma e força para lidar com quaisquer imprevistos.',
                                                  textAlign: TextAlign.center,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelLarge
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelLargeFamily,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .info,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLargeIsCustom,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 24.0),
                                                child: Text(
                                                  'Como você está se sentindo agora?',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLargeFamily,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .info,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyLargeIsCustom,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Builder(
                                      builder: (context) {
                                        if (_model.isMeditacaoJaFeita == true) {
                                          return Padding(
                                            padding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 32.0, 0.0, 0.0),
                                            child: FFButtonWidget(
                                              onPressed: () async {
                                                context.goNamed(
                                                  HomeDesafioPageWidget
                                                      .routeName,
                                                  extra: <String, dynamic>{
                                                    kTransitionInfoKey:
                                                        const TransitionInfo(
                                                      hasTransition: true,
                                                      transitionType:
                                                          PageTransitionType
                                                              .fade,
                                                      duration: Duration(
                                                          milliseconds: 0),
                                                    ),
                                                  },
                                                );
                                              },
                                              text: 'Retornar',
                                              options: FFButtonOptions(
                                                height: 40.0,
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        24.0, 0.0, 24.0, 0.0),
                                                iconPadding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                color: const Color(0xFFF9A61A),
                                                textStyle: FlutterFlowTheme.of(
                                                        context)
                                                    .titleSmall
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallFamily,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .info,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallIsCustom,
                                                    ),
                                                elevation: 3.0,
                                                borderSide: const BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Padding(
                                            padding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 32.0, 0.0, 0.0),
                                            child: FFButtonWidget(
                                              onPressed: () async {
                                                if ((widget.parmDiaCompletado == 2) ||
                                                    (widget.parmDiaCompletado ==
                                                        5) ||
                                                    (widget.parmDiaCompletado ==
                                                        8) ||
                                                    (widget.parmDiaCompletado ==
                                                        11) ||
                                                    (widget.parmDiaCompletado ==
                                                        14) ||
                                                    (widget.parmDiaCompletado ==
                                                        17) ||
                                                    (widget.parmDiaCompletado ==
                                                        20)) {
                                                  context.goNamed(
                                                    CompletouMandalaPageWidget
                                                        .routeName,
                                                    queryParameters: {
                                                      'diaCompletado':
                                                          serializeParam(
                                                        widget
                                                            .parmDiaCompletado,
                                                        ParamType.int,
                                                      ),
                                                      'etapaCompletada':
                                                          serializeParam(
                                                        FFAppState()
                                                            .desafio21
                                                            .etapasCompletadas,
                                                        ParamType.int,
                                                      ),
                                                      'parmMandalaUrl':
                                                          serializeParam(
                                                        _model.mandalaURL,
                                                        ParamType.String,
                                                      ),
                                                    }.withoutNulls,
                                                    extra: <String, dynamic>{
                                                      kTransitionInfoKey:
                                                          const TransitionInfo(
                                                        hasTransition: true,
                                                        transitionType:
                                                            PageTransitionType
                                                                .fade,
                                                        duration: Duration(
                                                            milliseconds: 0),
                                                      ),
                                                    },
                                                  );
                                                } else {
                                                  context.goNamed(
                                                    HomeDesafioPageWidget
                                                        .routeName,
                                                    extra: <String, dynamic>{
                                                      kTransitionInfoKey:
                                                          const TransitionInfo(
                                                        hasTransition: true,
                                                        transitionType:
                                                            PageTransitionType
                                                                .fade,
                                                        duration: Duration(
                                                            milliseconds: 0),
                                                      ),
                                                    },
                                                  );
                                                }
                                              },
                                              text: 'Continuar',
                                              options: FFButtonOptions(
                                                height: 40.0,
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        24.0, 0.0, 24.0, 0.0),
                                                iconPadding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                color: const Color(0xFFF9A61A),
                                                textStyle: FlutterFlowTheme.of(
                                                        context)
                                                    .titleSmall
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallFamily,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .info,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallIsCustom,
                                                    ),
                                                elevation: 3.0,
                                                borderSide: const BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
