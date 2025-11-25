import '/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import '/ui/core/flutter_flow/flutter_flow_theme.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import 'widgets/daily_statistics_widget.dart';
import 'widgets/weekly_statistics_widget.dart';
import 'widgets/monthly_statistics_widget.dart';
import 'widgets/yearly_statistics_widget.dart';
import 'package:flutter/material.dart';

class MeditationStatisticsPageWidget extends StatefulWidget {
  const MeditationStatisticsPageWidget({super.key});

  static String routeName = 'meditationStatisticsPage';
  static String routePath = 'meditationStatisticsPage';

  @override
  State<MeditationStatisticsPageWidget> createState() => _MeditationStatisticsPageWidgetState();
}

class _MeditationStatisticsPageWidgetState extends State<MeditationStatisticsPageWidget> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabBarController;

  @override
  void initState() {
    super.initState();

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'meditationStatisticsPage'});
    _tabBarController = TabController(
      vsync: this,
      length: 4,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _tabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                'Estatisticas de meditação',
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
          children: [
            Align(
              alignment: const Alignment(0.0, 0),
              child: TabBar(
                labelColor: FlutterFlowTheme.of(context).primaryText,
                unselectedLabelColor: FlutterFlowTheme.of(context).secondaryText,
                labelStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                      fontSize: 15.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                    ),
                unselectedLabelStyle: const TextStyle(),
                indicatorColor: FlutterFlowTheme.of(context).primary,
                padding: const EdgeInsets.all(2.0),
                tabs: const [
                  Tab(
                    text: 'Diário',
                  ),
                  Tab(
                    text: 'Semanal',
                  ),
                  Tab(
                    text: 'Mensal',
                  ),
                  Tab(
                    text: 'Anual',
                  ),
                ],
                controller: _tabBarController,
                onTap: (i) async {
                  [() async {}, () async {}, () async {}, () async {}][i]();
                },
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabBarController,
                children: const [
                  DailyStatisticsWidget(),
                  WeeklyStatisticsWidget(),
                  MonthlyStatisticsWidget(),
                  YearlyStatisticsWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
