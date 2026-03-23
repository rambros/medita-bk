import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/ui/agenda/widgets/agenda_widget.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'view_model/programacao_cidade_view_model.dart';

class ProgramacaoCidadePage extends StatefulWidget {
  const ProgramacaoCidadePage({super.key});

  static String routeName = 'programacaoCidadePage';
  static String routePath = 'programacaoCidadePage';

  @override
  State<ProgramacaoCidadePage> createState() => _ProgramacaoCidadePageState();
}

class _ProgramacaoCidadePageState extends State<ProgramacaoCidadePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    logFirebaseEvent('screen_view', parameters: {'screen_name': 'programacaoCidadePage'});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProgramacaoCidadeViewModel>().loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProgramacaoCidadeViewModel>();

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
                  'Programação por Cidade',
                  style: FlutterFlowTheme.of(context).titleLarge.override(
                        fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                        color: FlutterFlowTheme.of(context).info,
                        letterSpacing: 0.0,
                        useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
                      ),
                ),
                actions: const [],
                centerTitle: true,
                elevation: 2.0,
              )
            : null,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 1.0,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: viewModel.selectedOrgId,
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24.0,
                      ),
                      elevation: 2,
                      style: FlutterFlowTheme.of(context).bodyMedium,
                      isExpanded: true,
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          viewModel.setSelectedCity(newValue);
                        }
                      },
                      items: Cidades.lista.entries.map<DropdownMenuItem<int>>((entry) {
                        return DropdownMenuItem<int>(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: viewModel.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                      )
                    : viewModel.errorMessage != null
                        ? Center(
                            child: Text(
                              viewModel.errorMessage!,
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      width: MediaQuery.sizeOf(context).width * 1.0,
                                      height: MediaQuery.sizeOf(context).height * 0.85,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                      ),
                                      child: SizedBox(
                                        width: MediaQuery.sizeOf(context).width * 1.0,
                                        height: MediaQuery.sizeOf(context).height * 0.85,
                                        child: AgendaWidget(
                                          width: MediaQuery.sizeOf(context).width * 1.0,
                                          height: MediaQuery.sizeOf(context).height * 0.85,
                                          listEvents: viewModel.events,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
