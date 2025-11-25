// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/ui/core/flutter_flow/flutter_flow_theme.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

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
}

class YearlyLog {
  int? year;
  int? totalTime;
  int? timerTime;
  int? medTime;
  int? sessions;
  int? medSession;
  int? timerSession;

  YearlyLog({
    this.year,
    this.totalTime,
    this.timerTime,
    this.medTime,
    this.sessions,
    this.medSession,
    this.timerSession,
  });
}

class YearlyStatisticsWidget extends StatefulWidget {
  const YearlyStatisticsWidget({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  _YearlyStatisticsWidgetState createState() => _YearlyStatisticsWidgetState();
}

class _YearlyStatisticsWidgetState extends State<YearlyStatisticsWidget> {
  List<MeditationLogStruct> listLogsFromRepository = FFAppState().meditationLogList;
  var numYears = 4;
  late List<YearlyLog?> listYearlyLog; // 12 months

  List<CartesianSeries<dynamic, dynamic>>? _seriesTimeListY;
  List<CartesianSeries<dynamic, dynamic>>? _seriesSessionsListY;

  var _totalTimeY = 0;
  var _totalTimeTimerY = 0;
  var _totalTimeMedY = 0;
  var _dailyAverageTimeY = 0;
  var _averageSessionTimeY = 0;
  int? _longestSessionY = 0;
  var _numberSessionsY = 0;
  var _numberTimerSessionsY = 0;
  var _numberMedSessionsY = 0;
  var _dailyAverageSessionsY = 0.0;
  int? _greaterNumDailySessionsY = 0;
  var _greaterSequenceOfDaysWithSessionY = 0;
  var _actualSequenceOfDaysWithSessionY = 0;

  String get totalTimeY => _roundTime(_totalTimeY);
  String get totalTimeTimerY => _roundTime(_totalTimeTimerY);
  String get totalTimeMedY => _roundTime(_totalTimeMedY);
  String get dailyAverageTimeY => _roundTime(_dailyAverageTimeY);
  String get averageSessionTimeY => _roundTime(_averageSessionTimeY);
  String get longestSessionY => _roundTime(_longestSessionY!);
  String get numberSessionsY => _numberSessionsY.toString();
  String get numberTimerSessionsY => _numberTimerSessionsY.toString();
  String get numberMedSessionsY => _numberMedSessionsY.toString();
  String get dailyAverageSessionsY => _dailyAverageSessionsY.toStringAsFixed(1);
  String get greaterNumDailySessionsY => _greaterNumDailySessionsY.toString();
  String get greaterSequenceOfDaysWithSessionY => _greaterSequenceOfDaysWithSessionY.toString();
  String get actualSequenceOfDaysWithSessionY => _actualSequenceOfDaysWithSessionY.toString();

  List<ChartSeries>? get seriesTimeListY => _seriesTimeListY;
  List<ChartSeries>? get seriesSessionsListY => _seriesSessionsListY;

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

  List<MeditationLogStruct> _getLastYears(List<MeditationLogStruct> logs) {
    var now = DateTime.now();
    var months = now.subtract(Duration(days: 365 * numYears));
    var tempLogs = logs.where((log) => log.date!.isAfter(months)).toList();
    return tempLogs;
  }

  String addZeros(int num) {
    if (num < 10) {
      return '0$num';
    } else {
      return num.toString();
    }
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  void _calculateStatisticsY(List<MeditationLogStruct> listLogs) {
    var daySessionTemp = 0;
    var monthSessionTemp = 0;
    var yearSessionTemp = 0;
    var numDaysWithSessionY = 0;

    if (listLogs.isEmpty) {
      return;
    }

    listLogs = _getLastYears(listLogs);

    // List to accumulate logs in years -> to display graphics
    var listYearlyLog = List.filled(numYears, YearlyLog());
    var year = DateTime.now().year;
    for (var i = 0; i < listYearlyLog.length; i++) {
      listYearlyLog[i] = YearlyLog(
        year: year--,
        totalTime: 0,
        timerTime: 0,
        medTime: 0,
        medSession: 0,
        timerSession: 0,
        sessions: 0,
      );
    }

    // temp List to accumulate logs in days to calculate sequences
    var listDays = List.filled(365 * numYears, DailyLog());
    for (var i = 0; i < listDays.length; i++) {
      listDays[i] = DailyLog(
        day: DateTime.now().subtract(Duration(days: i)),
        sessions: 0,
      );
    }

    for (var log in listLogs) {
      _totalTimeY = _totalTimeY + log.duration;

      if (log.type == 'timer') {
        _totalTimeTimerY = _totalTimeTimerY + log.duration;
        _numberTimerSessionsY++;
      } else {
        _totalTimeMedY = _totalTimeMedY + log.duration;
        _numberMedSessionsY++;
      }

      if (log.date!.year != yearSessionTemp || log.date!.month != monthSessionTemp || log.date!.day != daySessionTemp) {
        numDaysWithSessionY++;
        daySessionTemp = log.date!.day;
        monthSessionTemp = log.date!.month;
        yearSessionTemp = log.date!.year;
      }

      // insert values in the day that is in list -> search in day atribute
      var index = listYearlyLog.indexWhere((value) => (value.year == log.date!.year));

      listYearlyLog[index].totalTime = listYearlyLog[index].totalTime! + log.duration;
      listYearlyLog[index].medTime =
          log.type == 'guided' ? listYearlyLog[index].medTime! + log.duration : listYearlyLog[index].medTime;
      listYearlyLog[index].timerTime =
          log.type == 'timer' ? listYearlyLog[index].timerTime! + log.duration : listYearlyLog[index].timerTime;
      listYearlyLog[index].medSession =
          log.type == 'guided' ? listYearlyLog[index].medSession! + 1 : listYearlyLog[index].medSession;
      listYearlyLog[index].timerSession =
          log.type == 'timer' ? listYearlyLog[index].timerSession! + 1 : listYearlyLog[index].timerSession!;
      listYearlyLog[index].sessions = listYearlyLog[index].sessions! + 1;

      // insert values in the day that is in list -> search in day atribute
      var indexDay = listDays.indexWhere((value) =>
          value.day!.day == log.date!.day && value.day!.month == log.date!.month && value.day!.year == log.date!.year);
      listDays[indexDay].sessions = listDays[indexDay].sessions! + 1;
    }
    _numberSessionsY = listLogs.length;
    _averageSessionTimeY = _totalTimeY ~/ listLogs.length;
    _dailyAverageTimeY = _totalTimeY ~/ numDaysWithSessionY;
    _dailyAverageSessionsY = _numberSessionsY / numDaysWithSessionY;

    listLogs.sort((a, b) => b.duration.compareTo(a.duration));
    _longestSessionY = listLogs[0].duration;

    // calculate the sequences of days with sessions
    var numDay = 0;
    var isSequence = false;
    var daysInSequence = 0;
    var listSequences = [];
    var isSequenceActive = false;
    while (numDay < listDays.length) {
      if (listDays[numDay].sessions! > 0) {
        daysInSequence++;
        isSequence = true;
        if (listDays[numDay].day!.day == DateTime.now().day &&
            listDays[numDay].day!.month == DateTime.now().month &&
            listDays[numDay].day!.year == DateTime.now().year) {
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
      _actualSequenceOfDaysWithSessionY = listSequences[0] ?? 1;
    } else {
      _actualSequenceOfDaysWithSessionY = 0;
    }

    listSequences.sort((a, b) => b.compareTo(a));
    _greaterSequenceOfDaysWithSessionY = listSequences[0];

    var listTemp = List.from(listDays);
    listTemp.sort((a, b) => b.sessions.compareTo(a.sessions));
    _greaterNumDailySessionsY = listTemp[0].sessions;

    // reorganize for graphics in UI
    listYearlyLog.sort((a, b) => a.year!.compareTo(b.year!));

    _seriesTimeListY = [
      StackedColumnSeries<YearlyLog?, String>(
        name: 'Timer',
        dataSource: listYearlyLog,
        xValueMapper: (YearlyLog? log, _) => log!.year.toString(),
        yValueMapper: (YearlyLog? log, _) => log!.timerTime! ~/ 3600,
        dataLabelMapper: (YearlyLog? log, _) => (log!.timerTime! ~/ 3600).toString(),
        dataLabelSettings: DataLabelSettings(
            isVisible: false,
            showZeroValue: false,
            labelAlignment: ChartDataLabelAlignment.top,
            color: Colors.grey[400],
            textStyle: const TextStyle(fontSize: 10),
            showCumulativeValues: true),
      ),
      StackedColumnSeries<YearlyLog?, String>(
        name: 'Conduzida',
        dataSource: listYearlyLog,
        xValueMapper: (YearlyLog? log, _) => log!.year.toString(),
        yValueMapper: (YearlyLog? log, _) => log!.medTime! ~/ 3600,
        dataLabelMapper: (YearlyLog? log, _) => (log!.medTime! ~/ 3600).toString(),
        dataLabelSettings: DataLabelSettings(
            isVisible: false,
            showZeroValue: false,
            labelAlignment: ChartDataLabelAlignment.top,
            color: Colors.grey[400],
            textStyle: const TextStyle(fontSize: 10),
            showCumulativeValues: true),
      ),
    ];

    //_seriesSessionsListM = List<ChartSeries<MonthlyLog, String>>();
    _seriesSessionsListY = [
      StackedColumnSeries<YearlyLog?, String>(
        name: 'Timer',
        dataSource: listYearlyLog,
        xValueMapper: (YearlyLog? log, _) => log!.year.toString(),
        yValueMapper: (YearlyLog? log, _) => log!.timerSession,
        dataLabelMapper: (YearlyLog? log, _) => (log!.timerSession).toString(),
        dataLabelSettings: DataLabelSettings(
            isVisible: false,
            showZeroValue: false,
            labelAlignment: ChartDataLabelAlignment.top,
            color: Colors.grey[400],
            textStyle: const TextStyle(fontSize: 10),
            showCumulativeValues: true),
      ),
      StackedColumnSeries<YearlyLog?, String>(
        name: 'Conduzida',
        dataSource: listYearlyLog,
        xValueMapper: (YearlyLog? log, _) => log!.year.toString(),
        yValueMapper: (YearlyLog? log, _) => log!.medSession,
        dataLabelMapper: (YearlyLog? log, _) => (log!.medSession).toString(),
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
    _seriesTimeListY ?? _calculateStatisticsY(listLogsFromRepository);
    return SingleChildScrollView(
      child: Container(
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Últimos anos',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              _seriesTimeListY != null
                  ? Center(
                      child: SizedBox(
                          height: 250,
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: ExcludeSemantics(
                            child: SfCartesianChart(
                              series: _seriesTimeListY!,
                              primaryYAxis: const NumericAxis(
                                labelFormat: '{value}',
                                isVisible: true,
                              ),
                              primaryXAxis: const CategoryAxis(
                                interval: 1,
                                majorGridLines: MajorGridLines(width: 0),
                                title: AxisTitle(
                                  text: 'ano',
                                ),
                                labelRotation: 315,
                              ),
                              plotAreaBackgroundColor: Colors.grey[100],
                              title: const ChartTitle(
                                text: 'Tempo por ano (minutos)',
                                textStyle: TextStyle(fontSize: 16),
                              ),
                              tooltipBehavior: TooltipBehavior(enable: true),
                            ),
                          )),
                    )
                  : const SizedBox(height: 6),
              _seriesSessionsListY != null
                  ? Center(
                      child: SizedBox(
                          height: 250,
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: ExcludeSemantics(
                            child: SfCartesianChart(
                              series: _seriesSessionsListY!,
                              primaryYAxis: const NumericAxis(
                                labelFormat: '{value}',
                                isVisible: true,
                              ),
                              primaryXAxis: const CategoryAxis(
                                interval: 1,
                                majorGridLines: MajorGridLines(width: 0),
                                title: AxisTitle(
                                  text: 'ano',
                                ),
                                labelRotation: 315,
                              ),
                              plotAreaBackgroundColor: Colors.grey[100],
                              title: const ChartTitle(
                                text: 'Sessões por ano',
                                textStyle: TextStyle(fontSize: 16),
                              ),
                              tooltipBehavior: TooltipBehavior(enable: true),
                            ),
                          )),
                    )
                  : const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sequencias contínuas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    _showLine(title: 'Dias consecutivos - atual', value: actualSequenceOfDaysWithSessionY),
                    _showLine(title: 'Maior sequencia de dias consecutivos', value: greaterSequenceOfDaysWithSessionY),
                    const SizedBox(height: 24),
                    const Text('Tempo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    _showLine(title: 'Total', value: totalTimeY),
                    _showLine(title: 'Timer', value: totalTimeTimerY),
                    _showLine(title: 'Meditação conduzida', value: totalTimeMedY),
                    _showLine(title: 'Média diária', value: dailyAverageTimeY),
                    _showLine(title: 'Duração média', value: averageSessionTimeY),
                    _showLine(title: 'Sessão mais longa', value: longestSessionY),
                    const SizedBox(height: 24),
                    const Text('Sessões', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    _showLine(title: 'Total', value: numberSessionsY),
                    _showLine(title: 'Timer', value: numberTimerSessionsY),
                    _showLine(title: 'Meditação conduzida', value: numberMedSessionsY),
                    _showLine(title: 'Frequencia diária', value: dailyAverageSessionsY),
                    _showLine(title: 'Maior número em único dia', value: greaterNumDailySessionsY),
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
