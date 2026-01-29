import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_animations.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'view_model/mensagem_show_view_model.dart';

class MensagemShowPage extends StatefulWidget {
  const MensagemShowPage({
    super.key,
    required this.tema,
    required this.mensagem,
  });

  final String? tema;
  final String? mensagem;

  static String routeName = 'mensagemShowPage';
  static String routePath = 'mensagemShowPage';

  @override
  State<MensagemShowPage> createState() => _MensagemShowPageState();
}

class _MensagemShowPageState extends State<MensagemShowPage> with TickerProviderStateMixin {
  MensagemShowViewModel? _viewModel;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'mensagemShowPage'});

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _viewModel = context.read<MensagemShowViewModel>();
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
                      Icons.settings_outlined,
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
                  child: Consumer<MensagemShowViewModel>(
                    builder: (context, model, child) {
                      return Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: MediaQuery.sizeOf(context).height * 0.94,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                              image: model.showBackground
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
                                        valueOrDefault<String>(
                                          widget.tema,
                                          'tema',
                                        ),
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
                                            valueOrDefault<String>(
                                              widget.mensagem,
                                              'mensagem',
                                            ),
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                  fontSize: model.fontSize,
                                                  letterSpacing: 0.0,
                                                  lineHeight: 1.25,
                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                ),
                                          )),
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
                                            await _viewModel?.shareContent(
                                              widget.tema ?? '',
                                              widget.mensagem ?? '',
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
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Consumer<MensagemShowViewModel>(
          builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).accent3,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Configurações de Visualização',
                    style: FlutterFlowTheme.of(context).titleMedium,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Text('A', style: TextStyle(fontSize: 12, color: FlutterFlowTheme.of(context).secondaryText)),
                      Expanded(
                        child: Slider(
                          value: model.fontSize,
                          min: 12,
                          max: 32,
                          activeColor: FlutterFlowTheme.of(context).primary,
                          onChanged: (val) => model.setFontSize(val),
                        ),
                      ),
                      Text('A', style: TextStyle(fontSize: 24, color: FlutterFlowTheme.of(context).secondaryText)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mostrar imagem de fundo',
                        style: FlutterFlowTheme.of(context).bodyLarge,
                      ),
                      Switch(
                        value: model.showBackground,
                        activeColor: FlutterFlowTheme.of(context).primary,
                        onChanged: (val) => model.toggleBackground(val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
