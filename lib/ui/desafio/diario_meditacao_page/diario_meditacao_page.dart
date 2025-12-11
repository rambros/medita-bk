import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:medita_bk/data/repositories/auth_repository.dart';

import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/ui/desafio/widgets/desafio_diario_widget.dart';

import 'view_model/diario_meditacao_view_model.dart';

class DiarioMeditacaoPage extends StatefulWidget {
  const DiarioMeditacaoPage({super.key});

  static String routeName = 'diarioMeditacaoPage';
  static String routePath = 'diarioMeditacaoPage';

  @override
  State<DiarioMeditacaoPage> createState() => _DiarioMeditacaoPageState();
}

class _DiarioMeditacaoPageState extends State<DiarioMeditacaoPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late DiarioMeditacaoViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = DiarioMeditacaoViewModel(authRepository: context.read<AuthRepository>());
    logFirebaseEvent('screen_view', parameters: {'screen_name': 'diarioMeditacaoPage'});

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _viewModel.loadMeditacoes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DiarioMeditacaoViewModel>.value(
      value: _viewModel,
      child: Consumer<DiarioMeditacaoViewModel>(
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
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 32.0),
                                        child: Text(
                                          'Diário de meditação',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context).titleLarge.override(
                                                fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                                                color: FlutterFlowTheme.of(context).info,
                                                fontSize: 32.0,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
                                              ),
                                        ),
                                      ),
                                      _buildDiarioCard(context, viewModel),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                                        child: Text(
                                          'Clique na data escolhida e veja as suas conquistas',
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                color: FlutterFlowTheme.of(context).info,
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
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
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                context.safePop();
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
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiarioCard(BuildContext context, DiarioMeditacaoViewModel viewModel) {
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
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 0.6,
                  child: DesafioDiarioWidget(
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * 0.6,
                    listD21Meditations: viewModel.listaMeditacoes,
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
