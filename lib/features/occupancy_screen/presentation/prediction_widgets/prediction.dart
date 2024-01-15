import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gym_occupancy/core/functions/uk_datetime.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/prediction_widgets/prediction_graph.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/widgets/occupancy_graph.dart';

// Previous + Prediction
// Current + Prediction
// Tomorrow Prediction
class Prediction extends StatelessWidget {
  const Prediction({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            "Today's Occupancy and Prediction",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        OccupancyGraph(
            height: MediaQuery.of(context).size.height * 0.23,
            width: MediaQuery.of(context).size.width * 0.9
            ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            "Tomorrow's Prediction",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        PredictionGraph(
            height: MediaQuery.of(context).size.height * 0.23,
            width: MediaQuery.of(context).size.width * 0.9
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
