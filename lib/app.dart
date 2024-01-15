import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/screen_manager.dart';
import 'package:gym_occupancy/main.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  ThemeData buildTheme(bool isDarkTheme) {
    var baseTheme = ThemeData(
      colorSchemeSeed: const Color(0xFF29335C),
      useMaterial3: true,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
    );
    return baseTheme.copyWith(
      textTheme: GoogleFonts.latoTextTheme(
        baseTheme.textTheme
      )
    );
  }

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  
  @override
  Widget build(BuildContext context) {
    final darkTheme = ref.watch(darkThemeProvider);
    return MaterialApp(
      theme: widget.buildTheme(darkTheme),
      home: const ScreenManager()
    );
  }
}
