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

import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

enum ClockText { roman, arabic }

typedef TimeProducer = DateTime Function();

class ClockFace extends StatelessWidget {
  final DateTime? dateTime;
  final ClockText clockText;
  const ClockFace({super.key, this.clockText = ClockText.arabic, this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: AspectRatio(
          aspectRatio: 0.75,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xfff4f9fd),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(8.0, 0),
                      blurRadius: 13,
                      spreadRadius: 1,
                      color: Color(0xffd3e0f0))
                ]),
          ),
        ),
      ),
    );
  }
}

class ClockHands extends StatelessWidget {
  final DateTime? dateTime;
  final bool showHourHandleHeartShape;

  const ClockHands({super.key, this.dateTime, this.showHourHandleHeartShape = false});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1.0,
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            child: Stack(fit: StackFit.expand, children: <Widget>[
              CustomPaint(
                painter: HourHandPainter(
                    hours: dateTime!.hour, minutes: dateTime!.minute),
              ),
              CustomPaint(
                painter: MinuteHandPainter(
                    minutes: dateTime!.minute, seconds: dateTime!.second),
              ),
              CustomPaint(
                painter: SecondHandPainter(seconds: dateTime!.second),
              ),
            ])));
  }
}

class ClockDialPainter extends CustomPainter {
  final clockText;

  final hourTickMarkLength = 10.0;
  final minuteTickMarkLength = 5.0;

  final hourTickMarkWidth = 3.0;
  final minuteTickMarkWidth = 1.5;

  final Paint tickPaint;
  final TextPainter textPainter;
  final TextStyle textStyle;

  final double tickLength = 8.0;
  final double tickWidth = 3.0;

  final romanNumeralList = [
    'XII',
    'I',
    'II',
    'III',
    'IV',
    'V',
    'VI',
    'VII',
    'VIII',
    'IX',
    'X',
    'XI'
  ];

