
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/core/functions/uk_datetime.dart';

final scheduleModelProvider = Provider((ref) => ScheduleModel());

class ScheduleModel {
  // Open? Opening, Closing
  List<(bool, int, int)> data = [];

  ScheduleModel();

  void setData(List<(bool, int, int)> newData) {
    data = newData;
  }

  List<(bool, int, int)> dataFromJSON(dynamic json) {
    List<(bool, int, int)> newData = [];
    for(int i = 0; i < 7; i++) {
      bool open = json["timings"][i]["open"];
      int opening = json["timings"][i]["opening"];
      int closing = json["timings"][i]["closing"];
      newData.add((open, opening, closing));
    }
    return newData;
  }


  int _getHour(int input) {
    return input ~/ 100;
  }

  int _getMinute(int input) {
    return input - (input ~/ 100) * 100;
  }

  (bool, DateTime, DateTime) getEntry(int index) {
    DateTime now = ukDateTimeNow();
    if(!data[index].$1) {
      return (false, now, now);
    }
    DateTime opening = DateTime(now.year, now.month, now.day, _getHour(data[index].$2), _getMinute(data[index].$2));
    DateTime closing = DateTime(now.year, now.month, now.day, _getHour(data[index].$3), _getMinute(data[index].$3));
    return (true, opening, closing);
  }

  (bool, DateTime, DateTime) getEntryFromRecord((bool, int, int) data) {
    DateTime now = ukDateTimeNow();
    if (!data.$1) {
      return (false, now, now);
    }
    DateTime opening = DateTime(now.year, now.month, now.day, _getHour(data.$2), _getMinute(data.$2));
    DateTime closing = DateTime(now.year, now.month, now.day, _getHour(data.$3), _getMinute(data.$3));
    return (true, opening, closing);
  }

}
