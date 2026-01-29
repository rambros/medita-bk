import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_animations.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'view_model/mensagem_details_view_model.dart';

class MensagemDetailsPage extends StatefulWidget {
  const MensagemDetailsPage({super.key});

  static String routeName = 'mensagemDetailsPage';
  static String routePath = 'mensagemDetailsPage';

  @override
  State<MensagemDetailsPage> createState() => _MensagemDetailsPageState();
}

class _MensagemDetailsPageState extends State<MensagemDetailsPage> with TickerProviderStateMixin {
  MensagemDetailsViewModel? _viewModel;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'mensagemDetailsPage'});

    // Load mensagem do dia after build
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _viewModel = context.read<MensagemDetailsViewModel>();
      await _viewModel?.loadMensagemDoDia();
    });

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.linear,
            delay: 0.0.ms,
            duration: 12000.0.ms,
            begin: 0.0,
            end: 0.8,
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MensagemDetailsViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
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
            appBar: responsiveVisibility(
              context: context,
              tabletLandscape: false,
              desktop: false,
            )
                ? AppBar(
                    backgroundColor: FlutterFlowTheme.of(context).primary,
                    automaticallyImplyLeading: false,
                    leading: FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 30.0,
                      borderWidth: 1.0,
                      buttonSize: 60.0,
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: FlutterFlowTheme.of(context).info,
                        size: 30.0,
                      ),
                      onPressed: () async {
                        context.pop();
                      },
                    ),
                    title: Text(
                      'Mensagem para hoje',
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                            color: FlutterFlowTheme.of(context).info,
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
                          ),
                    ),
                    actions: [
                      FlutterFlowIconButton(
                        borderColor: Colors.transparent,
                        borderRadius: 30.0,
                        borderWidth: 1.0,
                        buttonSize: 50.0,
                        icon: Icon(
                          Icons.format_size_rounded,
                          color: FlutterFlowTheme.of(context).info,
                          size: 28.0,
                        ),
                        onPressed: () async {
                          _showSettingsBottomSheet(context);
                        },
                      ),
                      FlutterFlowIconButton(
                        borderColor: Colors.transparent,
                        borderRadius: 30.0,
                        borderWidth: 1.0,
                        buttonSize: 50.0,
                        icon: Icon(
                          Icons.search,
                          color: FlutterFlowTheme.of(context).info,
                          size: 28.0,
                        ),
                        onPressed: () async {
                          if (Navigator.of(context).canPop()) {
                            context.pop();
                          }
                          context.pushNamed(
                            'mensagensSemanticSearchPage',
                            extra: <String, dynamic>{
                              kTransitionInfoKey: const TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.leftToRight,
                              ),
                            },
                          );
                        },
                      ),
                    ],
                    centerTitle: true,
                    elevation: 2.0,
                  )
                : null,
            body: SafeArea(
              top: true,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.sizeOf(context).height * 0.94,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: MediaQuery.sizeOf(context).height * 0.94,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                              image: viewModel.showBackground
                                  ? DecorationImage(
                                      fit: BoxFit.cover,
                                      image: Image.asset(
                                        'assets/images/Shiva-03.jpg',
                                      ).image,
                                    )
                                  : null,
                            ),
                          ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        viewModel.messageDoc != null ? viewModel.messageDoc!.tema : ' ',
                                        style: FlutterFlowTheme.of(context).titleMedium.override(
                                              fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                                              color: FlutterFlowTheme.of(context).primaryText,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts: !FlutterFlowTheme.of(context).titleMediumIsCustom,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Flexible(
                                          child: SelectionArea(
                                            child: Text(
                                              viewModel.messageDoc != null ? viewModel.messageDoc!.mensagem : ' ',
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                    fontSize: viewModel.fontSize,
                                                    letterSpacing: 0.0,
                                                    lineHeight: 1.25,
                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Builder(
                                        builder: (context) => FFButtonWidget(
                                          onPressed: () async {
                                            await viewModel.shareMensagem(
                                              getWidgetBoundingBox(context),
                                            );
                                          },
                                          text: 'Compartilhar esta mensagem',
                                          options: FFButtonOptions(
                                            height: 40.0,
                                            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                            iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                            color: FlutterFlowTheme.of(context).primary,
                                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                  fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                                  color: FlutterFlowTheme.of(context).primaryText,
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
        );
      },
    );
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      barrierColor: Colors.black.withOpacity(0.4),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return Consumer<MensagemDetailsViewModel>(
          builder: (context, model, child) {
            return Container(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 12,
                bottom: MediaQuery.of(context).padding.bottom + 24,
              ),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).alternate.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Icon(Icons.format_size_rounded, color: FlutterFlowTheme.of(context).secondaryText, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Tamanho da Fonte',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontWeight: FontWeight.w600,
                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'A',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                            ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: FlutterFlowTheme.of(context).primary,
                            inactiveTrackColor: FlutterFlowTheme.of(context).alternate.withOpacity(0.3),
                            thumbColor: FlutterFlowTheme.of(context).primary,
                            overlayColor: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                          ),
                          child: Slider(
                            value: model.fontSize,
                            min: 14,
                            max: 28,
                            onChanged: (val) => model.setFontSize(val),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'A',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(color: FlutterFlowTheme.of(context).alternate.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.image_outlined, color: FlutterFlowTheme.of(context).secondaryText, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Imagem de Fundo',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                  fontWeight: FontWeight.w600,
                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                ),
                          ),
                        ],
                      ),
                      Switch.adaptive(
                        value: model.showBackground,
                        activeColor: FlutterFlowTheme.of(context).primary,
                        activeTrackColor: FlutterFlowTheme.of(context).primary.withOpacity(0.3),
                        onChanged: (val) => model.toggleBackground(val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
