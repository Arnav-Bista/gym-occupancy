import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/core/functions/text_size.dart';
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
        // Center(
        //   child: Text(
        //     "Schedule",
        //     style: Theme.of(context).textTheme.headlineLarge,
        //   ),
        // ),
      scheduleController.when(
        data: (data) {
          return Display(isLoading: false, first: scheduleFormatter.format(data.$1), last: scheduleFormatter.format(data.$2));
        },
        loading: () {
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
        ScheduleTiming(heading: "Opening", timing: first, isLoading:isLoading),
        HookBuilder(builder: (context) {
          final isDarkTheme = ref.watch(darkThemeProvider);
          return Container(
            height: 2, 
            color: isDarkTheme ? Colors.white : Colors.black,
            width: MediaQuery.of(context).size.width * 0.1,
          );
        }),
        ScheduleTiming(heading: "Closing", timing: last, isLoading: isLoading)
      ],
    );
  }
}

class ScheduleTiming extends StatelessWidget {
  const ScheduleTiming({super.key, required this.heading, required this.timing, required this.isLoading});
  final String heading;
  final String timing;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
  final Size textSize = getTextSize("8:00 AM", Theme.of(context).textTheme.headlineSmall!);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          heading,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        isLoading 
        ? Shimmer.fromColors(
          baseColor: Colors.transparent,
          highlightColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: Container(
            width: textSize.width,
            height: textSize.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey
            )
          ),
          ),
        )
        : Text(
          timing,
          style: Theme.of(context).textTheme.headlineSmall,
        )
      ],
    );
  }
}
