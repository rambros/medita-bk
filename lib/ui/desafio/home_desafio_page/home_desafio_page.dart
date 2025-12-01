import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

import '/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import '/ui/core/flutter_flow/flutter_flow_theme.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import '/ui/core/flutter_flow/flutter_flow_widgets.dart';
import '/ui/desafio/widgets/confirma_reset_desafio_widget.dart';
import '/ui/core/flutter_flow/custom_functions.dart' as functions;
import '/ui/pages.dart';
import '/core/utils/logger.dart';

import 'view_model/home_desafio_view_model.dart';

class HomeDesafioPage extends StatefulWidget {
  const HomeDesafioPage({super.key});

  static String routeName = 'homeDesafioPage';
  static String routePath = 'homeDesafioPage';

  @override
  State<HomeDesafioPage> createState() => _HomeDesafioPageState();
}

class _HomeDesafioPageState extends State<HomeDesafioPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    logFirebaseEvent('screen_view', parameters: {'screen_name': 'homeDesafioPage'});
  }

  @override
  Widget build(BuildContext context) {
    // Watch AppStateStore to ensure UI updates when global state changes (legacy support)
    context.watch<AppStateStore>();
    final viewModel = context.watch<HomeDesafioViewModel>();

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
                      colors: [FlutterFlowTheme.of(context).d21Top, FlutterFlowTheme.of(context).d21Botton],
                      stops: const [0.0, 1.0],
                      begin: const AlignmentDirectional(0.0, -1.0),
                      end: const AlignmentDirectional(0, 1.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
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
                                      if (Navigator.of(context).canPop()) {
                                        context.pop();
                                      }
                                      context.pushNamed(
                                        HomePage.routeName,
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
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Builder(
                                  builder: (context) {
                                    if (viewModel.isD21Completed) {
                                      return _buildCompletedView(context);
                                    } else {
                                      return _buildActiveView(context, viewModel);
                                    }
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                ConquistasPage.routeName,
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
                                                height: 160.0,
                                                decoration: BoxDecoration(
                                                  gradient: const LinearGradient(
                                                    colors: [Color(0xCC83193F), Color(0xCBB0373E)],
                                                    stops: [0.0, 1.0],
                                                    begin: AlignmentDirectional(0.0, -1.0),
                                                    end: AlignmentDirectional(0, 1.0),
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                                                      child: AutoSizeText(
                                                        'Conquistas',
                                                        textAlign: TextAlign.center,
                                                        maxLines: 1,
                                                        minFontSize: 18.0,
                                                        style: FlutterFlowTheme.of(context).labelLarge.override(
                                                              fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                                              color: FlutterFlowTheme.of(context).info,
                                                              fontSize: 22.0,
                                                              letterSpacing: 0.0,
                                                              useGoogleFonts:
                                                                  !FlutterFlowTheme.of(context).labelLargeIsCustom,
                                                            ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional.fromSTEB(12.0, 2.0, 12.0, 0.0),
                                                      child: AutoSizeText(
                                                        '& Metas',
                                                        textAlign: TextAlign.center,
                                                        maxLines: 1,
                                                        minFontSize: 18.0,
                                                        style: FlutterFlowTheme.of(context).labelLarge.override(
                                                              fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                                              color: FlutterFlowTheme.of(context).info,
                                                              fontSize: 22.0,
                                                              letterSpacing: 0.0,
                                                              useGoogleFonts:
                                                                  !FlutterFlowTheme.of(context).labelLargeIsCustom,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                DiarioMeditacaoPage.routeName,
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
                                                height: 160.0,
                                                decoration: BoxDecoration(
                                                  gradient: const LinearGradient(
                                                    colors: [Color(0xCC83193F), Color(0xCBB0373E)],
                                                    stops: [0.0, 1.0],
                                                    begin: AlignmentDirectional(0.0, -1.0),
                                                    end: AlignmentDirectional(0, 1.0),
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(12.0),
                                                  child: AutoSizeText(
                                                    'Diário de meditação',
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    minFontSize: 18.0,
                                                    style: FlutterFlowTheme.of(context).labelLarge.override(
                                                          fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                                          color: FlutterFlowTheme.of(context).info,
                                                          fontSize: 22.0,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme.of(context).labelLargeIsCustom,
                                                        ),
                                                  ),
                                                ),
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

  Widget _buildCompletedView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
          child: Material(
            color: Colors.transparent,
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Container(
              width: double.infinity,
              height: 440.0,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xCC83193F), Color(0xCBB0373E)],
                  stops: [0.0, 1.0],
                  begin: AlignmentDirectional(0.0, -1.0),
                  end: AlignmentDirectional(0, 1.0),
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                      child: Text(
                        'Você já concluiu o desafio',
                        style: FlutterFlowTheme.of(context).labelLarge.override(
                              fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                              color: FlutterFlowTheme.of(context).info,
                              fontSize: 22.0,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                            ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 32.0),
                              child: Text(
                                'O que você deseja fazer?',
                                style: FlutterFlowTheme.of(context).labelLarge.override(
                                      fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                      color: FlutterFlowTheme.of(context).info,
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 32.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              context.pushNamed(
                                ListaEtapasPage.routeName,
                                extra: <String, dynamic>{
                                  kTransitionInfoKey: const TransitionInfo(
                                    hasTransition: true,
                                    transitionType: PageTransitionType.fade,
                                    duration: Duration(milliseconds: 0),
                                  ),
                                },
                              );
                            },
                            text: 'Refazer uma meditação',
                            options: FFButtonOptions(
                              height: 40.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).d21Orange,
                              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                  ),
                              elevation: 3.0,
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 32.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                enableDrag: false,
                                context: context,
                                builder: (context) {
                                  return WebViewAware(
                                    child: GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        FocusManager.instance.primaryFocus?.unfocus();
                                      },
                                      child: Padding(
                                        padding: MediaQuery.viewInsetsOf(context),
                                        child: const ConfirmaResetDesafioWidget(),
                                      ),
                                    ),
                                  );
                                },
                              ).then((value) => safeSetState(() {}));
                            },
                            text: 'Reiniciar o desafio',
                            options: FFButtonOptions(
                              height: 40.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).d21Orange,
                              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                  ),
                              elevation: 3.0,
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveView(BuildContext context, HomeDesafioViewModel viewModel) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
          child: Material(
            color: Colors.transparent,
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Container(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height < 800.0 ? 358.0 : 440.0,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xCC83193F), Color(0xCBB0373E)],
                  stops: [0.0, 1.0],
                  begin: AlignmentDirectional(0.0, -1.0),
                  end: AlignmentDirectional(0, 1.0),
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                    child: Text(
                      'Etapa ${valueOrDefault<String>(
                        viewModel.etapaAtual.toString(),
                        '1',
                      )}',
                      style: FlutterFlowTheme.of(context).labelLarge.override(
                            fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                            color: FlutterFlowTheme.of(context).info,
                            fontSize: 22.0,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                          ),
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      if (!viewModel.isDesafioStarted) {
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 24.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  functions.getURLMandala(
                                      viewModel.etapaAtual, viewModel.diasCompletados, viewModel.listaEtapasMandalas)!,
                                  width: MediaQuery.sizeOf(context).height < 800.0 ? 180.0 : 250.0,
                                  height: MediaQuery.sizeOf(context).height < 800.0 ? 180.0 : 250.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                await viewModel.startDesafio();

                                context.pushNamed(
                                  DesafioOnboardingPage.routeName,
                                  extra: <String, dynamic>{
                                    kTransitionInfoKey: const TransitionInfo(
                                      hasTransition: true,
                                      transitionType: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 0),
                                    ),
                                  },
                                );
                              },
                              text: 'Iniciar',
                              options: FFButtonOptions(
                                height: 40.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                color: const Color(0xFFF9A61A),
                                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                      fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                    ),
                                elevation: 3.0,
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 32.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  functions.getURLMandala(
                                      viewModel.etapaAtual, viewModel.diasCompletados, viewModel.listaEtapasMandalas)!,
                                  width: MediaQuery.sizeOf(context).height < 800.0 ? 180.0 : 250.0,
                                  height: MediaQuery.sizeOf(context).height < 800.0 ? 180.0 : 250.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                context.pushNamed(
                                  ListaEtapasPage.routeName,
                                  extra: <String, dynamic>{
                                    kTransitionInfoKey: const TransitionInfo(
                                      hasTransition: true,
                                      transitionType: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 0),
                                    ),
                                  },
                                );
                              },
                              text: 'Continuar',
                              options: FFButtonOptions(
                                height: 40.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                color: const Color(0xFFF9A61A),
                                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                      fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                      color: FlutterFlowTheme.of(context).info,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                    ),
                                elevation: 3.0,
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
