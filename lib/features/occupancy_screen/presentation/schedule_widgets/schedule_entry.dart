import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/core/functions/get_day_name.dart';
import 'package:gym_occupancy/main.dart';
import 'package:intl/intl.dart';

class ScheduleEntry extends ConsumerWidget{
  ScheduleEntry({super.key, required this.data, required this.index});

  final (bool,DateTime,DateTime) data;
  final int index;

  final DateFormat timeFormatter = DateFormat("h:mm a");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            getDayName(index),
            style: Theme.of(context).textTheme.bodyMedium
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            timeFormatter.format(data.$2),
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
            timeFormatter.format(data.$3),
            style: Theme.of(context).textTheme.bodyMedium
          ),
        ),
        ],
        );
  }
}
