import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/features/occupancy_screen/infrastructure/repositories/firebase_repository.dart';
import 'package:intl/intl.dart';


final firebaseScheduleController = StateNotifierProvider<FirebaseScheduleController, AsyncValue<(DateTime,DateTime)>>((ref) => FirebaseScheduleController(ref:ref));

class FirebaseScheduleController extends StateNotifier<AsyncValue<(DateTime, DateTime)>> {
  FirebaseScheduleController({required this.ref}) : super(const AsyncValue.loading()) {
    getCurrentSchedule();
  }

  final StateNotifierProviderRef ref;

  IFirebaseRepository _getFirebaseRepository() => ref.read(firebaseRepository);

  final scheduleFormatter = DateFormat("yyyy-MM-dd HH:mm:ss");

  Future<void> getCurrentSchedule() async {
    state = const AsyncValue.loading();
    final startData = await _getFirebaseRepository().getScheduleReference(true).get();
    final endData = await _getFirebaseRepository().getScheduleReference(false).get();

    final startDate = scheduleFormatter.parse(startData.value as String);
    final endDate = scheduleFormatter.parse(endData.value as String);

    state = AsyncValue.data((startDate, endDate));
  }

}
