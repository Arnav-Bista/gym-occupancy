
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/core/functions/uk_datetime.dart';
import 'package:gym_occupancy/features/occupancy_screen/infrastructure/repositories/firebase_repository.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';

final firebaseController  = StateNotifierProvider<FirebaseController, AsyncValue<(DateTime, int)>>((ref) => FirebaseController(ref: ref));

class FirebaseController extends StateNotifier<AsyncValue<(DateTime, int)>> {

  FirebaseController({required this.ref}) : super(const AsyncValue.loading()) {
    addListenerToLatest();
  }

  final StateNotifierProviderRef ref;
  StreamSubscription? subscription;


  IFirebaseRepository _getFirebaseRepository() => ref.read(firebaseRepository);
  

  Future<void> dataListener(DatabaseEvent event) async {
    state = const AsyncValue.loading();
    final snapshot = event.snapshot.child("data").children.first;
    String latestScrapeKey = snapshot.key!;
    print(latestScrapeKey);
    DateTime date = DateFormat("yyyy-MM-dd-HH-mm").parse(latestScrapeKey);
    int occupancy = snapshot.value as int;
    state = AsyncValue.data((date, occupancy));
  }

  void addListenerToLatest() {
    subscription = _getFirebaseRepository().getLatestReference().onValue.listen(dataListener);
  }
  void removeListenerToLatest() {
    subscription?.cancel();
  }
}
