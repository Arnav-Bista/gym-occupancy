import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/app.dart';
import 'package:gym_occupancy/firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tzl;
import 'package:timezone/timezone.dart' as tz;


late StateProvider darkThemeProvider;

void _initialiseThemeProvider() async {
  var settings = await Hive.openBox("settings");
  String? theme = settings.get("theme");
  if(theme == null) {
    switch (SchedulerBinding.instance.platformDispatcher.platformBrightness) {
      case Brightness.dark:
        theme = "dark";
        break;
      case Brightness.light:
        theme = "light";
    }
    settings.put("theme", theme);
  }

  switch (theme) {
    case "light":
      darkThemeProvider = StateProvider((ref) => false);
      break;
    case "dark":
      darkThemeProvider = StateProvider((ref) => true);
    default:
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Anon Auth
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    UserCredential userCredential = await auth.signInAnonymously();
    User? user = userCredential.user;

    // Handle the authenticated user here
    print('Anonymous user ID: ${user?.uid}');
  } catch (e) {
    print('Anonymous sign-in failed: $e');
  }

  await Hive.initFlutter();
  // FirebaseDatabase.instance.setPersistenceEnabled(true);

  tzl.initializeTimeZones();
  await Hive.openBox("settings");
  _initialiseThemeProvider();




  runApp(const ProviderScope(child: App()));
}


