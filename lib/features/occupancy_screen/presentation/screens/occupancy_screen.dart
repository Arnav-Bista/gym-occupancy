import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/widgets/last_updated.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/widgets/occupancy.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/widgets/occupancy_graph.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/widgets/schedule.dart';

class OccupancyScreen extends ConsumerWidget {
  const OccupancyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            Schedule(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight * 0.4,
                child: const Occupancy(),
              ),
            ),
            LastUpdated(),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                "Today's Occupancy and Prediction",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: OccupancyGraph(
                height: constraints.maxHeight * 0.30,
                width: constraints.maxWidth,
              ),
            ),
          ],
        );
      }),
    );
  }
}
