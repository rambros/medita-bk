// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom widgets

import 'index.dart'; // Imports other custom widgets

import 'package:syncfusion_flutter_charts/charts.dart';

class DailyLog {
  DateTime? day;
  int? totalTime;
  int? timerTime;
  int? medTime;
  int? medSession;
  int? timerSession;
  int? sessions;

  DailyLog({
    this.day,
    this.totalTime,
    this.timerTime,
    this.medTime,
    this.medSession,
    this.timerSession,
    this.sessions,
  });

  int? compareTo(other) {
    if (day == null || other == null) {
      return null;
    }
    if (day!.isBefore(other.day)) {
      return 1;
    }

    if (day!.isAfter(other.day)) {
      return -1;
    }

    if ((day!.day == other.day) &&
        (day!.month == other.month) &&
        (day!.year == other.year)) {
      return 0;
    }

    return null;
  }
}

class DailyStatisticsWidget extends StatefulWidget {
  const DailyStatisticsWidget({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  _DailyStatisticsWidgetState createState() => _DailyStatisticsWidgetState();
}

class _DailyStatisticsWidgetState extends State<DailyStatisticsWidget> {
  List<MeditationLogStruct> listLogsFromRepository =
      FFAppState().meditationLogList;
  List<DailyLog?> listDailyLog = List.filled(14, DailyLog()); // 14 days

  List<CartesianSeries<dynamic, dynamic>>? _seriesTimeListD;
  List<CartesianSeries<dynamic, dynamic>>? _seriesSessionsListD;

  var _totalTimeD = 0;
  var _totalTimeTimerD = 0;
  var _totalTimeMedD = 0;
  var _dailyAverageTimeD = 0;
  var _averageSessionTimeD = 0;
  int? _longestSessionD = 0;
  var _numberSessionsD = 0;
  var _numberTimerSessionsD = 0;
  var _numberMedSessionsD = 0;
  var _dailyAverageSessionsD = 0.0;
  int? _greaterNumDailySessionsD = 0;
  var _greaterSequenceOfDaysWithSessionD = 0;
  var _actualSequenceOfDaysWithSessionD = 0;

  String get totalTimeD => _roundTime(_totalTimeD);
  String get totalTimeTimerD => _roundTime(_totalTimeTimerD);
  String get totalTimeMedD => _roundTime(_totalTimeMedD);
  String get dailyAverageTimeD => _roundTime(_dailyAverageTimeD);
  String get averageSessionTimeD => _roundTime(_averageSessionTimeD);
  String get longestSessionD => _roundTime(_longestSessionD!);
  String get numberSessionsD => _numberSessionsD.toString();
  String get numberTimerSessionsD => _numberTimerSessionsD.toString();
  String get numberMedSessionsD => _numberMedSessionsD.toString();
  String get dailyAverageSessionsD => _dailyAverageSessionsD.toStringAsFixed(1);
  String get greaterNumDailySessionsD => _greaterNumDailySessionsD.toString();
  String get greaterSequenceOfDaysWithSessionD =>
      _greaterSequenceOfDaysWithSessionD.toString();
  String get actualSequenceOfDaysWithSessionD =>
      _actualSequenceOfDaysWithSessionD.toString();

  String _roundTime(int time) {
    var duration = Duration(seconds: time);
    var hour = duration.inHours;
    num remainderMinutes = duration.inMinutes.remainder(60);
    num remainderSeconds = duration.inSeconds.remainder(60);
    var strHour = hour > 0 ? '${hour}h ' : '';
    var strMinutes = remainderMinutes > 0 ? '${remainderMinutes}min ' : '';
    var strSeconds = remainderSeconds > 0 ? '${remainderSeconds}s ' : '0s';
    return strHour + strMinutes + strSeconds;
  }

  List<MeditationLogStruct> _getLastDays(List<MeditationLogStruct> logs) {
    var now = DateTime.now();
    var days =
        now.subtract(const Duration(days: 13, hours: 0)); // [0..13] = 14 dias
    var tempLogs = logs.where((log) => log.date!.isAfter(days)).toList();
    return tempLogs;
  }

  void _calculateStatisticsD(List<MeditationLogStruct> listLogs) {
    var daySessionTemp = 0;
    var monthSessionTemp = 0;
    var yearSessionTemp = 0;
    var numDaysWithSession = 0;

    if (listLogs.isEmpty) {
      return;
    }

    listLogs = _getLastDays(listLogs);

    for (var i = 0; i < listDailyLog.length; i++) {
      listDailyLog[i] = DailyLog(
        day: DateTime.now().subtract(Duration(days: i)),
        totalTime: 0,
        timerTime: 0,
        medTime: 0,
        sessions: 0,
        medSession: 0,
        timerSession: 0,
      );
    }

    for (var log in listLogs) {
      _totalTimeD = _totalTimeD + log.duration;

      if (log.type == 'timer') {
        _totalTimeTimerD = _totalTimeTimerD + log.duration;
        _numberTimerSessionsD++;
      } else {
        _totalTimeMedD = _totalTimeMedD + log.duration;
        _numberMedSessionsD++;
      }

      if (log.date!.year != yearSessionTemp ||
          log.date!.month != monthSessionTemp ||
          log.date!.day != daySessionTemp) {
        numDaysWithSession++;
        daySessionTemp = log.date!.day;
        monthSessionTemp = log.date!.month;
        yearSessionTemp = log.date!.year;
      }

      // insert values in the day that is in list -> search in day atribute
      var index = listDailyLog.indexWhere((value) =>
          value!.day!.day == log.date!.day &&
          value.day!.month == log.date!.month &&
          value.day!.year == log.date!.year);

      listDailyLog[index]!.totalTime =
          listDailyLog[index]!.totalTime! + log.duration;
      listDailyLog[index]!.medTime = log.type == 'guided'
          ? listDailyLog[index]!.medTime! + log.duration
          : listDailyLog[index]!.medTime;
      listDailyLog[index]!.timerTime = log.type == 'timer'
          ? listDailyLog[index]!.timerTime! + log.duration
          : listDailyLog[index]!.timerTime;
      listDailyLog[index]!.medSession = log.type == 'guided'
          ? listDailyLog[index]!.medSession! + 1
          : listDailyLog[index]!.medSession;
      listDailyLog[index]!.timerSession = log.type == 'timer'
          ? listDailyLog[index]!.timerSession! + 1
          : listDailyLog[index]!.timerSession!;
      listDailyLog[index]!.sessions = listDailyLog[index]!.sessions! + 1;
    }
    _numberSessionsD = listLogs.length;
    if (_numberSessionsD > 0) {
      _averageSessionTimeD = _totalTimeD ~/ _numberSessionsD;
      _dailyAverageTimeD =
          numDaysWithSession == 0 ? 0 : _totalTimeD ~/ numDaysWithSession;
      _dailyAverageSessionsD =
          numDaysWithSession == 0 ? 0 : _numberSessionsD / numDaysWithSession;

      listLogs.sort((a, b) => b.duration.compareTo(a.duration));
      _longestSessionD = listLogs[0].duration;
    }

    // calculate the sequences of days with sessions
    var numDay = 0;
    var isSequence = false;
    var daysInSequence = 0;
    var listSequences = [];
    var isSequenceActive = false;
    while (numDay < listDailyLog.length) {
      if (listDailyLog[numDay]!.sessions! > 0) {
        daysInSequence++;
        isSequence = true;
        if (listDailyLog[numDay]!.day!.day == DateTime.now().day &&
            listDailyLog[numDay]!.day!.month == DateTime.now().month &&
            listDailyLog[numDay]!.day!.year == DateTime.now().year) {
          isSequenceActive = true;
        }
      } else {
        if (isSequence) {
          listSequences.add(daysInSequence);
        }
        daysInSequence = 0;
        isSequence = false;
      }
      numDay++;
    }

    if (isSequenceActive) {
      _actualSequenceOfDaysWithSessionD = listSequences[0] ?? 1;
    } else {
      _actualSequenceOfDaysWithSessionD = 0;
    }

    listSequences.sort((a, b) => b.compareTo(a));
    _greaterSequenceOfDaysWithSessionD =
        listSequences.isNotEmpty ? listSequences[0] : 0;

    var listTempTest = List.from(listDailyLog);

    listTempTest.sort((a, b) => b.sessions.compareTo(a.sessions));
    _greaterNumDailySessionsD = listTempTest[0].sessions;

    // reorganize for graphics in UI
    //listyLog.sort((a,b) => b.compareTo(a));

    //_seriesTimeListD = List<ChartSeries<DailyLog, DateTime>>();
    //_seriesTimeListD = <ChartSeries<DailyLog?, DateTime>>[
    _seriesTimeListD = [
      StackedColumnSeries<DailyLog?, DateTime>(
        name: 'Timer',
        dataSource: listDailyLog,
        xValueMapper: (DailyLog? log, _) => log!.day,
        yValueMapper: (DailyLog? log, _) => log!.timerTime! ~/ 60,
        dataLabelMapper: (DailyLog? log, _) =>
            (log!.totalTime! ~/ 60).toString(),
        dataLabelSettings: DataLabelSettings(
            isVisible: false,
            showZeroValue: false,
            labelAlignment: ChartDataLabelAlignment.top,
            color: Colors.grey[400],
            textStyle: const TextStyle(fontSize: 10),
            showCumulativeValues: true),
      ),
      StackedColumnSeries<DailyLog?, DateTime>(
        name: 'Conduzida',
        dataSource: listDailyLog,
        xValueMapper: (DailyLog? log, _) => log!.day,
        yValueMapper: (DailyLog? log, _) => log!.medTime! ~/ 60,
        dataLabelMapper: (DailyLog? log, _) =>
            (log!.totalTime! ~/ 60).toString(),
        dataLabelSettings: DataLabelSettings(
            isVisible: false,
            showZeroValue: false,
            labelAlignment: ChartDataLabelAlignment.top,
            color: Colors.grey[400],
            textStyle: const TextStyle(fontSize: 10),
            showCumulativeValues: true),
      ),
    ];

    //_seriesSessionsListD = List<ChartSeries<DailyLog, DateTime>>();
    //_seriesSessionsListD = <ChartSeries<DailyLog?, DateTime>>[
    _seriesSessionsListD = [
      StackedColumnSeries<DailyLog?, DateTime>(
        name: 'Timer',
        dataSource: listDailyLog,
        xValueMapper: (DailyLog? log, _) => log!.day,
        yValueMapper: (DailyLog? log, _) => log!.timerSession,
        dataLabelMapper: (DailyLog? log, _) => log!.timerSession.toString(),
        dataLabelSettings: DataLabelSettings(
            isVisible: false,
            showZeroValue: false,
            labelAlignment: ChartDataLabelAlignment.top,
            color: Colors.grey[400],
            textStyle: const TextStyle(fontSize: 10),
            showCumulativeValues: true),
      ),
      StackedColumnSeries<DailyLog?, DateTime>(
        name: 'Conduzida',
        dataSource: listDailyLog,
        xValueMapper: (DailyLog? log, _) => log!.day,
        yValueMapper: (DailyLog? log, _) => log!.medSession,
        dataLabelMapper: (DailyLog? log, _) => (log!.medSession).toString(),
        dataLabelSettings: DataLabelSettings(
            isVisible: false,
            showZeroValue: false,
            labelAlignment: ChartDataLabelAlignment.top,
            color: Colors.grey[400],
            textStyle: const TextStyle(fontSize: 10),
            showCumulativeValues: true),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    _seriesTimeListD ?? _calculateStatisticsD(listLogsFromRepository);
    return SingleChildScrollView(
      child: Container(
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Últimos 14 dias',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              _seriesTimeListD != null
                  ? Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ExcludeSemantics(
                          child: SizedBox(
                              height: 250,
                              width: MediaQuery.of(context).size.width * 0.95,
                              child: SfCartesianChart(
                                series: _seriesTimeListD!,
                                primaryYAxis: const NumericAxis(
                                  labelFormat: '{value}',
                                  isVisible: true,
                                ),
                                primaryXAxis: DateTimeAxis(
                                  dateFormat: DateFormat.d(),
                                  intervalType: DateTimeIntervalType.days,
                                  interval: 1,
                                  majorGridLines:
                                      const MajorGridLines(width: 0),
                                  title: const AxisTitle(
                                    text: 'dia do mês',
                                  ),
                                ),
                                plotAreaBackgroundColor: Colors.grey[100],
                                title: const ChartTitle(
                                  text: 'Tempo por dia (minutos)',
                                  textStyle: TextStyle(fontSize: 16),
                                ),
                                legend: const Legend(
                                  isVisible: false,
                                  title: LegendTitle(text: 'timer'),
                                ),
                                tooltipBehavior: TooltipBehavior(enable: true),
                              )),
                        ),
                      ),
                    )
                  : const SizedBox(height: 6),
              _seriesSessionsListD != null
                  ? Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ExcludeSemantics(
                          child: SizedBox(
                              height: 250,
                              width: MediaQuery.of(context).size.width * 0.95,
                              child: SfCartesianChart(
                                series: _seriesSessionsListD!,
                                primaryYAxis: const NumericAxis(
                                  labelFormat: '{value}',
                                  isVisible: true,
                                ),
                                primaryXAxis: DateTimeAxis(
                                  dateFormat: DateFormat.d(),
                                  intervalType: DateTimeIntervalType.days,
                                  interval: 1,
                                  majorGridLines:
                                      const MajorGridLines(width: 0),
                                  title: const AxisTitle(
                                    text: 'dia do mês',
                                  ),
                                ),
                                plotAreaBackgroundColor: Colors.grey[100],
                                title: const ChartTitle(
                                  text: 'Sessões por dia',
                                  textStyle: TextStyle(fontSize: 16),
                                ),
                                legend: const Legend(
                                  isVisible: false,
                                  title: LegendTitle(text: 'timer'),
                                ),
                                tooltipBehavior: TooltipBehavior(enable: true),
                              )),
                        ),
                      ),
                    )
                  : const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sequencia contínuas',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    _showLine(
                        title: 'Dias consecutivos - atual',
                        value: actualSequenceOfDaysWithSessionD),
                    _showLine(
                        title: 'Maior sequencia de dias consecutivos',
                        value: greaterSequenceOfDaysWithSessionD),
                    const SizedBox(height: 24),
                    const Text('Tempo',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    _showLine(title: 'Total', value: totalTimeD),
                    _showLine(title: 'Timer', value: totalTimeTimerD),
                    _showLine(
                        title: 'Meditação conduzida', value: totalTimeMedD),
                    _showLine(title: 'Média diária', value: dailyAverageTimeD),
                    _showLine(
                        title: 'Duração média', value: averageSessionTimeD),
                    _showLine(
                        title: 'Sessão mais longa', value: longestSessionD),
                    const SizedBox(height: 24),
                    const Text('Sessões',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    _showLine(title: 'Total', value: numberSessionsD),
                    _showLine(title: 'Timer', value: numberTimerSessionsD),
                    _showLine(
                        title: 'Meditação conduzida',
                        value: numberMedSessionsD),
                    _showLine(
                        title: 'Frequencia diária',
                        value: dailyAverageSessionsD),
                    _showLine(
                        title: 'Maior número em único dia',
                        value: greaterNumDailySessionsD),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _showLine({
    required String title,
    required String value,
  }) {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 8, 4, 8),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title),
                Text(value),
              ],
            ),
            const SizedBox(height: 4),
            const Divider(height: 1, thickness: 0.5, color: Colors.black26),
          ],
        ));
  }
}
