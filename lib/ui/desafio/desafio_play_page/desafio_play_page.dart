import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import 'package:medita_bk/data/repositories/auth_repository.dart';
import 'package:medita_bk/data/repositories/home_repository.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/ui/desafio/widgets/f_f_desafio_audio_player_widget.dart';
import 'package:medita_bk/ui/desafio/lista_etapas_page/lista_etapas_page.dart';
import 'package:medita_bk/ui/desafio/completou_meditacao_page/completou_meditacao_page.dart';

import 'view_model/desafio_play_view_model.dart';

class DesafioPlayPage extends StatefulWidget {
  const DesafioPlayPage({
    super.key,
    required this.indiceListaMeditacao,
  });

  final int? indiceListaMeditacao;

  static String routeName = 'desafioPlayPage';
  static String routePath = 'desafioPlayPage';

  @override
  State<DesafioPlayPage> createState() => _DesafioPlayPageState();
}

class _DesafioPlayPageState extends State<DesafioPlayPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DesafioPlayViewModel? _viewModel;

  @override
  void initState() {
    super.initState();
    logFirebaseEvent('screen_view', parameters: {'screen_name': 'desafioPlayPage'});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel == null && widget.indiceListaMeditacao != null) {
      _viewModel = DesafioPlayViewModel(
        meditationIndex: widget.indiceListaMeditacao!,
        authRepository: context.read<AuthRepository>(),
        homeRepository: context.read<HomeRepository>(),
      );

      // Load data immediately after creating viewModel
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        await _viewModel?.loadDesafioData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_viewModel == null) {
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return ChangeNotifierProvider<DesafioPlayViewModel>.value(
      value: _viewModel!,
      child: Consumer<DesafioPlayViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.errorMessage != null) {
            return Scaffold(
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              body: Center(
                child: Text(
                  viewModel.errorMessage!,
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ),
            );
          }

          if (viewModel.currentMeditation == null) {
            return Scaffold(
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              body: Center(
                child: Text(
                  'Meditação não encontrada',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ),
            );
          }

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
                                padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 32.0),
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
                                        // Placeholder for notifications
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
                                  padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                  child: Text(
                                    viewModel.meditationTitle,
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context).titleLarge.override(
                                          fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                                          color: FlutterFlowTheme.of(context).info,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
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
                              padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 0.0),
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
                                    audioTitle: viewModel.meditationTitle,
                                    audioUrl: viewModel.audioUrl,
                                    audioArt: viewModel.imageUrl,
                                    nextActionFunction: () async {
                                      if (!mounted) return;
                                      context.pushNamed(
                                        CompletouMeditacaoPage.routeName,
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
        },
      ),
    );
  }
}
