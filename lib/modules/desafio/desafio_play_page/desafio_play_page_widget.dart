import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/ui/desafio/widgets/f_f_desafio_audio_player_widget.dart';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'desafio_play_page_model.dart';
export 'desafio_play_page_model.dart';

class DesafioPlayPageWidget extends StatefulWidget {
  const DesafioPlayPageWidget({
    super.key,
    required this.indiceListaMeditacao,
  });

  final int? indiceListaMeditacao;

  static String routeName = 'desafioPlayPage';
  static String routePath = 'desafioPlayPage';

  @override
  State<DesafioPlayPageWidget> createState() => _DesafioPlayPageWidgetState();
}

class _DesafioPlayPageWidgetState extends State<DesafioPlayPageWidget> {
  late DesafioPlayPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DesafioPlayPageModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'desafioPlayPage'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // pega template do desafio
      _model.desafio21Record = await queryDesafio21RecordOnce(
        singleRecord: true,
      ).then((s) => s.firstOrNull);
      // update lista mandalas
      FFAppState().listaEtapasMandalas = _model
          .desafio21Record!.listaEtapasMandalas
          .toList()
          .cast<D21EtapaModelStruct>();
      if (currentUserDocument?.desafio21 == null) {
        // update app dados desafio
        FFAppState().desafio21 = _model.desafio21Record!.desafio21Data;
        // not started
        _model.iniciadoDesafio = false;
        safeSetState(() {});
      } else {
        // update user dados desafio
        FFAppState().desafio21 = currentUserDocument!.desafio21;
        // started
        _model.iniciadoDesafio = true;
        safeSetState(() {});
      }
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
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xCD83193F), Color(0xCDCD454A)],
                    stops: [0.0, 1.0],
                    begin: AlignmentDirectional(0.0, -1.0),
                    end: AlignmentDirectional(0, 1.0),
                  ),
                ),
              ),
              Opacity(
                opacity: 0.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/images/Shiva-12-new.jpg',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Align(
                        alignment: const AlignmentDirectional(0.0, 1.0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              4.0, 0.0, 4.0, 32.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  if (Navigator.of(context).canPop()) {
                                    context.pop();
                                  }
                                  context.pushNamed(
                                    ListaEtapasPageWidget.routeName,
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
                                  Icons.chevron_left,
                                  color: FlutterFlowTheme.of(context).info,
                                  size: 32.0,
                                ),
                              ),
                              Text(
                                'Desafio 21 dias',
                                style: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .titleLargeFamily,
                                      color: FlutterFlowTheme.of(context).info,
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
                    ),
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            child: Text(
                              FFAppState()
                                  .desafio21
                                  .d21Meditations
                                  .elementAtOrNull(
                                      widget.indiceListaMeditacao!)!
                                  .titulo,
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .titleLargeFamily,
                                    color: FlutterFlowTheme.of(context).info,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .titleLargeIsCustom,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 3),
                    Flexible(
                      flex: 4,
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 0.0),
                        child: Container(
                          width: 600.0,
                          height: 600.0,
                          decoration: const BoxDecoration(),
                          child: SizedBox(
                            width: 620.0,
                            height: 620.0,
                            child: FFDesafioAudioPlayerWidget(
                              width: 620.0,
                              height: 620.0,
                              audioTitle: FFAppState()
                                  .desafio21
                                  .d21Meditations
                                  .elementAtOrNull(
                                      widget.indiceListaMeditacao!)!
                                  .titulo,
                              audioUrl: FFAppState()
                                  .desafio21
                                  .d21Meditations
                                  .elementAtOrNull(
                                      widget.indiceListaMeditacao!)!
                                  .audioUrl,
                              audioArt: FFAppState()
                                  .desafio21
                                  .d21Meditations
                                  .elementAtOrNull(
                                      widget.indiceListaMeditacao!)!
                                  .imageUrl,
                              nextActionFunction: () async {
                                context.pushNamed(
                                  CompletouMeditacaoPageWidget.routeName,
                                  queryParameters: {
                                    'parmDiaCompletado': serializeParam(
                                      widget.indiceListaMeditacao,
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
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
