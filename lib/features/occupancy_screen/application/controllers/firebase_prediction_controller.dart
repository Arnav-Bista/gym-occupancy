import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gym_occupancy/core/functions/uk_datetime.dart';
import 'package:gym_occupancy/features/occupancy_screen/infrastructure/repositories/firebase_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

final firebasePredictionController = StateNotifierProvider<FirebasePredictionController, AsyncValue<List<(int,int)>>>((ref) => FirebasePredictionController(ref: ref));

class FirebasePredictionController extends StateNotifier<AsyncValue<List<(int,int)>>> {
  FirebasePredictionController({required this.ref}) : super(const AsyncValue.loading()) {
    getData();
  }

  final StateNotifierProviderRef ref;
  IFirebaseRepository _getFirebaseRepository() => ref.read(firebaseRepository);
  final box = Hive.box("predictions");
  final DateFormat dateFormatter = DateFormat("yyyy-MM-dd");

  Future<void> getData() async {
    state = const AsyncValue.loading();
    List<(int,int)> dataPoints = [];

    final String currentDate = dateFormatter.format(ukDateTimeNow());

    String? date = box.get("date");
    if (date != null && date == currentDate) {
      final List<(int,int)>? storedData = box.get("data");
      if(storedData != null) {
        state = AsyncValue.data(storedData);
        return;
      }
    } 

    final reference = await _getFirebaseRepository().getPredictionDataReference();
    DataSnapshot data = await reference.get();
    for(DataSnapshot dataPoint in data.children) {
      int time = int.parse(dataPoint.key!);
      int occupancy = dataPoint.value as int;
      dataPoints.add((time,occupancy));
    }

    box.put("date", date);
    box.put("data", dataPoints);

    state = AsyncValue.data(dataPoints);
  }

}
