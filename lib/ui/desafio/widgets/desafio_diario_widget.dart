// Automatic FlutterFlow imports
import '/core/structs/index.dart';
import '/ui/core/flutter_flow/flutter_flow_theme.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import '/ui/core/flutter_flow/custom_functions.dart';
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<D21MeditationModelStruct>? source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    //var _startTime = dateFormat.parse(appointments![index].startTimestamp);
    return appointments![index].dateCompleted;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].dateCompleted;
  }

  @override
  String getSubject(int index) {
    return appointments![index].titulo;
  }

  @override
  Color getColor(int index) {
    return Colors.orange[400]!;
  }
}

class DesafioDiarioWidget extends StatefulWidget {
  const DesafioDiarioWidget({
    super.key,
    this.width,
    this.height,
    this.listD21Meditations,
  });

  final double? width;
  final double? height;
  final List<D21MeditationModelStruct>? listD21Meditations;

  @override
  _DesafioDiarioWidgetState createState() => _DesafioDiarioWidgetState();
}

class _DesafioDiarioWidgetState extends State<DesafioDiarioWidget> {
  @override
  Widget build(BuildContext bigContext) {
    //var teste = widget.listEvents[0].toSerializableMap();
    return FutureBuilder(
      //future: Future.value(widget.listD21Meditations),
      future: Future.value(widget.listD21Meditations),
      builder: (BuildContext context, AsyncSnapshot<List<D21MeditationModelStruct>?> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.error_outline,
                  color: FlutterFlowTheme.of(context).error,
                  size: 60,
                ),
                Text('Error: ${snapshot.error}'),
              ],
            ),
          );
        } else {
          widget.listD21Meditations!.removeWhere((item) => item.dateCompleted == null);
          return Container(
            padding: const EdgeInsets.all(8),
            child: SfCalendar(
              firstDayOfWeek: 1,
              showNavigationArrow: true,
              appointmentTimeTextFormat: 'Hm',
              todayHighlightColor: FlutterFlowTheme.of(context).d21Orange,
              //cellBorderColor: Colors.white30,
              view: CalendarView.month,
              viewHeaderStyle: ViewHeaderStyle(
                dayTextStyle: TextStyle(color: FlutterFlowTheme.of(context).info, fontSize: 14),
                dateTextStyle: TextStyle(color: FlutterFlowTheme.of(context).info, fontSize: 14),
              ),
              headerStyle: CalendarHeaderStyle(
                textStyle: TextStyle(color: FlutterFlowTheme.of(context).info, fontSize: 24),
                textAlign: TextAlign.justify,
              ),
              selectionDecoration: BoxDecoration(
                //color: Colors.purpleAccent,
                border: Border.all(color: Colors.white, width: 1),
              ),
              dataSource: EventDataSource(snapshot.data),
              monthViewSettings: MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.none,
                showAgenda: false,
                dayFormat: 'EEE',
                monthCellStyle: MonthCellStyle(
                  textStyle:
                      TextStyle(fontStyle: FontStyle.normal, fontSize: 18, color: FlutterFlowTheme.of(context).info),
                  trailingDatesTextStyle:
                      TextStyle(fontStyle: FontStyle.normal, fontSize: 18, color: FlutterFlowTheme.of(context).info),
                  leadingDatesTextStyle:
                      TextStyle(fontStyle: FontStyle.normal, fontSize: 18, color: FlutterFlowTheme.of(context).info),
                ),
              ),

              monthCellBuilder: monthCellBuilder,

              onTap: (details) async {
                if (details.targetElement == CalendarElement.calendarCell) {
                  if (details.appointments!.isEmpty) {
                    return;
                  }
                  bigContext.pushNamed(
                    'diarioDetalhesPage',
                    queryParameters: {
                      'listaMeditacoes': serializeParam(
                        details.appointments,
                        //widget.listD21Meditations,
                        ParamType.DataStruct,
                        isList: true,
                      ),
                    },
                  );
                }
              },
            ),
          );
        }
      },
    );
  }
}

Widget monthCellBuilder(BuildContext context, MonthCellDetails details) {
  final String diaCalendario = details.date.day.toString();
  if (details.appointments.isNotEmpty) {
    D21MeditationModelStruct d21meditation = details.appointments[0] as D21MeditationModelStruct;
    final int d21Dia = d21meditation.dia;
    if ((d21Dia == 3) | (d21Dia == 9) | (d21Dia == 21)) {
      return DiaComBrasao(dia: diaCalendario);
    } else if (completouMandala(d21meditation.etapa, d21Dia)) {
      return DiaComMandala(dia: diaCalendario);
    } else {
      return DiaComMeditacao(dia: diaCalendario);
    }
  }
  return DiaSemMeditacao(dia: diaCalendario);
}

class DiaComMeditacao extends StatelessWidget {
  const DiaComMeditacao({super.key, required this.dia});
  final String dia;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.0, 0.0),
      child: Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).d21Top,
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Align(
            alignment: const AlignmentDirectional(0.0, 0.0),
            child: Text(
              dia,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    color: FlutterFlowTheme.of(context).info,
                    fontSize: 18.0,
                    letterSpacing: 0.0,
                  ),
            ),
          )),
    );
  }
}

class DiaComMandala extends StatelessWidget {
  const DiaComMandala({super.key, required this.dia});
  final String dia;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.0, 0.0),
      child: Container(
          width: 44.0,
          height: 44.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).d21Top,
            borderRadius: BorderRadius.circular(50.0),
            border: Border.all(
              color: FlutterFlowTheme.of(context).d21Orange,
              width: 5.0,
            ),
          ),
          child: Align(
            alignment: const AlignmentDirectional(0.0, 0.0),
            child: Text(
              dia,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    color: FlutterFlowTheme.of(context).info,
                    fontSize: 18.0,
                    letterSpacing: 0.0,
                  ),
            ),
          )),
    );
  }
}

class DiaComBrasao extends StatelessWidget {
  const DiaComBrasao({super.key, required this.dia});
  final String dia;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: const AlignmentDirectional(0.0, 0.0),
          child: Container(
            width: 44.0,
            height: 44.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).d21Top,
              borderRadius: BorderRadius.circular(50.0),
              border: Border.all(
                color: FlutterFlowTheme.of(context).d21Orange,
                width: 5.0,
              ),
            ),
            child: Align(
              alignment: const AlignmentDirectional(0.0, 0.0),
              child: Text(
                dia,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      color: FlutterFlowTheme.of(context).info,
                      fontSize: 18.0,
                      letterSpacing: 0.0,
                    ),
              ),
            ),
          ),
        ),
        Align(
          alignment: const AlignmentDirectional(0.8, 0.7),
          child: Container(
            width: 28.0,
            height: 28.0,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/images/Mandala_6-4.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

class DiaSemMeditacao extends StatelessWidget {
  const DiaSemMeditacao({super.key, required this.dia});
  final String dia;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.0, 0.0),
      child: SizedBox(
          width: 40.0,
          height: 40.0,
          child: Align(
            alignment: const AlignmentDirectional(0.0, 0.0),
            child: Text(
              dia,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    color: FlutterFlowTheme.of(context).info,
                    fontSize: 18.0,
                    letterSpacing: 0.0,
                  ),
            ),
          )),
    );
  }
}
