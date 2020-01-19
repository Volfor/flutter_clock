import 'dart:async';

import 'package:angles/angles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

//region degrees data
List<List<double>> _degreesFor_0 = [
  [0, 90],
  [0, 270],
  [0, 180],
  [0, 180],
  [90, 180],
  [180, 270],
];

List<List<double>> _degreesFor_1 = [
  [0, 0],
  [225, 225],
  [0, 180],
  [225, 225],
  [180, 180],
  [225, 225],
];

// ignore: non_constant_identifier_names
List<List<double>> _degreesFor_1_isTens = [
  [225, 225],
  [0, 0],
  [225, 225],
  [0, 180],
  [225, 225],
  [180, 180],
];

List<List<double>> _degreesFor_2 = [
  [90, 90],
  [0, 270],
  [0, 90],
  [270, 180],
  [90, 180],
  [270, 270],
];

List<List<double>> _degreesFor_3 = [
  [90, 90],
  [0, 270],
  [90, 90],
  [0, 180],
  [90, 90],
  [180, 270],
];

List<List<double>> _degreesFor_4 = [
  [0, 0],
  [0, 0],
  [90, 180],
  [0, 180],
  [225, 225],
  [180, 180],
];

List<List<double>> _degreesFor_5 = [
  [0, 90],
  [270, 270],
  [90, 180],
  [0, 270],
  [90, 90],
  [180, 270],
];

List<List<double>> _degreesFor_6 = [
  [0, 90],
  [270, 270],
  [0, 180],
  [0, 270],
  [90, 180],
  [180, 270],
];

List<List<double>> _degreesFor_7 = [
  [90, 90],
  [0, 270],
  [225, 225],
  [0, 180],
  [225, 225],
  [180, 180],
];

List<List<double>> _degreesFor_8 = [
  [0, 90],
  [0, 270],
  [90, 0],
  [0, 270],
  [90, 180],
  [180, 270],
];

List<List<double>> _degreesFor_9 = [
  [0, 90],
  [0, 270],
  [90, 180],
  [0, 180],
  [90, 90],
  [180, 270],
];
//endregion

class MiniClock extends StatefulWidget {
  final StreamController digitStreamController;
  final int position;
  final bool isTens;

  final Color arrowsColor;
  final Color background;
  final double size;

  MiniClock(
    this.digitStreamController,
    this.position,
    this.isTens,
    this.arrowsColor,
    this.background,
    this.size,
  );

  @override
  State<StatefulWidget> createState() => _MiniClockState();
}

class _MiniClockState extends State<MiniClock> with TickerProviderStateMixin {
  double _animDegreeHour = 0;
  double _animDegreeMinute = 0;

  Animation<double> _animationHour;
  Tween<double> _tweenHour;
  AnimationController _controllerHour;

  Animation<double> _animationMinute;
  Tween<double> _tweenMinute;
  AnimationController _controllerMinute;

  void setNewDegrees(double degreeHour, double degreeMinute) {
    _tweenHour.begin = _tweenHour.end;
    _controllerHour.reset();
    _tweenHour.end = degreeHour;
    _controllerHour.forward();

    _tweenMinute.begin = _tweenMinute.end;
    _controllerMinute.reset();
    _tweenMinute.end = degreeMinute;
    _controllerMinute.forward();
  }

  @override
  void initState() {
    super.initState();

    _controllerHour = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _controllerMinute = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _tweenHour = Tween(begin: 0.0, end: 0.0);
    _tweenMinute = Tween(begin: 0.0, end: 0.0);

    _animationHour = _tweenHour.animate(_controllerHour)
      ..addListener(() {
        setState(() {
          _animDegreeHour = _animationHour.value;
        });
      });

    _animationMinute = _tweenMinute.animate(_controllerMinute)
      ..addListener(() {
        setState(() {
          _animDegreeMinute = _animationMinute.value;
        });
      });

    widget.digitStreamController.stream.listen((digit) {
      var degreeData = getDegreeDataFromDigit(digit, widget.position);
      setNewDegrees(degreeData.degreeHour, degreeData.degreeMinute);
    }, onError: (error) {
      debugPrint("Error: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        size: Size(widget.size, widget.size),
        painter: MiniClockPainter(
          _animDegreeHour,
          _animDegreeMinute,
          widget.background,
          widget.arrowsColor,
          widget.size / 2,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllerHour.dispose();
    _controllerMinute.dispose();
    super.dispose();
  }

  DegreeData getDegreeDataFromDigit(int digit, int position) {
    List<double> degrees;

    switch (digit) {
      case 0:
        degrees = _degreesFor_0[position];
        break;
      case 1:
        if (widget.isTens) {
          degrees = _degreesFor_1_isTens[position];
        } else {
          degrees = _degreesFor_1[position];
        }
        break;
      case 2:
        degrees = _degreesFor_2[position];
        break;
      case 3:
        degrees = _degreesFor_3[position];
        break;
      case 4:
        degrees = _degreesFor_4[position];
        break;
      case 5:
        degrees = _degreesFor_5[position];
        break;
      case 6:
        degrees = _degreesFor_6[position];
        break;
      case 7:
        degrees = _degreesFor_7[position];
        break;
      case 8:
        degrees = _degreesFor_8[position];
        break;
      case 9:
        degrees = _degreesFor_9[position];
        break;
    }

    return DegreeData(degrees[0], degrees[1]);
  }
}

class MiniClockPainter extends CustomPainter {
  final double degreeHour;
  final double degreeMinute;
  final Color bgColor;
  final Color arrowsColor;
  final double radius;

  var _circlePaint;
  var _arrowPaint;
  var _centerPaint;

  MiniClockPainter(
    this.degreeHour,
    this.degreeMinute,
    this.bgColor,
    this.arrowsColor,
    this.radius,
  ) {
    _circlePaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    _arrowPaint = Paint()
      ..color = arrowsColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius / 4.5
      ..isAntiAlias = true;

    _centerPaint = Paint()
      ..color = arrowsColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2.0;
    double centerY = size.height / 2.0;

    var padding = 5;
    var r = radius - padding;

    var angleHour = Angle.fromDegrees(degreeHour);
    var x1 = r * angleHour.sin;
    var y1 = r * angleHour.cos;

    var angleMinute = Angle.fromDegrees(degreeMinute);
    var x2 = r * angleMinute.sin;
    var y2 = r * angleMinute.cos;

    canvas.drawCircle(Offset(centerX, centerY), radius, _circlePaint);
    canvas.drawCircle(
        Offset(centerX, centerY), _arrowPaint.strokeWidth / 2, _centerPaint);

    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(centerX + x1, centerY + y1),
      _arrowPaint,
    );

    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(centerX + x2, centerY + y2),
      _arrowPaint,
    );
  }

  @override
  bool shouldRepaint(MiniClockPainter oldDelegate) {
    return oldDelegate.degreeHour != degreeHour ||
        oldDelegate.degreeMinute != degreeMinute ||
        oldDelegate.bgColor != bgColor ||
        oldDelegate.arrowsColor != arrowsColor;
  }
}

class DegreeData {
  double degreeHour;
  double degreeMinute;

  DegreeData(this.degreeHour, this.degreeMinute);
}
