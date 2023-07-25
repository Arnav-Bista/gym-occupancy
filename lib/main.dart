import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_occupancy/features/occupancy_screen/infrastructure/repositories/network_repository.dart';
import 'package:gym_occupancy/features/occupancy_screen/occupancy_screen.dart';
import 'package:gym_occupancy/firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final n = NetworkRepository();
      n.scrape();
  // runApp(ProviderScope(child: MyApp()));
}


class MyApp extends ConsumerWidget{
  const MyApp({super.key});

  ThemeData _buildTheme() {
    var baseTheme = ThemeData(
      colorSchemeSeed: const Color(0xFF29335C),
      useMaterial3: true,
      textTheme: GoogleFonts.dmSansTextTheme()
    );
    return baseTheme;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: _buildTheme(),
      home: OccupancyScreen(),
    );
  }
}
