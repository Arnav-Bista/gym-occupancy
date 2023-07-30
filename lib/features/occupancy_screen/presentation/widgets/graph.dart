
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_graph_controller.dart';
import 'package:gym_occupancy/main.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Graph extends ConsumerStatefulWidget {
  const Graph({super.key,required this.data});

  final List<(DateTime, int)> data;
  @override
  ConsumerState<Graph> createState() => _GraphState();
}

class _GraphState extends ConsumerState<Graph> {


  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
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
    ref.watch(firebaseController).whenData((newData) {
      final fbgc = ref.read(firebaseGraphController.notifier);
      if (fbgc.old) {
        fbgc.getData();
        return;
      }
      widget.data.add(newData);
    });
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      legend: const Legend(isVisible: false),
      tooltipBehavior: _tooltipBehavior,
      primaryXAxis: DateTimeAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(width: 0),
        minorTickLines: const MinorTickLines(width: 0),
        borderWidth: 0,
        interactiveTooltip: const InteractiveTooltip(enable: true)
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        // maximum: 100
      ),
      series: [
        SplineSeries(
          name: "Occupancy",
          enableTooltip: true,
          animationDelay: 500,
          animationDuration: 500,
          splineType: SplineType.cardinal,
          dataSource:widget.data,
          xValueMapper: (data, _) => data.$1,
          yValueMapper: (data, _) => data.$2,
          pointColorMapper: (data, val) {
            return Color.lerp(Colors.blue, Colors.red, data.$2 / 100);
          } 
        ),
        ],
        );
  }
}
