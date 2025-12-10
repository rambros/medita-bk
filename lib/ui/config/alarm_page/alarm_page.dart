import 'package:medita_b_k/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import 'package:medita_b_k/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_b_k/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_b_k/ui/core/flutter_flow/flutter_flow_widgets.dart';
import 'package:medita_b_k/ui/core/widgets/clock_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'view_model/alarm_view_model.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  static String routeName = 'alarmPage';
  static String routePath = 'alarmPage';

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    logFirebaseEvent('screen_view', parameters: {'screen_name': 'alarmPage'});
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppStateStore>();

    return ChangeNotifierProvider(
      create: (_) => AlarmViewModel(),
      child: Consumer<AlarmViewModel>(
        builder: (context, viewModel, child) {
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
                        'Lembretes para Meditar',
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
                    Align(
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 0.82,
                          height: MediaQuery.sizeOf(context).height * 0.36,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primaryBackground,
                          ),
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: SizedBox(
                            width: MediaQuery.sizeOf(context).width * 1.0,
                            height: MediaQuery.sizeOf(context).height * 1.0,
                            child: ClockWidget(
                              width: MediaQuery.sizeOf(context).width * 1.0,
                              height: MediaQuery.sizeOf(context).height * 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        child: Text(
                          'Para manter-se em paz e centrado, \ndê uma paradinha algumas vezes ao dia',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context).labelLarge.override(
                                fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                color: FlutterFlowTheme.of(context).primary,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                              ),
                        ),
                      ),
                    ),
                    Text(
                      'Hora de Meditar',
                      style: FlutterFlowTheme.of(context).headlineLarge.override(
                            fontFamily: FlutterFlowTheme.of(context).headlineLargeFamily,
                            color: FlutterFlowTheme.of(context).primary,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            useGoogleFonts: !FlutterFlowTheme.of(context).headlineLargeIsCustom,
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 24.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  await viewModel.addAlarm(context);
                                },
                                text: '',
                                icon: const Icon(
                                  Icons.add,
                                  size: 32.0,
                                ),
                                options: FFButtonOptions(
                                  width: 60.0,
                                  height: 50.0,
                                  padding: const EdgeInsets.all(0.0),
                                  iconPadding: const EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 0.0, 8.0),
                                  iconColor: FlutterFlowTheme.of(context).info,
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                        fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                      ),
                                  elevation: 4.0,
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 100.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        child: Builder(
                          builder: (context) {
                            final alarmList = AppStateStore().alarms.map((e) => e).toList().take(20).toList();

                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              itemCount: alarmList.length,
                              itemBuilder: (context, alarmListIndex) {
                                final alarmListItem = alarmList[alarmListIndex];
                                return InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    await viewModel.removeAlarm(context, alarmListIndex, alarmListItem);
                                  },
                                  child: Slidable(
                                    endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      extentRatio: 0.25,
                                      children: [
                                        SlidableAction(
                                          label: 'Delete',
                                          backgroundColor: FlutterFlowTheme.of(context).error,
                                          icon: Icons.delete,
                                          onPressed: (_) async {
                                            await viewModel.removeAlarm(context, alarmListIndex, alarmListItem);
                                          },
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: ListTile(
                                        title: Text(
                                          valueOrDefault<String>(
                                            alarmListItem.showTime,
                                            'teste',
                                          ),
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context).labelLarge.override(
                                                fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                                color: FlutterFlowTheme.of(context).primary,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                                              ),
                                        ),
                                        trailing: Icon(
                                          Icons.delete,
                                          color: FlutterFlowTheme.of(context).primary,
                                        ),
                                        tileColor: FlutterFlowTheme.of(context).primaryBackground,
                                        dense: false,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
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
}
