import 'package:flutter/material.dart';
import 'package:gym_occupancy/features/user_settings/presentation/widgets/theme_changer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        centerTitle: true,
        title: const Text("Settings"),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ThemeChanger()
        ],
      ),
    );
  }
}
