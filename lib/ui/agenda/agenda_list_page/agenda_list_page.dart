import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'view_model/agenda_list_view_model.dart';

class AgendaListPage extends StatefulWidget {
  const AgendaListPage({super.key});

  static String routeName = 'agendaListPage';
  static String routePath = 'agendaListPage';

  @override
  State<AgendaListPage> createState() => _AgendaListPageState();
}

class _AgendaListPageState extends State<AgendaListPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    logFirebaseEvent('screen_view', parameters: {'screen_name': 'agendaListPage'});

    // Load events on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AgendaListViewModel>().loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AgendaListViewModel>();

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
                  'Agenda de atividades',
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
                                height: MediaQuery.sizeOf(context).height * 0.93,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                ),
                                child: SizedBox(
                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                  height: MediaQuery.sizeOf(context).height * 0.96,
                                  child: custom_widgets.AgendaWidget(
                                    width: MediaQuery.sizeOf(context).width * 1.0,
                                    height: MediaQuery.sizeOf(context).height * 0.96,
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
      ),
    );
  }
}
