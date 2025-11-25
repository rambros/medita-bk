import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import '/ui/core/flutter_flow/flutter_flow_theme.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import '/ui/core/flutter_flow/flutter_flow_widgets.dart';
import '/core/utils/ui_utils.dart';
import '/ui/core/flutter_flow/custom_functions.dart' as functions;
import '/ui/desafio/home_desafio_page/home_desafio_page.dart';
import '/ui/desafio/completou_brasao_page/completou_brasao_page.dart';

import 'view_model/completou_mandala_view_model.dart';

class CompletouMandalaPage extends StatefulWidget {
  const CompletouMandalaPage({
    super.key,
    required this.diaCompletado,
    required this.etapaCompletada,
    required this.parmMandalaUrl,
  });

  final int? diaCompletado;
  final int? etapaCompletada;
  final String? parmMandalaUrl;

  static String routeName = 'completouMandalaPage';
  static String routePath = 'completouMandalaPage';

  @override
  State<CompletouMandalaPage> createState() => _CompletouMandalaPageState();
}

class _CompletouMandalaPageState extends State<CompletouMandalaPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  CompletouMandalaViewModel? _viewModel;

  @override
  void initState() {
    super.initState();
    logFirebaseEvent('screen_view', parameters: {'screen_name': 'completouMandalaPage'});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel == null &&
        widget.diaCompletado != null &&
        widget.etapaCompletada != null &&
        widget.parmMandalaUrl != null) {
      _viewModel = CompletouMandalaViewModel(
        diaCompletado: widget.diaCompletado!,
        etapaCompletada: widget.etapaCompletada!,
        mandalaUrl: widget.parmMandalaUrl!,
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

    return ChangeNotifierProvider<CompletouMandalaViewModel>.value(
      value: _viewModel!,
      child: Consumer<CompletouMandalaViewModel>(
        builder: (context, viewModel, _) {
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
                                      _buildActionButtons(context, viewModel),
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

  Widget _buildCompletionCard(BuildContext context, CompletouMandalaViewModel viewModel) {
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
                    Padding(
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
                        viewModel.mandalaUrl,
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
                  'Excelente!',
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
                  viewModel.textoMandalaCompleta,
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
                  'Compartilhe sua conquista!',
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

  Widget _buildActionButtons(BuildContext context, CompletouMandalaViewModel viewModel) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
          child: FFButtonWidget(
            onPressed: () async {
              final imageUrl = viewModel.shareImageUrl;
              if (imageUrl != null) {
                await UIUtils.shareImageAndText(
                  functions.getStringFromImagePath(imageUrl)!,
                  viewModel.textoCompartilhar,
                );
              }
            },
            text: 'Compartilhar',
            options: FFButtonOptions(
              height: 40.0,
              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
              iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              color: FlutterFlowTheme.of(context).info,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                    color: const Color(0xFFF9A61A),
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
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
          child: FFButtonWidget(
            onPressed: () async {
              if (!mounted) return;

              if (viewModel.shouldNavigateToBrasao()) {
                context.pushNamed(
                  CompletouBrasaoPage.routeName,
                  queryParameters: {
                    'indiceBrasao': serializeParam(
                      viewModel.getBrasaoIndex(),
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
        ),
      ],
    );
  }
}
