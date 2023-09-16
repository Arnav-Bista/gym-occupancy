import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gym_occupancy/core/functions/uk_datetime.dart';
import 'package:gym_occupancy/features/occupancy_screen/infrastructure/repositories/firebase_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

final firebasePredictionTomorrowController = StateNotifierProvider<FirebasePredictionTomorrowController, AsyncValue<List<(int,int)>>>((ref) => FirebasePredictionTomorrowController(ref: ref));

class FirebasePredictionTomorrowController extends StateNotifier<AsyncValue<List<(int,int)>>> {
  FirebasePredictionTomorrowController({required this.ref}) : super(const AsyncValue.loading()) {
    getData();
  }

  final StateNotifierProviderRef ref;
  IFirebaseRepository _getFirebaseRepository() => ref.read(firebaseRepository);
  final box = Hive.box("predictions");
  final DateFormat dateFormatter = DateFormat("yyyy-MM-dd");

  Future<void> getData() async {
    state = const AsyncValue.loading();
    List<(int,int)> dataPoints = [];
    
    final DateTime tomorrow = ukDateTimeNow().add(const Duration(days: 1));
    final String tomorrowDate = dateFormatter.format(tomorrow);

    String? date = box.get("tomorrow_date");
    if (date != null && date == tomorrowDate) {
      final List<(int,int)>? storedData = box.get("tomorrow_data");
      if(storedData != null) {
        state = AsyncValue.data(storedData);
        return;
      }
    } 

    final reference = _getFirebaseRepository().getPredictionReference(tomorrow);
    DataSnapshot data = await reference.get();
    for(DataSnapshot dataPoint in data.children) {
      int time = int.parse(dataPoint.key!);
      int occupancy = dataPoint.value as int;
      dataPoints.add((time,occupancy));
    }

    box.put("tomorrow_date", date);
    box.put("tomorrow_data", dataPoints);
    print(dataPoints);

    state = AsyncValue.data(dataPoints);
  }

}
