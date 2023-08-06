
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final themeRepository = Provider<IThemeRepository>((ref) => ThemeRepository());

abstract class IThemeRepository {
  ThemeMode getSystemTheme();
  ThemeMode? getStoredTheme();
  void setTheme(Brightness brightness);
}


class ThemeRepository extends IThemeRepository {

  final box = Hive.box("settings");

  @override
  ThemeMode getSystemTheme() {
    return switch (SchedulerBinding.instance.platformDispatcher.platformBrightness) {
      Brightness.light => ThemeMode.light,
      Brightness.dark => ThemeMode.dark
    };
  }

  @override
  ThemeMode? getStoredTheme() {
    String? value = box.get("theme");
    return switch(value) {
      "light" => ThemeMode.light,
      "dark" => ThemeMode.dark,
      _ => null
    };
  }

  @override
  void setTheme(Brightness brightness) {
    switch (brightness) {
      case Brightness.light:
        box.put("theme", "light");
        break;
      case Brightness.dark:
        box.put("theme", "dark");
        break;
      default:
    }
  }


}
