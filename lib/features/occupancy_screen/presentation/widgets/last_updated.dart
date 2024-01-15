import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/core/functions/text_size.dart';
import 'package:gym_occupancy/core/widgets/custom_shimmer.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/widgets/occupancy.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/widgets/timer.dart';

class LastUpdated extends ConsumerWidget {
  LastUpdated({super.key});

  DataState state = DataState.loading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late (DateTime, int) renderData;

    final Size lastUpdatedTextSize = getTextSize(
        "Last updated XX hours and XX seconds ago",
        Theme.of(context).textTheme.bodyMedium!);

    ref.watch(firebaseController).when(data: (data) {
      renderData = data;
      state = DataState.data;
    }, loading: () {
      state = DataState.loading;
    }, error: (error, stacktrace) {
      state = DataState.error;
    });

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: switch (state) {
        DataState.data =>
          TimerWidget(key: ValueKey(renderData), startDate: renderData.$1),
        DataState.loading => CustomShimmer(
            height: lastUpdatedTextSize.height,
            width: lastUpdatedTextSize.width,
            padding: 1,
          ),
        DataState.error => const Icon(Icons.error)
      },
    );
  }
}
