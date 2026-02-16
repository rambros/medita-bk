// Automatic FlutterFlow imports
import 'package:medita_bk/core/structs/index.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
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

class WeeklyLog {
  DateTime? week;
  int? totalTime;
  int? timerTime;
  int? medTime;
  int? sessions;
  int? medSession;
  int? timerSession;

  WeeklyLog({
    this.week,
    this.totalTime,
    this.timerTime,
    this.medTime,
    this.sessions,
    this.medSession,
    this.timerSession,
  });
}

class WeeklyStatisticsWidget extends StatefulWidget {
  const WeeklyStatisticsWidget({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  _WeeklyStatisticsWidgetState createState() => _WeeklyStatisticsWidgetState();
}

class _WeeklyStatisticsWidgetState extends State<WeeklyStatisticsWidget> {
  List<MeditationLogStruct> listLogsFromRepository = AppStateStore().meditationLogList;
  List<WeeklyLog?> listWeeklyLog = List.filled(12, WeeklyLog()); // 12 weeks

  List<CartesianSeries<dynamic, dynamic>>? _seriesTimeListW;
  List<CartesianSeries<dynamic, dynamic>>? _seriesSessionsListW;

  var _totalTimeW = 0;
  var _totalTimeTimerW = 0;
  var _totalTimeMedW = 0;
  var _dailyAverageTimeW = 0;
  var _averageSessionTimeW = 0;
  int? _longestSessionW = 0;
  var _numberSessionsW = 0;
  var _numberTimerSessionsW = 0;
  var _numberMedSessionsW = 0;
  var _dailyAverageSessionsW = 0.0;
  int? _greaterNumDailySessionsW = 0;
  var _greaterSequenceOfDaysWithSessionW = 0;
  var _actualSequenceOfDaysWithSessionW = 0;

  String get totalTimeW => _roundTime(_totalTimeW);
  String get totalTimeTimerW => _roundTime(_totalTimeTimerW);
  String get totalTimeMedW => _roundTime(_totalTimeMedW);
  String get dailyAverageTimeW => _roundTime(_dailyAverageTimeW);
  String get averageSessionTimeW => _roundTime(_averageSessionTimeW);
  String get longestSessionW => _roundTime(_longestSessionW!);
  String get numberSessionsW => _numberSessionsW.toString();
  String get numberTimerSessionsW => _numberTimerSessionsW.toString();
  String get numberMedSessionsW => _numberMedSessionsW.toString();
  String get dailyAverageSessionsW => _dailyAverageSessionsW.toStringAsFixed(1);
  String get greaterNumDailySessionsW => _greaterNumDailySessionsW.toString();
  String get greaterSequenceOfDaysWithSessionW => _greaterSequenceOfDaysWithSessionW.toString();
  String get actualSequenceOfDaysWithSessionW => _actualSequenceOfDaysWithSessionW.toString();

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

  /// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
  int weekNumber(DateTime date) {
    var dayOfYear = int.parse(DateFormat('D').format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  List<MeditationLogStruct> _getLastWeeks(List<MeditationLogStruct> logs) {
    var now = DateTime.now();
    var weeks = now.subtract(const Duration(days: (7 * 11))); //[0..11] == 12 weeks
    var tempLogs = logs.where((log) => log.date!.isAfter(weeks)).toList();
    return tempLogs;
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  void _calculateStatisticsW(List<MeditationLogStruct> listLogs) {
    var daySessionTemp = 0;
    var monthSessionTemp = 0;
    var yearSessionTemp = 0;
    var numDaysWithSessionW = 0;

    if (listLogs.isEmpty) {
      return;
    }

    listLogs = _getLastWeeks(listLogs);

    // Verificar novamente após filtrar - pode não haver logs nas últimas 12 semanas
    if (listLogs.isEmpty) {
      return;
    }

    //var _endOfWeek = getDate(date.add(Duration(days: DateTime.daysPerWeek - date.weekday)));
    // List to accumulate logs in weeks -> to display graphics
    var date = DateTime.now();
    var startOfWeek = getDate(date.subtract(Duration(days: date.weekday - 1)));
    for (var i = 0; i < listWeeklyLog.length; i++) {
      listWeeklyLog[i] = WeeklyLog(
        week: startOfWeek,
        totalTime: 0,
        timerTime: 0,
        medTime: 0,
        medSession: 0,
        timerSession: 0,
        sessions: 0,
      );
      startOfWeek = startOfWeek.subtract(const Duration(days: 7));
    }

    // temp List to accumulate logs in days to calculate sequences
    var listDays = List.filled((7 * 12), DailyLog());
    for (var i = 0; i < listDays.length; i++) {
      listDays[i] = DailyLog(
        day: DateTime.now().subtract(Duration(days: i)),
        sessions: 0,
      );
    }

    for (var log in listLogs) {
      _totalTimeW = _totalTimeW + log.duration;

      if (log.type == 'timer') {
        _totalTimeTimerW = _totalTimeTimerW + log.duration;
        _numberTimerSessionsW++;
      } else {
        _totalTimeMedW = _totalTimeMedW + log.duration;
        _numberMedSessionsW++;
      }

      if (log.date!.year != yearSessionTemp || log.date!.month != monthSessionTemp || log.date!.day != daySessionTemp) {
        numDaysWithSessionW++;
        daySessionTemp = log.date!.day;
        monthSessionTemp = log.date!.month;
        yearSessionTemp = log.date!.year;
      }

      // insert values in the day that is in list -> search in day atribute
      var index = listWeeklyLog
          .indexWhere((value) => (value!.week == getDate(log.date!.subtract(Duration(days: log.date!.weekday - 1)))));

      if (index >= 0) {
        listWeeklyLog[index]!.totalTime = listWeeklyLog[index]!.totalTime! + log.duration;
        listWeeklyLog[index]!.medTime =
            log.type == 'guided' ? listWeeklyLog[index]!.medTime! + log.duration : listWeeklyLog[index]!.medTime;
        listWeeklyLog[index]!.timerTime =
            log.type == 'timer' ? listWeeklyLog[index]!.timerTime! + log.duration : listWeeklyLog[index]!.timerTime;
        listWeeklyLog[index]!.medSession =
            log.type == 'guided' ? listWeeklyLog[index]!.medSession! + 1 : listWeeklyLog[index]!.medSession;
        listWeeklyLog[index]!.timerSession =
            log.type == 'timer' ? listWeeklyLog[index]!.timerSession! + 1 : listWeeklyLog[index]!.timerSession!;
        listWeeklyLog[index]!.sessions = listWeeklyLog[index]!.sessions! + 1;
      }

      // insert values in the day that is in list -> search in day atribute
      var indexDay = listDays.indexWhere((value) =>
          value.day!.day == log.date!.day && value.day!.month == log.date!.month && value.day!.year == log.date!.year);
      if (indexDay >= 0) {
        listDays[indexDay].sessions = listDays[indexDay].sessions! + 1;
      }
    }
    _numberSessionsW = listLogs.length;
    if (_numberSessionsW > 0) {
      _averageSessionTimeW = _totalTimeW ~/ listLogs.length;
      _dailyAverageTimeW = _totalTimeW ~/ numDaysWithSessionW;
      _dailyAverageSessionsW = _numberSessionsW / numDaysWithSessionW;

      listLogs.sort((a, b) => b.duration.compareTo(a.duration));
      _longestSessionW = listLogs[0].duration;
    }

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
      _actualSequenceOfDaysWithSessionW = listSequences[0] ?? 1;
    } else {
      _actualSequenceOfDaysWithSessionW = 0;
    }

    listSequences.sort((a, b) => b.compareTo(a));
    _greaterSequenceOfDaysWithSessionW = listSequences.isNotEmpty ? listSequences[0] : 0;

    var listTemp = List.from(listDays);
    listTemp.sort((a, b) => b.sessions.compareTo(a.sessions));
    _greaterNumDailySessionsW = listTemp.isNotEmpty ? listTemp[0].sessions : 0;

    // reorganize for graphics in UI
    listWeeklyLog.sort((a, b) => a!.week!.compareTo(b!.week!));

    //_seriesTimeListM = List<ChartSeries<MonthlyLog, String>>();
    //_seriesTimeListW = <ChartSeries<WeeklyLog?, String>>[
    _seriesTimeListW = [
      StackedColumnSeries<WeeklyLog?, String>(
        name: 'Timer',
        dataSource: listWeeklyLog,
        xValueMapper: (WeeklyLog? log, _) => '${log!.week!.day}/${log.week!.month}',
        yValueMapper: (WeeklyLog? log, _) => log!.timerTime! ~/ 60,
        dataLabelMapper: (WeeklyLog? log, _) => (log!.timerTime! ~/ 60).toString(),
        dataLabelSettings: DataLabelSettings(
            isVisible: false,
            showZeroValue: false,
            labelAlignment: ChartDataLabelAlignment.top,
            color: Colors.grey[400],
            textStyle: const TextStyle(fontSize: 10),
            showCumulativeValues: true),
      ),
      StackedColumnSeries<WeeklyLog?, String>(
        name: 'Conduzida',
        dataSource: listWeeklyLog,
        xValueMapper: (WeeklyLog? log, _) => '${log!.week!.day}/${log.week!.month}',
        yValueMapper: (WeeklyLog? log, _) => log!.medTime! ~/ 60,
        dataLabelMapper: (WeeklyLog? log, _) => (log!.medTime! ~/ 60).toString(),
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
    //_seriesSessionsListW = <ChartSeries<WeeklyLog?, String>>[
    _seriesSessionsListW = [
      StackedColumnSeries<WeeklyLog?, String>(
        name: 'Timer',
        dataSource: listWeeklyLog,
        xValueMapper: (WeeklyLog? log, _) => '${log!.week!.day}/${log.week!.month}',
        yValueMapper: (WeeklyLog? log, _) => log!.timerSession,
        dataLabelMapper: (WeeklyLog? log, _) => (log!.timerSession).toString(),
        dataLabelSettings: DataLabelSettings(
            isVisible: false,
            showZeroValue: false,
            labelAlignment: ChartDataLabelAlignment.top,
            color: Colors.grey[400],
            textStyle: const TextStyle(fontSize: 10),
            showCumulativeValues: true),
      ),
      StackedColumnSeries<WeeklyLog?, String>(
        name: 'Conduzida',
        dataSource: listWeeklyLog,
        xValueMapper: (WeeklyLog? log, _) => '${log!.week!.day}/${log.week!.month}',
        yValueMapper: (WeeklyLog? log, _) => log!.medSession,
        dataLabelMapper: (WeeklyLog? log, _) => (log!.medSession).toString(),
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
    _seriesTimeListW ?? _calculateStatisticsW(listLogsFromRepository);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Center(
              child: Padding(
                padding: EdgeInsets.all(6.0),
                child: Text(
                  'Últimas 12 semanas',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            _seriesTimeListW != null
                ? Center(
                    child: SizedBox(
                        height: 250,
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: ExcludeSemantics(
                          child: SfCartesianChart(
                            series: _seriesTimeListW!,
                            primaryYAxis: const NumericAxis(
                              labelFormat: '{value}',
                              isVisible: true,
                            ),
                            primaryXAxis: const CategoryAxis(
                              interval: 1,
                              majorGridLines: MajorGridLines(width: 0),
                              title: AxisTitle(
                                text: 'semana',
                              ),
                              labelRotation: 315,
                            ),
                            plotAreaBackgroundColor: Colors.grey[100],
                            title: const ChartTitle(
                              text: 'Tempo por semana (minutos)',
                              textStyle: TextStyle(fontSize: 16),
                            ),
                            tooltipBehavior: TooltipBehavior(enable: true),
                          ),
                        )),
                  )
                : const SizedBox(height: 6),
            _seriesSessionsListW != null
                ? Center(
                    child: SizedBox(
                        height: 250,
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: ExcludeSemantics(
                          child: SfCartesianChart(
                            series: _seriesSessionsListW!,
                            primaryYAxis: const NumericAxis(
                              labelFormat: '{value}',
                              isVisible: true,
                            ),
                            primaryXAxis: const CategoryAxis(
                              interval: 1,
                              majorGridLines: MajorGridLines(width: 0),
                              title: AxisTitle(
                                text: 'semana',
                              ),
                              labelRotation: 315,
                            ),
                            plotAreaBackgroundColor: Colors.grey[100],
                            title: const ChartTitle(
                              text: 'Sessões por semana',
                              textStyle: TextStyle(fontSize: 16),
                            ),
                            // Enable legend
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
                  _showLine(title: 'Dias consecutivos - atual', value: actualSequenceOfDaysWithSessionW),
                  _showLine(title: 'Maior sequencia de dias consecutivos', value: greaterSequenceOfDaysWithSessionW),
                  const SizedBox(height: 24),
                  const Text('Tempo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  _showLine(title: 'Total', value: totalTimeW),
                  _showLine(title: 'Timer', value: totalTimeTimerW),
                  _showLine(title: 'Meditação conduzida', value: totalTimeMedW),
                  _showLine(title: 'Média diária', value: dailyAverageTimeW),
                  _showLine(title: 'Duração média', value: averageSessionTimeW),
                  _showLine(title: 'Sessão de duração mais longa', value: longestSessionW),
                  const SizedBox(height: 24),
                  const Text('Sessões', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  _showLine(title: 'Total', value: numberSessionsW),
                  _showLine(title: 'Timer', value: numberTimerSessionsW),
                  _showLine(title: 'Meditação conduzida', value: numberMedSessionsW),
                  _showLine(title: 'Frequencia diária', value: dailyAverageSessionsW),
                  _showLine(title: 'Maior número em único dia', value: greaterNumDailySessionsW),
                ],
              ),
            )
          ],
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
            const SizedBox(
              height: 4,
            ),
            const Divider(height: 1, thickness: 0.5, color: Colors.black26),
          ],
        ));
  }
}
