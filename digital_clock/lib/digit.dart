import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'mini_clock.dart';

/// Digit consists of six mini clocks.
/// Positions of the mini clocks are the following:
/// (0)(1)
/// (2)(3)
/// (4)(5)

class Digit extends StatefulWidget {
  final StreamController numberStreamController;
  final bool isTens;
  final Color arrowsColor;
  final Color background;
  final double cellSize;

  Digit(
    this.numberStreamController,
    this.isTens,
    this.arrowsColor,
    this.background,
    this.cellSize,
  );

  @override
  _DigitState createState() => _DigitState();
}

class _DigitState extends State<Digit> {
  StreamController<int> digitStream = StreamController.broadcast();

  @override
  void initState() {
    super.initState();

    widget.numberStreamController.stream.listen((number) {
      int digit;
      if (widget.isTens) {
        digit = int.parse((number as String).substring(0, 1));
      } else {
        digit = int.parse((number as String).substring(1, 2));
      }

      digitStream.add(digit);
    }, onError: (error) {
      debugPrint("Error: $error");
    });
  }

  @override
  void dispose() {
    digitStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MiniClock(
                digitStream,
                0,
                widget.isTens,
                widget.arrowsColor,
                widget.background,
                widget.cellSize,
              ),
              MiniClock(
                digitStream,
                2,
                widget.isTens,
                widget.arrowsColor,
                widget.background,
                widget.cellSize,
              ),
              MiniClock(
                digitStream,
                4,
                widget.isTens,
                widget.arrowsColor,
                widget.background,
                widget.cellSize,
              )
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MiniClock(
                digitStream,
                1,
                widget.isTens,
                widget.arrowsColor,
                widget.background,
                widget.cellSize,
              ),
              MiniClock(
                digitStream,
                3,
                widget.isTens,
                widget.arrowsColor,
                widget.background,
                widget.cellSize,
              ),
              MiniClock(
                digitStream,
                5,
                widget.isTens,
                widget.arrowsColor,
                widget.background,
                widget.cellSize,
              )
            ],
          )
        ],
      ),
    );
  }
}
