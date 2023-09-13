import 'package:firebase_database/firebase_database.dart'; import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/core/functions/uk_datetime.dart';
import "package:intl/intl.dart";

final firebaseRepository = Provider<IFirebaseRepository>((ref) => FirebaseRepository());

abstract class IFirebaseRepository {
  DatabaseReference getLatestReference();
  Future<(DateTime,DatabaseReference)> getDayDataReference();
  DatabaseReference getDataReference(DateTime date);
  Future<DatabaseReference> getPredictionDataReference();
  DatabaseReference getScheduleReference();
}

class FirebaseRepository extends IFirebaseRepository {
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  final datetimeToDate = DateFormat("yyyy-MM-dd");
  static DateTime? latestKey;

  DateTime getWeekStart() {
    DateTime now = ukDateTimeNow();
    // week offset by +1 in dart that compared to python
    final start = now.subtract(Duration(days: now.weekday - 1));
    return start;
  }
  
  @override
  Future<(DateTime,DatabaseReference)> getDayDataReference() async {
    final latestDay = await _firebaseDatabase.ref("rs_data/data/latest/data").get();
    final map = latestDay.value as Map<dynamic, dynamic>;
    final key = map.keys.first as String;
    final DateTime date = DateFormat("yyyy-MM-dd-HH-mm").parse(key);
    return (date,getDataReference(date));
  }

  @override
  DatabaseReference getLatestReference() {
    return _firebaseDatabase.ref("rs_data/data/latest");
  }

  @override
  DatabaseReference getDataReference(DateTime date) {
    final weekStart = date.subtract(Duration(days: date.weekday - 1));
    String url = "rs_data/data/${datetimeToDate.format(weekStart)}/${date.weekday - 1}";
    return _firebaseDatabase.ref(url);
  }
  
  @override
  Future<DatabaseReference> getPredictionDataReference() async {
    final latestDay = await _firebaseDatabase.ref("rs_data/data/latest/data").get();
    final map = latestDay.value as Map<dynamic, dynamic>;
    final key = map.keys.first as String;
    final DateTime date = DateFormat("yyyy-MM-dd-HH-mm").parse(key);
    final DateTime weekStart = date.subtract(Duration(days: date.weekday - 1));
    String url = "rs_data/prediction/${datetimeToDate.format(weekStart)}/${date.weekday - 1}";
    return _firebaseDatabase.ref(url);
      }

  @override
    DatabaseReference getScheduleReference() {
      String url = "rs_data/data/latest/schedule";
      return _firebaseDatabase.ref(url);
    }
}
