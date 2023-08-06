

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/features/user_settings/infrastructure/theme_repository.dart';
import 'package:gym_occupancy/main.dart';

final themeController = StateNotifierProvider<ThemeController,ThemeMode>((ref) => ThemeController(ref: ref));


class ThemeController extends StateNotifier<ThemeMode> {
  ThemeController({required this.ref}) : super(ThemeMode.system) {
    state = _getThemeRepository().getStoredTheme() ?? _getThemeRepository().getSystemTheme();
  }

  final StateNotifierProviderRef ref;

  IThemeRepository _getThemeRepository() => ref.read(themeRepository);

  void setTheme(ThemeMode mode) {
    state = mode;
    if(mode == ThemeMode.system) {
      switch(_getThemeRepository().getSystemTheme()) {
        case ThemeMode.light:
          ref.read(darkThemeProvider.notifier).state = false;
          break;
        case ThemeMode.dark:
          ref.read(darkThemeProvider.notifier).state = true;
          break;
        default: 
      }
    }
    else {
      ref.read(darkThemeProvider.notifier).state = mode == ThemeMode.dark;
    }
    
    _getThemeRepository().setTheme(ref.read(darkThemeProvider) == true ? Brightness.dark : Brightness.light);

  }


}
