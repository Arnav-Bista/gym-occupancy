import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/core/functions/uk_datetime.dart';
import 'package:gym_occupancy/core/models/custom_error.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_multi_schedule_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/infrastructure/models/schedule_data.dart';
import 'package:gym_occupancy/features/occupancy_screen/infrastructure/repositories/firebase_repository.dart';
import 'package:gym_occupancy/features/occupancy_screen/infrastructure/repositories/firebase_schedule_repository.dart';
import 'package:intl/intl.dart';


final firebaseScheduleController = StateNotifierProvider<FirebaseScheduleController, AsyncValue<(DateTime, DateTime)>>((ref) => FirebaseScheduleController(ref:ref));

class FirebaseScheduleController extends StateNotifier<AsyncValue<(DateTime, DateTime)>> {
  FirebaseScheduleController({required this.ref}) : super(const AsyncValue.loading()) {
    getSchedule(ukDateTimeNow());
  }

  final StateNotifierProviderRef ref;

  IFirebaseScheduleRepository _getFirebaseScheduleRepository() => ref.read(firebaseScheduleRepository);

  FirebaseMultiScheduleController _getFirebaseMultiScheduleController() => ref.read(firebaseMultiScheduleController.notifier);
  final scheduleFormatter = DateFormat("yyyy-MM-dd HH:mm:ss");
  ScheduleData _getScheduleData() => ref.read(scheduleDataProvider);


  Future<void> getSchedule(DateTime date) async {
    state = const AsyncValue.loading();
    // final key = _scheduleData().getKey(date);
    if(_getScheduleData().contains(date)) {
      final data = _getScheduleData().getData(date);
      state = AsyncValue.data(data[date.weekday - 1]);
      return;
    }
    await _getFirebaseMultiScheduleController().getData(date);
    _getFirebaseMultiScheduleController().state.whenOrNull(
      error: (error, stack) {
        state = AsyncValue.error("Not Fetched", StackTrace.current);
      },
      data: (data) {
      state = AsyncValue.data(data![date.weekday - 1]);
      }
    );
  }
}

