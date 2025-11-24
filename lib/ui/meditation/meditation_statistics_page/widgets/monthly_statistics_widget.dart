// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
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

class MonthlyLog {
  String? month;
  int? totalTime;
  int? timerTime;
  int? medTime;
  int? sessions;
  int? medSession;
  int? timerSession;

  MonthlyLog({
    this.month,
    this.totalTime,
    this.timerTime,
    this.medTime,
    this.sessions,
    this.medSession,
    this.timerSession,
  });
}

class MonthlyStatisticsWidget extends StatefulWidget {
  const MonthlyStatisticsWidget({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  _MonthlyStatisticsWidgetState createState() => _MonthlyStatisticsWidgetState();
}

class _MonthlyStatisticsWidgetState extends State<MonthlyStatisticsWidget> {
  List<MeditationLogStruct> listLogsFromRepository = FFAppState().meditationLogList;
  List<MonthlyLog?> listMonthlyLog = List.filled(12, MonthlyLog()); // 12 months

  List<CartesianSeries<dynamic, dynamic>>? _seriesTimeListM;
  List<CartesianSeries<dynamic, dynamic>>? _seriesSessionsListM;

  var _totalTimeM = 0;
  var _totalTimeTimerM = 0;
  var _totalTimeMedM = 0;
  var _dailyAverageTimeM = 0;
  var _averageSessionTimeM = 0;
  int? _longestSessionM = 0;
  var _numberSessionsM = 0;
  var _numberTimerSessionsM = 0;
  var _numberMedSessionsM = 0;
  var _dailyAverageSessionsM = 0.0;
  int? _greaterNumDailySessionsM = 0;
  var _greaterSequenceOfDaysWithSessionM = 0;
  var _actualSequenceOfDaysWithSessionM = 0;

  String get totalTimeM => _roundTime(_totalTimeM);
  String get totalTimeTimerM => _roundTime(_totalTimeTimerM);
  String get totalTimeMedM => _roundTime(_totalTimeMedM);
  String get dailyAverageTimeM => _roundTime(_dailyAverageTimeM);
  String get averageSessionTimeM => _roundTime(_averageSessionTimeM);
  String get longestSessionM => _roundTime(_longestSessionM!);
  String get numberSessionsM => _numberSessionsM.toString();
  String get numberTimerSessionsM => _numberTimerSessionsM.toString();
  String get numberMedSessionsM => _numberMedSessionsM.toString();
  String get dailyAverageSessionsM => _dailyAverageSessionsM.toStringAsFixed(1);
  String get greaterNumDailySessionsM => _greaterNumDailySessionsM.toString();
  String get greaterSequenceOfDaysWithSessionM => _greaterSequenceOfDaysWithSessionM.toString();
  String get actualSequenceOfDaysWithSessionM => _actualSequenceOfDaysWithSessionM.toString();

  List<ChartSeries>? get seriesTimeListM => _seriesTimeListM;
  List<ChartSeries>? get seriesSessionsListM => _seriesSessionsListM;

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

  List<MeditationLogStruct> _getLastMonths(List<MeditationLogStruct> logs) {
    var now = DateTime.now();
    var Months = now.subtract(const Duration(days: 365 - 1)); //[0..364] = 12 meses
    var tempLogs = logs.where((log) => log.date!.isAfter(Months)).toList();
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

  void _calculateStatisticsM(List<MeditationLogStruct> listLogs) {
    var daySessionTemp = 0;
    var monthSessionTemp = 0;
    var yearSessionTemp = 0;
    var numDaysWithSessionM = 0;

    if (listLogs.isEmpty) {
      return;
    }

    listLogs = _getLastMonths(listLogs);

    // List to accumulate logs in months -> to display graphics
    var month = DateTime.now().month;
    var year = DateTime.now().year;
    for (var i = 0; i < listMonthlyLog.length; i++) {
      listMonthlyLog[i] = MonthlyLog(
        month: year.toString() + addZeros(month),
        totalTime: 0,
        timerTime: 0,
        medTime: 0,
        medSession: 0,
        timerSession: 0,
        sessions: 0,
      );
      if (month == 1) {
        month = 12;
        year--;
      } else {
        month--;
      }
    }

    // temp List to accumulate logs in days to calculate sequences
    var listDays = List.filled(365, DailyLog());
    for (var i = 0; i < listDays.length; i++) {
      listDays[i] = DailyLog(
        day: DateTime.now().subtract(Duration(days: i)),
        sessions: 0,
      );
    }

    for (var log in listLogs) {
      _totalTimeM = _totalTimeM + log.duration;

      if (log.type == 'timer') {
        _totalTimeTimerM = _totalTimeTimerM + log.duration;
        _numberTimerSessionsM++;
      } else {
        _totalTimeMedM = _totalTimeMedM + log.duration;
        _numberMedSessionsM++;
      }

      if (log.date!.year != yearSessionTemp || log.date!.month != monthSessionTemp || log.date!.day != daySessionTemp) {
        numDaysWithSessionM++;
        daySessionTemp = log.date!.day;
        monthSessionTemp = log.date!.month;
        yearSessionTemp = log.date!.year;
      }

      // insert values in the day that is in list -> search in day atribute
      var index =
          listMonthlyLog.indexWhere((value) => (value!.month == log.date!.year.toString() + addZeros(log.date!.month)));

      listMonthlyLog[index]!.totalTime = listMonthlyLog[index]!.totalTime! + log.duration;
      listMonthlyLog[index]!.medTime =
          log.type == 'guided' ? listMonthlyLog[index]!.medTime! + log.duration : listMonthlyLog[index]!.medTime;
      listMonthlyLog[index]!.timerTime =
          log.type == 'timer' ? listMonthlyLog[index]!.timerTime! + log.duration : listMonthlyLog[index]!.timerTime;
      listMonthlyLog[index]!.medSession =
          log.type == 'guided' ? listMonthlyLog[index]!.medSession! + 1 : listMonthlyLog[index]!.medSession;
      listMonthlyLog[index]!.timerSession =
          log.type == 'timer' ? listMonthlyLog[index]!.timerSession! + 1 : listMonthlyLog[index]!.timerSession!;
      listMonthlyLog[index]!.sessions = listMonthlyLog[index]!.sessions! + 1;

      // insert values in the day that is in list -> search in day atribute
      var indexDay = listDays.indexWhere((value) =>
          value.day!.day == log.date!.day && value.day!.month == log.date!.month && value.day!.year == log.date!.year);
      listDays[indexDay].sessions = listDays[indexDay].sessions! + 1;
    }
    _numberSessionsM = listLogs.length;
    _averageSessionTimeM = _totalTimeM ~/ listLogs.length;
    _dailyAverageTimeM = _totalTimeM ~/ numDaysWithSessionM;
    _dailyAverageSessionsM = _numberSessionsM / numDaysWithSessionM;

    listLogs.sort((a, b) => b.duration.compareTo(a.duration));
    _longestSessionM = listLogs[0].duration;

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
      _actualSequenceOfDaysWithSessionM = listSequences[0] ?? 1;
    } else {
      _actualSequenceOfDaysWithSessionM = 0;
    }

    listSequences.sort((a, b) => b.compareTo(a));
    _greaterSequenceOfDaysWithSessionM = listSequences[0];

    var listTemp = List.from(listDays);
    listTemp.sort((a, b) => b.sessions.compareTo(a.sessions));
    _greaterNumDailySessionsM = listTemp[0].sessions;

    // reorganize for graphics in UI
    listMonthlyLog.sort((a, b) => a!.month!.compareTo(b!.month!));

    //_seriesTimeListM = List<ChartSeries<MonthlyLog, String>>();
    //_seriesTimeListM = <ChartSeries<MonthlyLog?, String>>[

    _seriesTimeListM = [
      StackedColumnSeries<MonthlyLog?, String>(
        name: 'Timer',
        dataSource: listMonthlyLog,
        xValueMapper: (MonthlyLog? log, _) => log!.month!.substring(4),
        yValueMapper: (MonthlyLog? log, _) => log!.timerTime! ~/ 60,
        dataLabelMapper: (MonthlyLog? log, _) => (log!.timerTime! ~/ 60).toString(),
        dataLabelSettings: DataLabelSettings(
            isVisible: false,
            showZeroValue: false,
            labelAlignment: ChartDataLabelAlignment.top,
            color: Colors.grey[400],
            textStyle: const TextStyle(fontSize: 10),
            showCumulativeValues: true),
      ),
      StackedColumnSeries<MonthlyLog?, String>(
        name: 'Conduzida',
        dataSource: listMonthlyLog,
        xValueMapper: (MonthlyLog? log, _) => log!.month!.substring(4),
        yValueMapper: (MonthlyLog? log, _) => log!.medTime! ~/ 60,
        dataLabelMapper: (MonthlyLog? log, _) => (log!.medTime! ~/ 60).toString(),
        dataLabelSettings: DataLabelSettings(
            isVisible: false,
            showZeroValue: false,
            labelAlignment: ChartDataLabelAlignment.top,
            color: Colors.grey[400],
            textStyle: const TextStyle(fontSize: 10),
            showCumulativeValues: true),
      ),
    ] as List<CartesianSeries<dynamic, dynamic>>;

    //_seriesSessionsListM = List<ChartSeries<MonthlyLog, String>>();
    //_seriesSessionsListM = <ChartSeries<MonthlyLog?, String>>[
    _seriesSessionsListM = [
      StackedColumnSeries<MonthlyLog?, String>(
        name: 'Timer',
        dataSource: listMonthlyLog,
        xValueMapper: (MonthlyLog? log, _) => log!.month!.substring(4),
        yValueMapper: (MonthlyLog? log, _) => log!.timerSession,
        dataLabelMapper: (MonthlyLog? log, _) => (log!.timerSession).toString(),
        dataLabelSettings: DataLabelSettings(
            isVisible: false,
            showZeroValue: false,
            labelAlignment: ChartDataLabelAlignment.top,
            color: Colors.grey[400],
            textStyle: const TextStyle(fontSize: 10),
            showCumulativeValues: true),
      ),
      StackedColumnSeries<MonthlyLog?, String>(
        name: 'Conduzida',
        dataSource: listMonthlyLog,
        xValueMapper: (MonthlyLog? log, _) => log!.month!.substring(4),
        yValueMapper: (MonthlyLog? log, _) => log!.medSession,
        dataLabelMapper: (MonthlyLog? log, _) => (log!.medSession).toString(),
        dataLabelSettings: DataLabelSettings(
            isVisible: false,
            showZeroValue: false,
            labelAlignment: ChartDataLabelAlignment.top,
            color: Colors.grey[400],
            textStyle: const TextStyle(fontSize: 10),
            showCumulativeValues: true),
      ),
    ].cast<CartesianSeries>();
  }

  @override
  Widget build(BuildContext context) {
    if (_seriesTimeListM == null || _seriesSessionsListM == null) {
      _calculateStatisticsM(listLogsFromRepository);
    }
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
                    'Últimos 12 meses',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              _seriesTimeListM != null
                  ? Center(
                      child: SizedBox(
                          height: 250,
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: ExcludeSemantics(
                            child: SfCartesianChart(
                              series: _seriesTimeListM!,
                              primaryYAxis: const NumericAxis(
                                labelFormat: '{value}',
                                isVisible: true,
                              ),
                              primaryXAxis: const CategoryAxis(
                                interval: 1,
                                majorGridLines: MajorGridLines(width: 0),
                                title: AxisTitle(
                                  text: 'mês',
                                ),
                                labelRotation: 315,
                              ),
                              plotAreaBackgroundColor: Colors.grey[100],
                              title: const ChartTitle(
                                text: 'Tempo por mês (minutos)',
                                textStyle: TextStyle(fontSize: 16),
                              ),
                              tooltipBehavior: TooltipBehavior(enable: true),
                            ),
                          )),
                    )
                  : const SizedBox(height: 6),
              _seriesSessionsListM != null
                  ? Center(
                      child: SizedBox(
                          height: 250,
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: ExcludeSemantics(
                            child: SfCartesianChart(
                              series: _seriesSessionsListM!,
                              primaryYAxis: const NumericAxis(
                                labelFormat: '{value}',
                                isVisible: true,
                              ),
                              primaryXAxis: const CategoryAxis(
                                interval: 1,
                                majorGridLines: MajorGridLines(width: 0),
                                title: AxisTitle(
                                  text: 'mês',
                                ),
                                labelRotation: 315,
                              ),
                              plotAreaBackgroundColor: Colors.grey[100],
                              title: const ChartTitle(
                                text: 'Sessões por mês',
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
                    _showLine(title: 'Dias consecutivos - atual', value: actualSequenceOfDaysWithSessionM),
                    _showLine(title: 'Maior sequencia de dias consecutivos', value: greaterSequenceOfDaysWithSessionM),
                    const SizedBox(height: 24),
                    const Text('Tempo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    _showLine(title: 'Total', value: totalTimeM),
                    _showLine(title: 'Timer', value: totalTimeTimerM),
                    _showLine(title: 'Meditação conduzida', value: totalTimeMedM),
                    _showLine(title: 'Média diária', value: dailyAverageTimeM),
                    _showLine(title: 'Duração média', value: averageSessionTimeM),
                    _showLine(title: 'Sessão mais longa', value: longestSessionM),
                    const SizedBox(height: 24),
                    const Text('Sessões', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    _showLine(title: 'Total', value: numberSessionsM),
                    _showLine(title: 'Timer', value: numberTimerSessionsM),
                    _showLine(title: 'Meditação conduzida', value: numberMedSessionsM),
                    _showLine(title: 'Frequencia diária', value: dailyAverageSessionsM),
                    _showLine(title: 'Maior número em único dia', value: greaterNumDailySessionsM),
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
