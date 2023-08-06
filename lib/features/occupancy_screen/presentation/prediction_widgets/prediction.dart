import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gym_occupancy/core/functions/uk_datetime.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/prediction_widgets/prediction_graph.dart';



// Previous + Prediction
// Current + Prediction
// Tomorrow Prediction
class Prediction extends StatelessWidget {
  const Prediction({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PredictionGraph(date: ukDateTimeNow().subtract(const Duration(days: 1))),
        PredictionGraph(date: ukDateTimeNow()),
        PredictionGraph(date: ukDateTimeNow().add(const Duration(days: 1))),
      ],
    );
  }
}
