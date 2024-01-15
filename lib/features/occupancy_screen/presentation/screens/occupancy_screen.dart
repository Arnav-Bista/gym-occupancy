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
              padding: const EdgeInsets.symmetric(
                // horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: 20,
              ),
              child: OccupancyGraph(
                height: constraints.maxHeight * 0.35,
                width: constraints.maxWidth,
              ),
            ),
          ],
        );
      }),
      );
  }
}
