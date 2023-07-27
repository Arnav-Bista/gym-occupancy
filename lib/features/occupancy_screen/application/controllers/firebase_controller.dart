
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/core/functions/uk_datetime.dart';
import 'package:gym_occupancy/features/occupancy_screen/infrastructure/repositories/firebase_repository.dart';
import 'package:intl/intl.dart';

final firebaseController  = StateNotifierProvider<FirebaseController, AsyncValue<(DateTime, int)>>((ref) => FirebaseController(ref: ref));

class FirebaseController extends StateNotifier<AsyncValue<(DateTime, int)>> {

  FirebaseController({required this.ref}) : super(const AsyncValue.loading()) {
    _getFirebaseRepository().getLatestReference().onValue.listen(listener);
  }

  final StateNotifierProviderRef ref;


  IFirebaseRepository _getFirebaseRepository() => ref.read(firebaseRepository);

  Future<void> listener(DatabaseEvent event) async {
    state = const AsyncValue.loading();
    final snapshot = event.snapshot.children.first;
    String latestScrapeKey = snapshot.key!;
    DateTime date = DateFormat("dd-MM-yyyy HH:mm:ss").parse(latestScrapeKey);
    int occupancy = snapshot.value as int;
    state = AsyncValue.data((date, occupancy));
  }


}
