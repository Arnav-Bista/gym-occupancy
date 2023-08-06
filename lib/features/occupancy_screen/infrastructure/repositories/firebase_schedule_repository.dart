
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/core/functions/uk_datetime.dart';
import 'package:intl/intl.dart';


final firebaseScheduleRepository =  Provider<IFirebaseScheduleRepository>((ref) => FirebaseScheduleRepository());


abstract class IFirebaseScheduleRepository {
  DatabaseReference getScheduleReference(DateTime date);
  DatabaseReference getAllScheduleReference(DateTime date);
}

class FirebaseScheduleRepository extends IFirebaseScheduleRepository {
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  final datetimeToDate = DateFormat("yyyy-MM-dd");
  
  @override
  DatabaseReference getScheduleReference(DateTime date) {
    final weekStart = date.subtract(Duration(days: date.weekday - 1));
    String url = "scrape_data/${datetimeToDate.format(weekStart)}/schedule/${date.weekday - 1}/";
    return _firebaseDatabase.ref(url);
  }

  @override
  DatabaseReference getAllScheduleReference(DateTime date) {
    final weekStart = date.subtract(Duration(days: date.weekday - 1));
    String url = "scrape_data/${datetimeToDate.format(weekStart)}/schedule/";
    return _firebaseDatabase.ref(url);
  }



}

