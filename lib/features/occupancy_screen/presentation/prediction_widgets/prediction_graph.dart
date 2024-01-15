import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/core/functions/uk_datetime.dart';
import 'package:gym_occupancy/core/widgets/custom_shimmer.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_prediction_tomorrow_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_schedule_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/infrastructure/models/schedule_model.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/widgets/generic_graph.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PredictionGraph extends ConsumerStatefulWidget {
  const PredictionGraph({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  ConsumerState<PredictionGraph> createState() => _PredictionGraphState();
}

class _PredictionGraphState extends ConsumerState<PredictionGraph> {
  int start = 600;
  int end = 2230;

  @override
  void initState() {
    super.initState();
  }

  void setTimings(ScheduleModel sm) {
    final now = ukDateTimeNow().add(const Duration(days: 1));
    if (!sm.data[now.weekday - 1].$1) {
      return;
    }
    start = sm.data[now.weekday - 1].$2;
    end = sm.data[now.weekday - 1].$3;
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(firebasePredictionTomorrowController);
    ScheduleModel sm =
        ref.watch(firebaseScheduleController.notifier).getAllSchedule();

    setTimings(sm);

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: controller.when(
        data: (data) {
          return GenericGraph(start: start, end: end, data: data);
        },
        loading: () => CustomShimmer(height: widget.height, width: widget.width, padding: 10),
        error: (stack, err) => const Icon(Icons.error),
      ),
    );
  }
}
