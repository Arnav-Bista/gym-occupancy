
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/core/functions/uk_datetime.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_graph_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_prediction_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_schedule_controller.dart';
import 'package:gym_occupancy/main.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Graph extends ConsumerStatefulWidget {
  const Graph({super.key,required this.data});

  final List<(int, int)> data;
  @override
  ConsumerState<Graph> createState() => _GraphState();
}

class _GraphState extends ConsumerState<Graph>{


  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;

  int start = 630;
  int end = 2230;

  List<(int,int)>? prediction;

  int convertToNumber(DateTime date) {
    return int.parse(DateFormat("HHmm").format(date));
  }

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

  @override
  Widget build(BuildContext context) {
    // final isDarkTheme = ref.watch(darkThemeProvider);
    final fbgc = ref.watch(firebaseGraphController.notifier);
    ref.watch(firebaseController).whenData((newData) {
      final data = (convertToNumber(newData.$1), newData.$2);
      widget.data.add(data);
    });
    ref.watch(firebaseScheduleController).whenData((value) {
      start = convertToNumber(value.$2);
      end = convertToNumber(value.$3);
    });
    ref.watch(firebasePredictionController).whenData((value) {
      prediction = value;
    });
    return SfCartesianChart(
      zoomPanBehavior: _zoomPanBehavior,
      plotAreaBorderWidth: 0,
      legend: const Legend(
        isVisible: true,
        position: LegendPosition.bottom
        ),
      tooltipBehavior: _tooltipBehavior,
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
      series: <ChartSeries>[
        LineSeries(
          // markerSettings: MarkerSettings(isVisible: true),
          isVisibleInLegend: true,
          name: "Occupancy",
          enableTooltip: true,
          animationDelay: 500,
          animationDuration: 800,
          // splineType: SplineType.clamped,
          dataSource:widget.data,
          xValueMapper: (data, _) => data.$1,
          yValueMapper: (data, _) => data.$2,
          pointColorMapper: (data, val) {
            return Color.lerp(Theme.of(context).colorScheme.primary, Colors.red, data.$2 / 100);
          } 
        ),
        LineSeries(
          markerSettings: const MarkerSettings(isVisible: true),
          isVisibleInLegend: false,
          name: "Occupancy",
          enableTooltip: false,
          animationDelay: 500,
          animationDuration: 800,
          // splineType: SplineType.natural,
          dataSource:[widget.data.last],
          xValueMapper: (data, _) => data.$1,
          yValueMapper: (data, _) => data.$2,
          pointColorMapper: (data, val) {
            return Color.lerp(Theme.of(context).colorScheme.primary, Colors.red, data.$2 / 100);
          } 
        ),
        LineSeries(
          isVisibleInLegend: true,
          // dashArray:  const <double>[2, 5],
          name: "Prediction",
          enableTooltip: false,
          animationDelay: 500,
          animationDuration: 800,
          opacity: 0.5,
          dataSource: prediction ?? [],
          xValueMapper: (data, _) => data.$1,
          yValueMapper: (data, _) => data.$2,
          color: Colors.blueGrey
        ),
      ],
      );
  }
}
