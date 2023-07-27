import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/core/functions/uk_datetime.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key, required this.startDate});

  final DateTime startDate;


  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {

  Timer? secondsTimer;
  Timer? minuteTimer;

  String text = "";
  int seconds = 0;
  int minutes = 0;

  void startSecondsTimer() {
    secondsTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds += 1;
      });
      if(seconds == 60) {
        seconds = 0;
        minutes += 1;
      }
    });
  }


  @override
  void initState() {
    super.initState();
    final now = ukDateTimeNow();
    minutes = (now.hour - widget.startDate.hour) * 60 + now.minute - widget.startDate.minute;
    seconds = now.second - widget.startDate.second;
    if(seconds < 0) {
      minutes -= 1;
      seconds += 60;
    }
    startSecondsTimer();

  }

  @override
  void dispose() {
    super.dispose();
    secondsTimer?.cancel();
    minuteTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Text("Last updated $minutes minutes $seconds seconds ago");
  }
}
