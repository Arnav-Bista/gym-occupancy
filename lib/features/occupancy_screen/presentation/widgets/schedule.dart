import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_schedule_controller.dart';
import 'package:gym_occupancy/main.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class Schedule extends ConsumerWidget{
  Schedule({super.key});

  final DateFormat scheduleFormatter = DateFormat("h:mm a");
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleController = ref.watch(firebaseScheduleController);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Center(
          child: Text(
            "Schedule",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        scheduleController.when(
          data: (data) {
            return Display(isLoading: false, first: scheduleFormatter.format(data.$1), last: scheduleFormatter.format(data.$2));
          },
          loading: () {
            //TODO
            return const Display(isLoading: true, first: "Loading", last: "Loading");
          },
          error: (error, stacktrace) {
            return const Icon(Icons.error);
          }

        )
      ],
      );
  }
}

class Display extends ConsumerWidget {
  const Display({super.key, required this.isLoading, required this.first, required this.last});
  final bool isLoading;
  final String first;
  final String last;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(first, style: Theme.of(context).textTheme.headlineSmall),
        HookBuilder(builder: (context) {
          final isDarkTheme = ref.watch(darkThemeProvider);
          return Container(
            height: 2, 
            color: isDarkTheme ? Colors.white : Colors.black,
            width: MediaQuery.of(context).size.width * 0.1,
          );
        }),
        Text(last, style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}
