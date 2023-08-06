import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/core/functions/uk_datetime.dart';
import 'package:gym_occupancy/features/occupancy_screen/infrastructure/models/schedule_data.dart';
import 'package:gym_occupancy/features/occupancy_screen/infrastructure/repositories/firebase_schedule_repository.dart';
import 'package:intl/intl.dart';


final firebaseMultiScheduleController = StateNotifierProvider<FirebaseMultiScheduleController, AsyncValue<List<(DateTime,DateTime)>?>>((ref) => FirebaseMultiScheduleController(ref: ref));

class FirebaseMultiScheduleController extends StateNotifier<AsyncValue<List<(DateTime, DateTime)>?>> {
  FirebaseMultiScheduleController({required this.ref}) : super(const AsyncValue.loading()) {
    getData(ukDateTimeNow());
  }

  final StateNotifierProviderRef ref;

  final scheduleFormatter = DateFormat("yyyy-MM-dd HH:mm:ss");

  IFirebaseScheduleRepository _getFirebaseScheduleRepository() => ref.read(firebaseScheduleRepository);

  ScheduleData _getScheduleData() => ref.read(scheduleDataProvider);


  Future<void> getData(DateTime date) async {
    state = const AsyncValue.loading();
    if (_getScheduleData().contains(date)) {
      state = AsyncValue.data(_getScheduleData().getData(date));
      return;
    }
    
    final databaseData = await _getFirebaseScheduleRepository().getAllScheduleReference(date).get();

    if(databaseData.value == null) {
      state = AsyncValue.error("Not Fetched", StackTrace.current);
      return;
      // Data is not fetched yet.
      // getData(date.subtract(const Duration(days: 7)));
      // return;
    }

    List<(DateTime, DateTime)> data = [];
    // print(data.value);
    for(DataSnapshot snap in databaseData.children) {
      final startDate = scheduleFormatter.parse(snap.child("start").value! as String);
      final endDate = scheduleFormatter.parse(snap.child("end").value! as String);
      data.add((startDate,endDate));
    }
    _getScheduleData().put(date, data);
    state = AsyncValue.data(data);
  }


}
