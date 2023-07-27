import 'package:timezone/timezone.dart' as tz;

final _uk = tz.getLocation("Europe/London");

DateTime ukDateTimeNow() {
  return tz.TZDateTime.now(_uk);
}

DateTime ukDateTimeParse(String date) {
  return tz.TZDateTime.parse(_uk, date);
}

