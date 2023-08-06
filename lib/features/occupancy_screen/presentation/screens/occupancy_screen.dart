import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/widgets/occupancy.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/widgets/occupancy_graph.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/widgets/schedule.dart';

class OccupancyScreen extends ConsumerWidget {
  const OccupancyScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return 
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Schedule(),
              const Center(
                child: Occupancy(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05, 
                  vertical: 10
                ),
                child: const OccupancyGraph()
              ),
            ],
          ),
        );
  }
}
