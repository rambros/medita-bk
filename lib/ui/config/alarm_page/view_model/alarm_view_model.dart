import 'package:flutter/material.dart';
import '/core/structs/index.dart';
import '/ui/core/flutter_flow/flutter_flow_theme.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import '/core/services/notification_service.dart';
import '/ui/core/flutter_flow/custom_functions.dart' as functions;

class AlarmViewModel extends ChangeNotifier {
  DateTime? datePicked;
  DateTime? timeSelected;

  Future<void> addAlarm(BuildContext context) async {
    final datePickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(getCurrentTimestamp),
    );

    if (datePickedTime != null) {
      datePicked = DateTime(
        getCurrentTimestamp.year,
        getCurrentTimestamp.month,
        getCurrentTimestamp.day,
        datePickedTime.hour,
        datePickedTime.minute,
      );
    } else if (datePicked != null) {
      datePicked = getCurrentTimestamp;
    }

    // set timeSelected with picker time
    timeSelected = datePicked;
    notifyListeners();

    if (datePicked == null) return;

    if (FFAppState().alarms.where((e) => e.showTime == functions.showTime(datePicked!)).toList().isNotEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Já existe lembrete para as ${functions.showTime(datePicked!)}!',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            duration: const Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).secondary,
          ),
        );
      }
    } else {
      FFAppState().addToAlarms(AlarmTimeStruct(
        key: timeSelected!.millisecondsSinceEpoch.hashCode,
        showTime: functions.showTime(datePicked!),
      ));
      notifyListeners();

      if (context.mounted) {
        final notificationService = NotificationService();
        await notificationService.scheduleAlarm(
          context,
          timeSelected!.millisecondsSinceEpoch.hashCode,
          timeSelected!,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Lembrete para as ${functions.showTime(datePicked!)}  inserido!',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            duration: const Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).secondary,
          ),
        );
      }
    }
  }

  Future<void> removeAlarm(BuildContext context, int index, AlarmTimeStruct alarmListItem) async {
    final notificationService = NotificationService();
    await notificationService.deleteAlarm(alarmListItem.key);
    FFAppState().removeAtIndexFromAlarms(index);
    notifyListeners();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lembrete para as ${alarmListItem.showTime} removido!',
            style: TextStyle(
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          duration: const Duration(milliseconds: 4000),
          backgroundColor: FlutterFlowTheme.of(context).secondary,
        ),
      );
    }
  }
}
