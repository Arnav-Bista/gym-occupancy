import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/core/widgets/theme_change_button.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_graph_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_schedule_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/widgets/occupancy.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/widgets/occupancy_graph.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/widgets/schedule.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/widgets/timer.dart';
import 'package:intl/intl.dart';

class OccupancyScreen extends ConsumerWidget {
  const OccupancyScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          ThemeChangeButton()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Schedule(),
            Center(
              child: Occupancy(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1, 
                vertical: 20
                ),
              child: OccupancyGraph()
            ),
          ],
        ),
      )
    );
  }
}
