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
    return const Column(
      children: [
        OccupancyGraph(),
        PredictionGraph(),
      ],
    );
  }
}
