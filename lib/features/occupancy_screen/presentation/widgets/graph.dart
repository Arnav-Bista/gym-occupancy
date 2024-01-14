import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_graph_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_prediction_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_schedule_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/widgets/generic_graph.dart';
import 'package:intl/intl.dart';

class Graph extends ConsumerStatefulWidget {
  const Graph({super.key, required this.data});

  final List<(int, int)> data;
  @override
  ConsumerState<Graph> createState() => _GraphState();
}

class _GraphState extends ConsumerState<Graph> {
  int start = 630;
  int end = 2230;
  final int threshold = 75;

  int maximumOccupancy = 0;

  List<(int, int)>? prediction;

  int convertToNumber(DateTime date) {
    return int.parse(DateFormat("HHmm").format(date));
  }

  @override
  void initState() {
    maximumOccupancy = widget.data
        .fold(0, (previousValue, element) => max(previousValue, element.$2));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final isDarkTheme = ref.watch(darkThemeProvider);
    final fbgc = ref.watch(firebaseGraphController.notifier);
    ref.watch(firebaseController).whenData((newData) {
      final data = (convertToNumber(newData.$1), newData.$2);
      maximumOccupancy = max(maximumOccupancy, data.$2);
      widget.data.add(data);
    });
    ref.watch(firebaseScheduleController).whenData((value) {
      start = convertToNumber(value.$2);
      end = convertToNumber(value.$3);
    });
    ref.watch(firebasePredictionController).whenData((value) {
      prediction = value;
    });

    return GenericGraph(start: start, end: end, data: widget.data, prediction: prediction);
  }
}
