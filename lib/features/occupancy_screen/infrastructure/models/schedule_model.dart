
import 'package:flutter_riverpod/flutter_riverpod.dart';

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



}
