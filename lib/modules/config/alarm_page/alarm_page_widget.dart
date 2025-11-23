import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'alarm_page_model.dart';
export 'alarm_page_model.dart';

class AlarmPageWidget extends StatefulWidget {
  const AlarmPageWidget({super.key});

  static String routeName = 'alarmPage';
  static String routePath = 'alarmPage';

  @override
  State<AlarmPageWidget> createState() => _AlarmPageWidgetState();
}

class _AlarmPageWidgetState extends State<AlarmPageWidget> {
  late AlarmPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AlarmPageModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'alarmPage'});
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

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
                        fontFamily:
                            FlutterFlowTheme.of(context).titleLargeFamily,
                        color: FlutterFlowTheme.of(context).info,
                        letterSpacing: 0.0,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).titleLargeIsCustom,
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
                      child: custom_widgets.ClockWidget(
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
                          fontFamily:
                              FlutterFlowTheme.of(context).labelLargeFamily,
                          color: FlutterFlowTheme.of(context).primary,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).labelLargeIsCustom,
                        ),
                  ),
                ),
              ),
              Text(
                'Hora de Meditar',
                style: FlutterFlowTheme.of(context).headlineLarge.override(
                      fontFamily:
                          FlutterFlowTheme.of(context).headlineLargeFamily,
                      color: FlutterFlowTheme.of(context).primary,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).headlineLargeIsCustom,
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
                            // criei um widgetState timeSelected porque não consegui pegar em uma codeexpression o datePicked gerado pelo Time Picker Action.
                            // Uso o timeSelect para criar uma key (id) na strutura alarm (key, showTime)

                            final datePickedTime = await showTimePicker(
                              context: context,
                              initialTime:
                                  TimeOfDay.fromDateTime(getCurrentTimestamp),
                            );
                            if (datePickedTime != null) {
                              safeSetState(() {
                                _model.datePicked = DateTime(
                                  getCurrentTimestamp.year,
                                  getCurrentTimestamp.month,
                                  getCurrentTimestamp.day,
                                  datePickedTime.hour,
                                  datePickedTime.minute,
                                );
                              });
                            } else if (_model.datePicked != null) {
                              safeSetState(() {
                                _model.datePicked = getCurrentTimestamp;
                              });
                            }
                            // set timeSelected with picker time
                            _model.timeSelected = _model.datePicked;
                            safeSetState(() {});
                            if (FFAppState()
                                    .alarms
                                    .where((e) =>
                                        e.showTime ==
                                        functions.showTime(_model.datePicked!))
                                    .toList().isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Já existe lembrete para as ${functions.showTime(_model.datePicked!)}!',
                                    style: TextStyle(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                                  ),
                                  duration: const Duration(milliseconds: 4000),
                                  backgroundColor:
                                      FlutterFlowTheme.of(context).secondary,
                                ),
                              );
                            } else {
                              FFAppState().addToAlarms(AlarmTimeStruct(
                                key: _model.timeSelected!.millisecondsSinceEpoch
                                    .hashCode,
                                showTime:
                                    functions.showTime(_model.datePicked!),
                              ));
                              safeSetState(() {});
                              await actions.scheduleAlarm(
                                context,
                                _model.timeSelected!.millisecondsSinceEpoch
                                    .hashCode,
                                _model.timeSelected!,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Lembrete para as ${functions.showTime(_model.datePicked!)}  inserido!',
                                    style: TextStyle(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                                  ),
                                  duration: const Duration(milliseconds: 4000),
                                  backgroundColor:
                                      FlutterFlowTheme.of(context).secondary,
                                ),
                              );
                            }
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
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                8.0, 8.0, 0.0, 8.0),
                            iconColor: FlutterFlowTheme.of(context).info,
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .titleSmallFamily,
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .titleSmallIsCustom,
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
                      final alarmList = FFAppState()
                          .alarms
                          .map((e) => e)
                          .toList()
                          .take(20)
                          .toList();

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
                              await actions.deleteAlarmNotification(
                                alarmListItem.key,
                              );
                              FFAppState()
                                  .removeAtIndexFromAlarms(alarmListIndex);
                              safeSetState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Lembrete para as ${alarmListItem.showTime} removido!',
                                    style: TextStyle(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                                  ),
                                  duration: const Duration(milliseconds: 4000),
                                  backgroundColor:
                                      FlutterFlowTheme.of(context).secondary,
                                ),
                              );
                            },
                            child: Slidable(
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                extentRatio: 0.25,
                                children: [
                                  SlidableAction(
                                    label: 'Delete',
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).error,
                                    icon: Icons.delete,
                                    onPressed: (_) async {
                                      await actions.deleteAlarmNotification(
                                        alarmListItem.key,
                                      );
                                      FFAppState().removeAtIndexFromAlarms(
                                          alarmListIndex);
                                      safeSetState(() {});
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Lembrete para as ${alarmListItem.showTime} removido!',
                                            style: TextStyle(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                          ),
                                          duration:
                                              const Duration(milliseconds: 4000),
                                          backgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondary,
                                        ),
                                      );
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
                                    style: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .labelLargeFamily,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .labelLargeIsCustom,
                                        ),
                                  ),
                                  trailing: Icon(
                                    Icons.delete,
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                  tileColor: FlutterFlowTheme.of(context)
                                      .primaryBackground,
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
  }
}
