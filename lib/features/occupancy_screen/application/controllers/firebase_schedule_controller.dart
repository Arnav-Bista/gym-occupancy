import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/core/functions/uk_datetime.dart';
import 'package:gym_occupancy/core/models/custom_error.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_multi_schedule_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/infrastructure/models/schedule_data.dart';
import 'package:gym_occupancy/features/occupancy_screen/infrastructure/models/schedule_model.dart';
import 'package:gym_occupancy/features/occupancy_screen/infrastructure/repositories/firebase_repository.dart';
import 'package:gym_occupancy/features/occupancy_screen/infrastructure/repositories/firebase_schedule_repository.dart';
import 'package:intl/intl.dart';


final firebaseScheduleController = StateNotifierProvider<FirebaseScheduleController, AsyncValue<(bool, DateTime, DateTime)>>((ref) => FirebaseScheduleController(ref:ref));

class FirebaseScheduleController extends StateNotifier<AsyncValue<(bool, DateTime, DateTime)>> {
  FirebaseScheduleController({required this.ref}) : super(const AsyncValue.loading()) {
    getSchedule(ukDateTimeNow());
  }

  final StateNotifierProviderRef ref;

  IFirebaseRepository _getFirebaseRepository() => ref.read(firebaseRepository);

  FirebaseMultiScheduleController _getFirebaseMultiScheduleController() => ref.read(firebaseMultiScheduleController.notifier);
  final scheduleFormatter = DateFormat("yyyy-MM-dd HH:mm:ss");
  ScheduleData _getScheduleData() => ref.read(scheduleDataProvider);
  ScheduleModel _getScheduleModel() => ref.read(scheduleModelProvider);

  int _getHour(int input) {
    return input ~/ 100;
  }

  int _getMinute(int input) {
    return input - (input ~/ 100) * 100;
  }

  (bool, DateTime, DateTime) _getData(List<(bool, int, int)> data) {
    DateTime ukToday = ukDateTimeNow();
    int weekday = ukToday.weekday - 1;
    if(!_getScheduleModel().data[weekday].$1) {
      return (false, ukToday, ukToday);
    }
    DateTime opening = DateTime(ukToday.year, ukToday.month, ukToday.day, _getHour(data[weekday].$2), _getMinute(data[weekday].$2));
    DateTime closing = DateTime(ukToday.year, ukToday.month, ukToday.day, _getHour(data[weekday].$3), _getMinute(data[weekday].$3));
    return (true, opening, closing);
  }

  Future<void> getSchedule(DateTime date) async {
    state = const AsyncValue.loading();
    // final key = _scheduleData().getKey(date);
    if(_getScheduleModel().data.isNotEmpty) {
      //alr parsed
      state = AsyncValue.data(_getData(_getScheduleModel().data));
    }
    DataSnapshot scheduleJson = await _getFirebaseRepository().getScheduleReference().get();
    _getScheduleModel().setData(_getScheduleModel().dataFromJSON(scheduleJson.value));
    state = AsyncValue.data(_getData(_getScheduleModel().data));
  }

  ScheduleModel getAllSchedule() {
    return _getScheduleModel(); 
  }
}

