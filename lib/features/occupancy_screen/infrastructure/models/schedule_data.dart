import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final scheduleDataProvider = Provider((ref) => ScheduleData());

class ScheduleData {
  HashMap<String,List<(DateTime,DateTime)>> weekCache = HashMap();

  final DateFormat keyFormatter = DateFormat("yyyy-MM-dd");

  String getKey(DateTime date) {
    final weekStart = date.subtract(Duration(days: date.weekday - 1));
    final key = keyFormatter.format(weekStart);
    return key;
  }

  bool contains(DateTime date) {
    return weekCache.containsKey(getKey(date));
  }

  List<(DateTime, DateTime)> getData(DateTime date) {
    return weekCache[getKey(date)]!;
  }

  void put(DateTime date, List<(DateTime, DateTime)> data) {
    weekCache[getKey(date)] = data;
  }


}
