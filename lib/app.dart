import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:gym_occupancy/features/occupancy_screen/occupancy_screen.dart';
import 'package:gym_occupancy/main.dart';


class App extends ConsumerStatefulWidget {
  const App({super.key});

  ThemeData buildTheme(bool isDarkTheme) {
    var baseTheme = ThemeData(
      colorSchemeSeed: const Color(0xFF29335C),
      useMaterial3: true,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light
    );
    return baseTheme;
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
      home: OccupancyScreen(),
    );
  }
}
