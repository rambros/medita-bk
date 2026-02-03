import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/ui/desafio/widgets/desafio_header_widget.dart';
import 'package:medita_bk/ui/desafio/widgets/desafio_navigation_cards_widget.dart';
import 'package:medita_bk/ui/desafio/widgets/desafio_completed_view_widget.dart';
import 'package:medita_bk/ui/desafio/widgets/desafio_active_view_widget.dart';

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
                          // Header
                          const DesafioHeaderWidget(),

                          // Main content
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                // Completed or Active view
                                Builder(
                                  builder: (context) {
                                    if (viewModel.isD21Completed) {
                                      return const DesafioCompletedViewWidget();
                                    } else {
                                      return DesafioActiveViewWidget(viewModel: viewModel);
                                    }
                                  },
                                ),

                                // Navigation cards
                                const DesafioNavigationCardsWidget(),
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
}
