import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/features/user_settings/application/controllers/theme_controller.dart';


class ThemeChanger extends ConsumerWidget{
  const ThemeChanger({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Card(
        elevation: 2,
        child: SizedBox(
          // height: cardHeight,
          width:  MediaQuery.of(context).size.width * 0.9,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Column(
            children: [
              Center(
                child: Text(
                  "Theme",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Divider(
                endIndent: MediaQuery.of(context).size.width * 0.1,
                indent: MediaQuery.of(context).size.width * 0.1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...ThemeMode.values.map((mode) {
                    return ThemeButton(base: mode);
                  }),
                ],
              ),
            ],
            ),
            ),
            ),
            ),
            );
  }
}

class ThemeButton extends ConsumerWidget{
  const ThemeButton({super.key, required this.base});

  final ThemeMode base;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String name = switch (base) {
      ThemeMode.light => "Light",
      ThemeMode.dark => "Dark",
      ThemeMode.system => "System"
    };

    final theme = ref.watch(themeController);
    final notifier = ref.watch(themeController.notifier);
    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 100),
      decoration:  BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 10,
          color: theme == base ? Theme.of(context).colorScheme.primary : Colors.transparent
        )
      ),
      child:   InkWell(
        onTap: () {
          notifier.setTheme(base);
        },
        child: SizedBox(
                 width: MediaQuery.of(context).size.width * 0.2,
                 height: MediaQuery.of(context).size.height * 0.15,
                 child: Padding(
                   padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                   child: Column(
                     crossAxisAlignment:  CrossAxisAlignment.center,
                     children: [
                       Text(name),
                       Expanded(
                         child:
                         Icon(
                           switch (base) {
                             ThemeMode.system => Icons.brightness_6,
                             ThemeMode.light => Icons.light_mode,
                             ThemeMode.dark => Icons.dark_mode
                           }
                         ),
                       )
                     ],
                   ),
                 ),
                 ),
                 ),
                 );

  }
}
