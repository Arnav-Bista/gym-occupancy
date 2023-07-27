import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/app.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_graph_controller.dart';
import 'package:gym_occupancy/firebase_options.dart';
import 'package:shimmer/main.dart';
import 'package:timezone/data/latest.dart' as tz;


final darkThemeProvider = StateProvider((ref) => SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  tz.initializeTimeZones();

  runApp(const ProviderScope(child: App()));
}