  ClockDialPainter({this.clockText = ClockText.roman})
      : tickPaint = Paint(),
        textPainter = TextPainter(
          textAlign: TextAlign.center,
          textDirection: ui.TextDirection.ltr,
        ),
        textStyle = const TextStyle(
          color: Colors.black,
          fontFamily: 'Times Roman',
          fontSize: 15.0,
        ) {
    tickPaint.color = Colors.white;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double tickMarkLength;
    const angle = 2 * pi / 60;
    final radius = size.width / 2;
    canvas.save();

    // drawing
    canvas.translate(radius, radius);
    for (var i = 0; i < 60; i++) {
      //make the length and stroke of the tick marker longer and thicker depending
      tickMarkLength = tickLength;
      tickPaint.strokeWidth = tickWidth;
      canvas.drawLine(Offset(0.0, -radius),
          Offset(0.0, -radius + tickMarkLength), tickPaint);

      canvas.rotate(angle);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class HourHandPainter extends CustomPainter {
  final Paint hourHandPaint;
  int? hours;
  int? minutes;

  HourHandPainter({this.hours, this.minutes}) : hourHandPaint = Paint() {
    hourHandPaint.color = const Color(0xff222d62);
    hourHandPaint.style = PaintingStyle.stroke;
    hourHandPaint.strokeWidth = 6.0;
    hourHandPaint.strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    // To draw hour hand
    canvas.save();

    canvas.translate(radius, radius);

    //checks if hour is greater than 12 before calculating rotation
    canvas.rotate(hours! >= 12
        ? 2 * pi * ((hours! - 12) / 12 + (minutes! / 720))
        : 2 * pi * ((hours! / 12) + (minutes! / 720)));

    Path path = Path();
    //hour hand stem
    path.moveTo(0.0, -radius * 0.5);
    path.lineTo(0.0, radius * 0.1);

    canvas.drawPath(path, hourHandPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(HourHandPainter oldDelegate) {
    return true;
  }
}

class MinuteHandPainter extends CustomPainter {
  final Paint minuteHandPaint;
  int? minutes;
  int? seconds;

  MinuteHandPainter({this.minutes, this.seconds}) : minuteHandPaint = Paint() {
    minuteHandPaint.color = const Color(0xffc5cbdd);
    minuteHandPaint.style = PaintingStyle.stroke;
    minuteHandPaint.strokeCap = StrokeCap.round;
    minuteHandPaint.strokeWidth = 5.0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    canvas.save();

    canvas.translate(radius, radius);

    canvas.rotate(2 * pi * ((minutes! + (seconds! / 60)) / 60));

    Path path = Path();
    path.moveTo(0.0, -radius * 0.6);
    path.lineTo(0.0, radius * 0.1);

    path.close();

    canvas.drawPath(path, minuteHandPaint);
    canvas.drawShadow(path, Colors.black, 4.0, false);

    canvas.restore();
  }

  @override
  bool shouldRepaint(MinuteHandPainter oldDelegate) {
    return true;
  }
}

class SecondHandPainter extends CustomPainter {
  final Paint secondHandPaint;
  final Paint secondHandPointsPaint;

  int? seconds;

  SecondHandPainter({this.seconds})
      : secondHandPaint = Paint(),
        secondHandPointsPaint = Paint() {
    secondHandPaint.color = const Color(0xffff0764);
    secondHandPaint.style = PaintingStyle.stroke;
    secondHandPaint.strokeWidth = 4.0;
    secondHandPaint.strokeCap = StrokeCap.round;

    secondHandPointsPaint.color = const Color(0xffff0764);
    secondHandPointsPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    canvas.save();

    canvas.translate(radius, radius);

    canvas.rotate(2 * pi * seconds! / 60);

    Path path1 = Path();
    Path path2 = Path();
    path1.moveTo(0.0, -radius * 0.93);
    path1.lineTo(0.0, radius * 0.1);

    path2.addOval(Rect.fromCircle(radius: 5.0, center: const Offset(0.0, 0.0)));

    canvas.drawPath(path1, secondHandPaint);
    canvas.drawPath(path2, secondHandPointsPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(SecondHandPainter oldDelegate) {
    return seconds != oldDelegate.seconds;
  }
}

class ClockWidget extends StatefulWidget {
  const ClockWidget(
      {super.key,
      this.width,
      this.height,
      this.circleColor = const Color(0xfffe1ecf7),
      this.shadowColor = const Color(0xffd9e2ed),
      this.clockText = ClockText.arabic,
      this.getCurrentTime = getSystemTime,
      this.updateDuration = const Duration(seconds: 1)});

  final double? width;
  final double? height;
  final Color circleColor;
  final Color shadowColor;

  final ClockText clockText;

  final TimeProducer getCurrentTime;
  final Duration updateDuration;

  static DateTime getSystemTime() {
    return DateTime.now();
  }

  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  late Timer _timer;
  DateTime? dateTime;

  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now();
    _timer = Timer.periodic(widget.updateDuration, setTime);
  }

  void setTime(Timer timer) {
    setState(() {
      dateTime = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: buildClockCircle(context),
    );
  }

  Container buildClockCircle(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0.0, 5.0),
            blurRadius: 0.0,
            color: widget.shadowColor,
          ),
          BoxShadow(
              offset: const Offset(0.0, 5.0),
              color: widget.circleColor,
              blurRadius: 10,
              spreadRadius: -8)
        ],
      ),
      child: Stack(
        children: <Widget>[
          ClockFace(
            clockText: widget.clockText,
            dateTime: dateTime,
          ),
          Container(
            padding: const EdgeInsets.all(25),
            width: double.infinity,
            child: CustomPaint(
              painter: ClockDialPainter(clockText: widget.clockText),
            ),
          ),
          ClockHands(dateTime: dateTime),
        ],
      ),
    );
  }
}
