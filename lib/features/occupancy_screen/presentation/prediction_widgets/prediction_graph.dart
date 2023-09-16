import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/core/functions/uk_datetime.dart';
import 'package:gym_occupancy/core/widgets/custom_shimmer.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_prediction_tomorrow_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_schedule_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/infrastructure/models/schedule_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PredictionGraph extends ConsumerStatefulWidget {
  const PredictionGraph({super.key});


  @override
  ConsumerState<PredictionGraph> createState() => _PredictionGraphState();
}

class _PredictionGraphState extends ConsumerState<PredictionGraph> {

  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;

  int start = 600;
  int end = 2230;

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
    );
    _tooltipBehavior = TooltipBehavior(
      enable: true, 
      canShowMarker: false,
      opacity: 0.8,
      // format: 'point.x  point.y %'
    );
    super.initState();
  }

  void setTimings(ScheduleModel sm) {
    final now = ukDateTimeNow().add(const Duration(days: 1));
    if(!sm.data[now.weekday - 1].$1) {
      return;
    }
    start = sm.data[now.weekday - 1].$2;
    end = sm.data[now.weekday - 1].$3;
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(firebasePredictionTomorrowController);
    ScheduleModel sm =  ref.watch(firebaseScheduleController.notifier).getAllSchedule();

    setTimings(sm);

    final height = MediaQuery.of(context).size.height * 0.30;
    final width = MediaQuery.of(context).size.width * 0.9;

    return SizedBox(
      height: height,
      width: width,
      child: controller.when(
      data: (data) {
        return SfCartesianChart(
          zoomPanBehavior: _zoomPanBehavior,
          tooltipBehavior: _tooltipBehavior,
      legend: const Legend(
        isVisible: true,
        position: LegendPosition.bottom
        ),
          primaryXAxis: NumericAxis(
            majorGridLines: const MajorGridLines(width: 0),
            minimum: start.toDouble(),
            maximum: end.toDouble(),
            // interval: widget.data.last.$1 - widget.data.first.$1 > 300 ? 300 : null
            // interval: 300
          ),
          primaryYAxis: NumericAxis(
            // majorTickLines: MajorTickLines(width: 0),
            // minorTickLines: MinorTickLines(width: 0),
            // axisLine: AxisLine(width: 0),
            majorGridLines: const MajorGridLines(dashArray: [10,10]),
            minimum: 0,
            maximum: 100,
            interval: 20
          ),
          series: [
            LineSeries(
              name: "Tomorrow's Prediction",
              enableTooltip: true,
              animationDelay: 500,
              animationDuration: 800,
              dataSource: data,
              xValueMapper: (data, _) => data.$1,
              yValueMapper: (data, _) => data.$2,
              pointColorMapper: (data, val) {
                return Color.lerp(Theme.of(context).colorScheme.primary, Colors.red, data.$2 / 100);
              } 

            ),
          ],
          );
      },
    loading: () => CustomShimmer(height: height, width: width, padding: 10),
    error: (stack, err) => const Icon(Icons.error),
    )
    );
  }
}

