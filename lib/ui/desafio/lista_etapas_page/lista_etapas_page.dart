import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expandable/expandable.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

import '/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import '/ui/core/flutter_flow/flutter_flow_theme.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import '/ui/core/flutter_flow/custom_functions.dart' as functions;
import '/ui/home/home_page/home_page.dart';
import '/ui/desafio/widgets/card_dia_meditacao_widget.dart';
import '/ui/desafio/widgets/confirma_reset_desafio_widget.dart';
import '/ui/desafio/widgets/get_mandala_widget.dart';

import 'view_model/lista_etapas_view_model.dart';

class ListaEtapasPage extends StatefulWidget {
  const ListaEtapasPage({super.key});

  static String routeName = 'listaEtapasPage';
  static String routePath = 'listaEtapasPage';

  @override
  State<ListaEtapasPage> createState() => _ListaEtapasPageState();
}

class _ListaEtapasPageState extends State<ListaEtapasPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Controllers for Expandable panels
  late List<ExpandableController> _expandableControllers;

  @override
  void initState() {
    super.initState();
    logFirebaseEvent('screen_view', parameters: {'screen_name': 'listaEtapasPage'});

    _expandableControllers = List.generate(7, (_) => ExpandableController(initialExpanded: false));

    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.read<ListaEtapasViewModel>().checkAndFixData();
    });
  }

  @override
  void dispose() {
    for (var controller in _expandableControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ListaEtapasViewModel>();

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
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [FlutterFlowTheme.of(context).d21Top, FlutterFlowTheme.of(context).d21Botton],
                      stops: const [0.0, 1.0],
                      begin: const AlignmentDirectional(0.0, -1.0),
                      end: const AlignmentDirectional(0, 1.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0.0, 1.0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'Desafio 21 dias',
                                        style: FlutterFlowTheme.of(context).titleLarge.override(
                                              fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                                              color: FlutterFlowTheme.of(context).info,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
                                            ),
                                      ),
                                    ),
                                  ),
                                  if (viewModel.isTester)
                                    FlutterFlowIconButton(
                                      borderColor: Colors.transparent,
                                      borderRadius: 20.0,
                                      borderWidth: 1.0,
                                      buttonSize: 40.0,
                                      icon: Icon(
                                        Icons.lock_reset_rounded,
                                        color: FlutterFlowTheme.of(context).info,
                                        size: 24.0,
                                      ),
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
                                    )
                                  else
                                    const SizedBox(width: 40.0),
                                ],
                              ),
                            ),
                          ),
                          // Generate the 7 stages dynamically
                          ...List.generate(7, (index) {
                            final etapa = index + 1;
                            final startDay = (index * 3) + 1;
                            return _buildEtapaCard(context, viewModel, etapa, startDay, _expandableControllers[index]);
                          }).divide(const SizedBox(height: 16.0)),
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

  Widget _buildEtapaCard(
      BuildContext context, ListaEtapasViewModel viewModel, int etapa, int startDay, ExpandableController controller) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF83193F), Color(0xFFB0373E)],
          stops: [0.0, 1.0],
          begin: AlignmentDirectional(0.0, -1.0),
          end: AlignmentDirectional(0, 1.0),
        ),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).info,
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 4.0),
        child: Container(
          width: double.infinity,
          color: const Color(0x00000000),
          child: ExpandableNotifier(
            controller: controller,
            child: ExpandablePanel(
              header: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(32.0, 0.0, 0.0, 0.0),
                    child: Text(
                      'Etapa $etapa',
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                            color: FlutterFlowTheme.of(context).info,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
                          ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0.0),
                    child: Image.network(
                      functions.getURLMandala(
                          etapa, viewModel.diasCompletados, viewModel.listaEtapasMandalas.toList())!,
                      width: 30.0,
                      height: 30.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              collapsed: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [],
              ),
              expanded: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(32.0, 16.0, 32.0, 32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        GetMandalaWidget(
                          etapa: etapa,
                          diaCompletado: valueOrDefault<int>(
                            viewModel.diasCompletados,
                            0,
                          ),
                          listaEtapasMandalas: viewModel.listaEtapasMandalas,
                        ),
                      ],
                    ),
                  ),
                  CardDiaMeditacaoWidget(
                    dia: startDay,
                  ),
                  CardDiaMeditacaoWidget(
                    dia: startDay + 1,
                  ),
                  CardDiaMeditacaoWidget(
                    dia: startDay + 2,
                  ),
                ],
              ),
              theme: ExpandableThemeData(
                tapHeaderToExpand: true,
                tapBodyToExpand: false,
                tapBodyToCollapse: false,
                headerAlignment: ExpandablePanelHeaderAlignment.center,
                hasIcon: true,
                expandIcon: Icons.chevron_right_rounded,
                collapseIcon: Icons.keyboard_arrow_down_rounded,
                iconSize: 24.0,
                iconColor: FlutterFlowTheme.of(context).info,
                iconPadding: const EdgeInsets.all(8.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
