import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/main.dart';

class ScheduleEntryHeader extends ConsumerWidget{
  const ScheduleEntryHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            "WeekDay",
            style: Theme.of(context).textTheme.bodyMedium
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            "Opening",
            style: Theme.of(context).textTheme.bodyMedium
          ),
        ),
        Expanded(
          flex: 1,
          child: HookBuilder(builder: (context) {
            final isDarkTheme = ref.watch(darkThemeProvider);
            return Container(
              height: 2, 
              color: isDarkTheme ? Colors.white : Colors.black,
              width: MediaQuery.of(context).size.width * 0.1,
            );
          }),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.1,
        ),
        Expanded(
          flex: 2,
          child: Text(
            "Closing",
            style: Theme.of(context).textTheme.bodyMedium
          ),
        ),
        ],
        );
  }
}
