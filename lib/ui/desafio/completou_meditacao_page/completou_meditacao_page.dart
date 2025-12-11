import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_widgets.dart';
import 'package:medita_bk/ui/desafio/home_desafio_page/home_desafio_page.dart';
import 'package:medita_bk/ui/desafio/completou_mandala_page/completou_mandala_page.dart';

import 'view_model/completou_meditacao_view_model.dart';

class CompletouMeditacaoPage extends StatefulWidget {
  const CompletouMeditacaoPage({
    super.key,
    required this.parmDiaCompletado,
  });

  final int? parmDiaCompletado;

  static String routeName = 'completouMeditacaoPage';
  static String routePath = 'completouMeditacaoPage';

  @override
  State<CompletouMeditacaoPage> createState() => _CompletouMeditacaoPageState();
}

class _CompletouMeditacaoPageState extends State<CompletouMeditacaoPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  CompletouMeditacaoViewModel? _viewModel;

  @override
  void initState() {
    super.initState();
    logFirebaseEvent('screen_view', parameters: {'screen_name': 'completouMeditacaoPage'});

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await _viewModel?.processarConclusaoMeditacao();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel == null && widget.parmDiaCompletado != null) {
      _viewModel = CompletouMeditacaoViewModel(
        repository: context.read(),
        diaCompletado: widget.parmDiaCompletado!,
      );
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

    return ChangeNotifierProvider<CompletouMeditacaoViewModel>.value(
      value: _viewModel!,
      child: Consumer<CompletouMeditacaoViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return Scaffold(
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              body: const Center(child: CircularProgressIndicator()),
            );
          }

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
                                _buildHeader(context),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      _buildCompletionCard(context, viewModel),
                                      _buildActionButton(context, viewModel),
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
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.0, 1.0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.chevron_left,
              color: Colors.transparent,
              size: 24.0,
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
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionCard(BuildContext context, CompletouMeditacaoViewModel viewModel) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
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
              colors: [Color(0xCC83193F), Color(0xCBB0373E)],
              stops: [0.0, 1.0],
              begin: AlignmentDirectional(0.0, -1.0),
              end: AlignmentDirectional(0, 1.0),
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                        child: Text(
                          'Dia ${viewModel.diaNumero}: ${viewModel.meditationTitle}',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context).labelLarge.override(
                                fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                color: FlutterFlowTheme.of(context).info,
                                fontSize: 22.0,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 32.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        viewModel.mandalaURL ??
                            'https://firebasestorage.googleapis.com/v0/b/meditabk2020.appspot.com/o/desafio%2Fetapa2%2FMandala%202-1.png?alt=media&token=638044ff-ef95-4407-ac8d-ce982370f135',
                        width: MediaQuery.sizeOf(context).height < 800.0 ? 150.0 : 250.0,
                        height: MediaQuery.sizeOf(context).height < 800.0 ? 150.0 : 250.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                child: Text(
                  'Meditação concluída!',
                  style: FlutterFlowTheme.of(context).titleLarge.override(
                        fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                        color: FlutterFlowTheme.of(context).info,
                        letterSpacing: 0.0,
                        useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 16.0),
                child: Text(
                  'A meditação Raja Yoga nos permite sair de uma situação desconfortável para viver uma experiência de calma e força para lidar com quaisquer imprevistos.',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).labelLarge.override(
                        fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                        color: FlutterFlowTheme.of(context).info,
                        letterSpacing: 0.0,
                        useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
                child: Text(
                  'Como você está se sentindo agora?',
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                        color: FlutterFlowTheme.of(context).info,
                        letterSpacing: 0.0,
                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, CompletouMeditacaoViewModel viewModel) {
    if (viewModel.isMeditacaoJaFeita) {
      return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
        child: FFButtonWidget(
          onPressed: () async {
            if (!mounted) return;
            context.goNamed(
              HomeDesafioPage.routeName,
              extra: <String, dynamic>{
                kTransitionInfoKey: const TransitionInfo(
                  hasTransition: true,
                  transitionType: PageTransitionType.fade,
                  duration: Duration(milliseconds: 0),
                ),
              },
            );
          },
          text: 'Retornar',
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
      );
    }

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
      child: FFButtonWidget(
        onPressed: () async {
          if (!mounted) return;

          if (viewModel.shouldNavigateToMandala()) {
            context.goNamed(
              CompletouMandalaPage.routeName,
              queryParameters: {
                'diaCompletado': serializeParam(
                  widget.parmDiaCompletado,
                  ParamType.int,
                ),
                'etapaCompletada': serializeParam(
                  viewModel.desafio21.etapasCompletadas,
                  ParamType.int,
                ),
                'parmMandalaUrl': serializeParam(
                  viewModel.mandalaURL,
                  ParamType.String,
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
          } else {
            context.pushNamed(
              HomeDesafioPage.routeName,
              extra: <String, dynamic>{
                kTransitionInfoKey: const TransitionInfo(
                  hasTransition: true,
                  transitionType: PageTransitionType.fade,
                  duration: Duration(milliseconds: 0),
                ),
              },
            );
          }
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
    );
  }
}
