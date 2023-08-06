import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/core/functions/uk_datetime.dart';
import "package:intl/intl.dart";

final firebaseRepository = Provider<IFirebaseRepository>((ref) => FirebaseRepository());

abstract class IFirebaseRepository {
  Future<int> getOccupancy();
  DatabaseReference getLatestReference();
  DatabaseReference getCurrentDayDataReference();
  DatabaseReference getPreviousDayDataReference();
  DatabaseReference getDataReference(DateTime date);

}

class FirebaseRepository extends IFirebaseRepository {
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  final datetimeToDate = DateFormat("yyyy-MM-dd");

  DateTime getWeekStart() {
      DateTime now = ukDateTimeNow();
      // week offset by +1 in dart that compared to python
      final start = now.subtract(Duration(days: now.weekday - 1));
      return start;
  }


  @override
    Future<int> getOccupancy() async {
      final start = getWeekStart();
      final String databaseKey = datetimeToDate.format(start);
      DatabaseReference _ref = _firebaseDatabase.ref("scrape_data/latest");
      final data = await _ref.get();
      return data.children.first.value! as int;
    }

  @override
    DatabaseReference getLatestReference() {
      return _firebaseDatabase.ref("scrape_data/latest");
    }



  @override
    DatabaseReference getCurrentDayDataReference() {
      DateTime now = ukDateTimeNow();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      String url = "scrape_data/${datetimeToDate.format(weekStart)}/data/${now.weekday - 1}";
      return _firebaseDatabase.ref(url);
    }

  @override
    DatabaseReference getPreviousDayDataReference() {
      DateTime now = ukDateTimeNow();
      now = now.subtract(const Duration(days: 1));
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      String url = "scrape_data/${datetimeToDate.format(weekStart)}/data/${now.weekday - 1}";
      return _firebaseDatabase.ref(url);
    }   

  @override
    DatabaseReference getDataReference(DateTime date) {
      final weekStart = date.subtract(Duration(days: date.weekday - 1));
      String url = "scrape_data/${datetimeToDate.format(weekStart)}/data/${date.weekday - 1}";
      return _firebaseDatabase.ref(url);
    }
}
