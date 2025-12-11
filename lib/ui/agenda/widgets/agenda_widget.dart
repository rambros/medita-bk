// Automatic FlutterFlow imports
import 'package:medita_bk/core/structs/index.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<EventModelStruct>? source) {
    appointments = source;
  }

  var dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  @override
  DateTime getStartTime(int index) {
    var startTime = dateFormat.parse(appointments![index].startTimestamp);
    return startTime;
  }

  @override
  DateTime getEndTime(int index) {
    var endTime = dateFormat.parse(appointments![index].endTimestamp);
    return endTime;
  }

  @override
  String getSubject(int index) {
    return appointments![index].name;
  }

  @override
  Color getColor(int index) {
    switch (appointments![index].eventTypeId) {
      case 6: // workshop
        return Colors.orange[400]!;
      case 1: //palestra
        return Colors.blue[200]!;
      case 5: //retiro
        return Colors.red[200]!;
      default:
        return Colors.green[200]!;
    }
  }
}

class AgendaWidget extends StatefulWidget {
  const AgendaWidget({
    super.key,
    this.width,
    this.height,
    this.listEvents,
  });

  final double? width;
  final double? height;
  final List<EventModelStruct>? listEvents;

  @override
  _AgendaWidgetState createState() => _AgendaWidgetState();
}

class _AgendaWidgetState extends State<AgendaWidget> {
  @override
  Widget build(BuildContext bigContext) {
    //var teste = widget.listEvents[0].toSerializableMap();
    return FutureBuilder(
      future: Future.value(widget.listEvents),
      builder: (BuildContext context, AsyncSnapshot<List<EventModelStruct>?> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              children: <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Text('Error: ${snapshot.error}'),
              ],
            ),
          );
        } else {
          return Container(
            padding: const EdgeInsets.all(8),
            child: SfCalendar(
              firstDayOfWeek: 1,
              showNavigationArrow: true,
              appointmentTimeTextFormat: 'Hm',
              view: CalendarView.month,
              dataSource: EventDataSource(snapshot.data),
              monthViewSettings: MonthViewSettings(
                //navigationDirection: MonthNavigationDirection.horizontal,
                //appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                showAgenda: true,
                agendaStyle: AgendaStyle(
                  //backgroundColor: Color(0xFF066cccc),
                  appointmentTextStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                  dateTextStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                  ),
                  dayTextStyle: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                //agendaViewHeight: 200,
                dayFormat: 'EEE',
              ),
              onTap: (details) async {
    if ((details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda)) {
      var event = details.appointments![0] as EventModelStruct;

      bigContext.pushNamed(
        'eventDetailsPage',
        queryParameters: {
          'eventDoc': serializeParam(
                        event.toMap(),
                        ParamType.JSON,
                      ),
                    }.withoutNulls,
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
