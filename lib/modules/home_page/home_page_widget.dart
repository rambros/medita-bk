import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/componentes/select_brasao_or_mandala_test/select_brasao_or_mandala_test_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/index.dart';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'homePage';
  static String routePath = 'homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> with TickerProviderStateMixin {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'homePage'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await action_blocks.checkInternetAccess(context);
      _model.userRecord = await UsersRecord.getDocumentOnce(currentUserReference!);

      await currentUserReference!.update(createUsersRecordData(
        lastAccess: getCurrentTimestamp,
      ));
      // Necessario pq alguns usuarios não tem campo desafioStarted -> cria este campo
      // get value desafioStarted do user
      FFAppState().desafioStarted = _model.userRecord!.desafio21Started;
      if (FFAppState().desafioStarted != true) {
        // cria campo no user as false

        await currentUserReference!.update(createUsersRecordData(
          desafio21Started: false,
        ));
      }
      // carrega template
      _model.desafioRecord = await queryDesafio21RecordOnce(
        queryBuilder: (desafio21Record) => desafio21Record.where(
          'docId',
          isEqualTo: 1,
        ),
        singleRecord: true,
      ).then((s) => s.firstOrNull);
      // salva mandalas app state
      FFAppState().listaEtapasMandalas = _model.desafioRecord!.listaEtapasMandalas.toList().cast<D21EtapaModelStruct>();
      safeSetState(() {});
      if (valueOrDefault<bool>(currentUserDocument?.desafio21Started, false) == true) {
        // carrega dados do usuario
        FFAppState().desafio21 = currentUserDocument!.desafio21;
        safeSetState(() {});
      } else {
        // cria desafio21 no user

        await currentUserReference!.update(createUsersRecordData(
          desafio21: updateD21ModelStruct(
            _model.desafioRecord?.desafio21Data,
            clearUnsetFields: false,
          ),
        ));
        // sempre vai precisar carregar a lista de mandalas. aproveita e carrega aqui
        // salva no app state
        FFAppState().desafio21 = _model.desafioRecord!.desafio21Data;
        safeSetState(() {});
      }

      _model.settings = await querySettingsRecordOnce(
        singleRecord: true,
      ).then((s) => s.firstOrNull);
      FFAppState().habilitaDesafio21 = _model.settings!.habilitaDesafio21;
      FFAppState().diaInicioDesafio21 = _model.settings?.diaInicioDesafio21;
      safeSetState(() {});
    });

    animationsMap.addAll({
      'containerOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 800.0.ms,
            begin: const Offset(18.0, 18.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 800.0.ms,
            begin: const Offset(18.0, 18.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 800.0.ms,
            begin: const Offset(18.0, 18.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation4': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 800.0.ms,
            begin: const Offset(18.0, 18.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation5': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 800.0.ms,
            begin: const Offset(18.0, 18.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
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
        appBar: responsiveVisibility(
          context: context,
          tabletLandscape: false,
          desktop: false,
        )
            ? AppBar(
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
                                ConfigPageWidget.routeName,
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
                          FlutterFlowIconButton(
                            borderRadius: 20.0,
                            borderWidth: 1.0,
                            buttonSize: 40.0,
                            fillColor: FlutterFlowTheme.of(context).primaryBackground,
                            icon: Icon(
                              Icons.notifications_none,
                              color: FlutterFlowTheme.of(context).primary,
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
                centerTitle: true,
                elevation: 0.0,
              )
            : null,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Builder(
                        builder: (context) => Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 32.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              if ((currentUserDocument?.userRole.toList() ?? []).contains('Tester') == true) {
                                await showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return Dialog(
                                      elevation: 0,
                                      insetPadding: EdgeInsets.zero,
                                      backgroundColor: Colors.transparent,
                                      alignment: const AlignmentDirectional(0.0, 1.0).resolve(Directionality.of(context)),
                                      child: WebViewAware(
                                        child: GestureDetector(
                                          onTap: () {
                                            FocusScope.of(dialogContext).unfocus();
                                            FocusManager.instance.primaryFocus?.unfocus();
                                          },
                                          child: SizedBox(
                                            height: 300.0,
                                            child: const SelectBrasaoOrMandalaTestWidget(),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'O que você quer fazer agora?',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context).titleLarge.override(
                                        fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                                        color: FlutterFlowTheme.of(context).primary,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (FFAppState().habilitaDesafio21 == true)
                        Flexible(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                await action_blocks.checkInternetAccess(context);

                                context.pushNamed(
                                  HomeDesafioPageWidget.routeName,
                                  extra: <String, dynamic>{
                                    kTransitionInfoKey: const TransitionInfo(
                                      hasTransition: true,
                                      transitionType: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 0),
                                    ),
                                  },
                                );
                              },
                              child: Material(
                                color: Colors.transparent,
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xCD83193F), Color(0xFFB0373E)],
                                      stops: [0.0, 1.0],
                                      begin: AlignmentDirectional(0.0, -1.0),
                                      end: AlignmentDirectional(0, 1.0),
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 42.0,
                                          height: 42.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context).info,
                                            borderRadius: BorderRadius.circular(50.0),
                                          ),
                                          child: Icon(
                                            Icons.filter_vintage,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                            size: 24.0,
                                          ),
                                        ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation1']!),
                                        Text(
                                          'Desafio 21 dias',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                                color: FlutterFlowTheme.of(context).primaryText,
                                                fontSize: 24.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      Flexible(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 0.0),
                          child: GridView(
                            padding: EdgeInsets.zero,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16.0,
                              childAspectRatio: 1.0,
                            ),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: const Color(0xFFECCB9E),
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context.pushNamed(
                                      MeditationListPageWidget.routeName,
                                      extra: <String, dynamic>{
                                        kTransitionInfoKey: const TransitionInfo(
                                          hasTransition: true,
                                          transitionType: PageTransitionType.leftToRight,
                                        ),
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: 100.0,
                                    height: 90.0,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xFFEC407A), Color(0xFFF48FB1)],
                                        stops: [0.0, 1.0],
                                        begin: AlignmentDirectional(-1.0, -1.0),
                                        end: AlignmentDirectional(1.0, 1.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 42.0,
                                            height: 42.0,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).info,
                                              borderRadius: BorderRadius.circular(50.0),
                                            ),
                                            child: Icon(
                                              Icons.filter_vintage,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              size: 24.0,
                                            ),
                                          ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation2']!),
                                          Text(
                                            'Fazer uma meditação',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                  fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: const Color(0xFFECCB9E),
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context.pushNamed(
                                      AgendaListPage.routeName,
                                      extra: <String, dynamic>{
                                        kTransitionInfoKey: const TransitionInfo(
                                          hasTransition: true,
                                          transitionType: PageTransitionType.leftToRight,
                                        ),
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: 100.0,
                                    height: 90.0,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.red, Color(0xFFEF9A9A)],
                                        stops: [0.0, 1.0],
                                        begin: AlignmentDirectional(1.0, -1.0),
                                        end: AlignmentDirectional(-1.0, 1.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 42.0,
                                            height: 42.0,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).info,
                                              borderRadius: BorderRadius.circular(50.0),
                                            ),
                                            child: Icon(
                                              Icons.calendar_today,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              size: 24.0,
                                            ),
                                          ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation3']!),
                                          Text(
                                            'Ver agenda de atividades',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                  fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: const Color(0xFFECCB9E),
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context.pushNamed(
                                      MensagemDetailsPageWidget.routeName,
                                      extra: <String, dynamic>{
                                        kTransitionInfoKey: const TransitionInfo(
                                          hasTransition: true,
                                          transitionType: PageTransitionType.leftToRight,
                                        ),
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: 100.0,
                                    height: 90.0,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xFFFFA726), Color(0xFFFFCC80)],
                                        stops: [0.0, 1.0],
                                        begin: AlignmentDirectional(-1.0, 1.0),
                                        end: AlignmentDirectional(1.0, -1.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 42.0,
                                            height: 42.0,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).info,
                                              borderRadius: BorderRadius.circular(50.0),
                                            ),
                                            child: Icon(
                                              FFIcons.kselfImprovementBlack24dp,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              size: 32.0,
                                            ),
                                          ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation4']!),
                                          Text(
                                            'Ler mensagem para o dia',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                  fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: const Color(0xFFECCB9E),
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context.pushNamed(
                                      SupportPageWidget.routeName,
                                      extra: <String, dynamic>{
                                        kTransitionInfoKey: const TransitionInfo(
                                          hasTransition: true,
                                          transitionType: PageTransitionType.fade,
                                          duration: Duration(milliseconds: 0),
                                        ),
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: 100.0,
                                    height: 90.0,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xFFF9A825), Color(0xFFFFEE58)],
                                        stops: [0.0, 1.0],
                                        begin: AlignmentDirectional(1.0, 1.0),
                                        end: AlignmentDirectional(-1.0, -1.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 42.0,
                                            height: 42.0,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).info,
                                              borderRadius: BorderRadius.circular(50.0),
                                            ),
                                            child: Icon(
                                              Icons.thumb_up_alt,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              size: 24.0,
                                            ),
                                          ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation5']!),
                                          Text(
                                            'Ajude-nos a melhorar o app',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                  fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
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
                    ],
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
