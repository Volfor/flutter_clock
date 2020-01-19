// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'digit.dart';

enum _Element {
  background,
  arrows,
  circlesBackground,
}

final _lightTheme = {
  _Element.background: Colors.white,
  _Element.arrows: Colors.black,
  _Element.circlesBackground: Colors.black12,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.arrows: Colors.white,
  _Element.circlesBackground: Colors.white12,
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  StreamController<String> _hourStream = StreamController.broadcast();
  StreamController<String> _minuteStream = StreamController.broadcast();
  StreamController<String> _secondStream = StreamController.broadcast();

  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTime();
      _updateModel();
    });
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    _hourStream.close();
    _minuteStream.close();
    _secondStream.close();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
//      _timer = Timer(
//        Duration(minutes: 1) -
//            Duration(seconds: _dateTime.second) -
//            Duration(milliseconds: _dateTime.millisecond),
//        _updateTime,
//      );

      final hour = DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh')
          .format(_dateTime);
      final minute = DateFormat('mm').format(_dateTime);
      final second = DateFormat('ss').format(_dateTime);

      _hourStream.add(hour);
      _minuteStream.add(minute);
      _secondStream.add(second);

      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        var offset = 16;

        var c = constraints.maxWidth / 8;
        var smallCellSize = c / 2;

        var cellSize =
            (constraints.maxWidth - (smallCellSize * 4) - offset) / 8.0;

        return Container(
          color: colors[_Element.background],
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Digit(
                  _hourStream,
                  true,
                  colors[_Element.arrows],
                  colors[_Element.circlesBackground],
                  cellSize,
                ),
                Digit(
                  _hourStream,
                  false,
                  colors[_Element.arrows],
                  colors[_Element.circlesBackground],
                  cellSize,
                ),
                Digit(
                  _minuteStream,
                  true,
                  colors[_Element.arrows],
                  colors[_Element.circlesBackground],
                  cellSize,
                ),
                Digit(
                  _minuteStream,
                  false,
                  colors[_Element.arrows],
                  colors[_Element.circlesBackground],
                  cellSize,
                ),
                Digit(
                  _secondStream,
                  true,
                  colors[_Element.arrows],
                  colors[_Element.circlesBackground],
                  smallCellSize,
                ),
                Digit(
                  _secondStream,
                  false,
                  colors[_Element.arrows],
                  colors[_Element.circlesBackground],
                  smallCellSize,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
