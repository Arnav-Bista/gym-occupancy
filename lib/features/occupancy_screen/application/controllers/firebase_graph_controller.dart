
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

  bool old = false;

  Future<void> getData() async {
    state = const AsyncValue.loading();
    List<(int, int)> dataPoints = [];
    DataSnapshot data = await _getFirebaseRepository().getCurrentDayDataReference().get();
    if (data.value == null) {
      data = await _getFirebaseRepository().getPreviousDayDataReference().get(); 
      old = true;
    }
    final dataSnap = data.value as Map<dynamic, dynamic>;
    dataSnap.forEach((key, value) {
      DateTime date = DateFormat("dd-MM-yyyy HH:mm:ss").parse(key);
      int dateNumber = int.parse(DateFormat("HHmm").format(date));
      int occupancy = value as int;
      dataPoints.add((dateNumber,occupancy));
    });
    // Sort
    // TODO: Replace bubble with quick sort
    for(int i = 0; i < dataPoints.length; i++) {
      bool sorted = true;
      for(int j = 0; j < dataPoints.length - 1 - i; j++) {
        if(dataPoints[j].$1 > dataPoints[j + 1].$1) {
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

  Future<List<(int,int)>?> getSpecificData(DateTime date) async {
    DataSnapshot data = await _getFirebaseRepository().getDataReference(date).get();
    if (data.value == null) {
      return null;
    }
    final dataSnap = data.value as Map<dynamic, dynamic>;
    List<(int, int)> dataPoints = [];
    dataSnap.forEach((key, value) {
      DateTime date = DateFormat("dd-MM-yyyy HH:mm:ss").parse(key);
      int dateNumber = int.parse(DateFormat("HHmm").format(date));
      int occupancy = value as int;
      dataPoints.add((dateNumber,occupancy));
    });

    for(int i = 0; i < dataPoints.length; i++) {
      bool sorted = true;
      for(int j = 0; j < dataPoints.length - 1 - i; j++) {
        if(dataPoints[j].$1 > dataPoints[j + 1].$1) {
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
    return dataPoints;
  }

}
