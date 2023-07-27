import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/main.dart';

class ThemeChangeButton extends ConsumerStatefulWidget {
  const ThemeChangeButton({super.key});

  @override
  ConsumerState<ThemeChangeButton> createState() => _ThemeChangeButtonState();
}

class _ThemeChangeButtonState extends ConsumerState<ThemeChangeButton> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.read(darkThemeProvider.notifier);
    return TextButton(
      child: isDarkMode.state ? const Icon(Icons.dark_mode) : const Icon(Icons.light_mode),
      onPressed: () {
        isDarkMode.state = !isDarkMode.state;
        setState(() {});
      },
    );
  }
}
