
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/features/occupancy_screen/infrastructure/repositories/firebase_repository.dart';
import 'package:intl/intl.dart';


final firebaseGraphController = StateNotifierProvider<FirebaseGraphController, AsyncValue<List<(DateTime, int)>>>((ref) => FirebaseGraphController(ref: ref));

class FirebaseGraphController extends StateNotifier<AsyncValue<List<(DateTime, int)>>> {
  FirebaseGraphController({required this.ref}) : super(const AsyncValue.loading()) {
    getData();
  }

  final StateNotifierProviderRef ref;
  final RegExp regex = RegExp("\\s(\\d+:\\d+)");

  IFirebaseRepository _getFirebaseRepository() => ref.read(firebaseRepository);

  bool old = false;

  Future<void> getData() async {
    state = const AsyncValue.loading();
    List<(DateTime, int)> dataPoints = [];
    DataSnapshot data = await _getFirebaseRepository().getCurrentDayDataReference().get();
    if (data.value == null) {
      data = await _getFirebaseRepository().getPreviousDayDataReference().get(); 
      old = true;
    }
    final dataSnap = data.value as Map<dynamic, dynamic>;
    dataSnap.forEach((key, value) {
      DateTime date = DateFormat("dd-MM-yyyy HH:mm:ss").parse(key);
      int occupancy = value as int;
      dataPoints.add((date,occupancy));
    });
    // Sort
    // TODO: Replace bubble with quick sort
    for(int i = 0; i < dataPoints.length; i++) {
      bool sorted = true;
      for(int j = 0; j < dataPoints.length - 1 - i; j++) {
        if(dataPoints[j].$1.isAfter(dataPoints[j + 1].$1)) {
          var temp = dataPoints[j];
          dataPoints[j] = dataPoints[j + 1];
          dataPoints[j + 1] = temp;
          sorted = false;
        }
      }
      if(sorted) {
        break;
      }
    }
    // print(dataPoints);
    state = AsyncValue.data(dataPoints);
  }

}
