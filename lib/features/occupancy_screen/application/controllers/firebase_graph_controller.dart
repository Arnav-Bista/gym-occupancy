
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/features/occupancy_screen/infrastructure/repositories/firebase_repository.dart';
import 'package:intl/intl.dart';


final firebaseGraphController = StateNotifierProvider<FirebaseGraphController, AsyncValue<List<(int, int)>>>((ref) => FirebaseGraphController(ref: ref));

class FirebaseGraphController extends StateNotifier<AsyncValue<List<(int, int)>>> {
  FirebaseGraphController({required this.ref}) : super(const AsyncValue.loading()) {
    getData();
  }

  final StateNotifierProviderRef ref;
  final RegExp regex = RegExp("\\s(\\d+:\\d+)");

  IFirebaseRepository _getFirebaseRepository() => ref.read(firebaseRepository);


  Future<void> getData() async {
    state = const AsyncValue.loading();
    List<(int, int)> dataPoints = [];

    final (date,reference) = await _getFirebaseRepository().getDayDataReference();
    DataSnapshot data = await reference.get();

    for(DataSnapshot dataPoint in data.children) {
      int time = int.parse(dataPoint.key!);
      int occupancy = dataPoint.value as int;
      dataPoints.add((time,occupancy));
    }
    state = AsyncValue.data(dataPoints);
  }

}
