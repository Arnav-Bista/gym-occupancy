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
  int hours = 0;

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
    final difference = now.difference(ukDateTimeParse(widget.startDate));
    hours = difference.inHours;
    minutes = difference.inMinutes % 60;
    seconds = difference.inSeconds % 60;
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
    return hours == 0 
        ? Text("Last updated $minutes minute${minutes == 1 ? "" : "s"} and $seconds second${seconds == 1 ? "" : "s"} ago")
        : Text("Last updated $hours hour${hours == 1 ? "" : "s"} and $minutes minute${minutes == 1 ? "" : "s"} ago");
  }
}
