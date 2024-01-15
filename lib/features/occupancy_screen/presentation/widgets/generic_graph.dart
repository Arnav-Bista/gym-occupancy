import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GenericGraph extends StatelessWidget {
  GenericGraph(
      {super.key,
      required this.start,
      required this.end,
      required this.data,
      this.prediction});

  int start;
  int end;

  List<(int, int)> data;
  List<(int, int)>? prediction;

  final int threshold = 75;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final onBackground = Theme.of(context).colorScheme.onBackground;

    int maximumOccupancy = data.fold(
        0, (previousValue, element) => max(previousValue, element.$2));
    return LineChart(
      LineChartData(
          lineTouchData: LineTouchData(
            enabled: true,
            getTouchedSpotIndicator:
                (LineChartBarData barData, List<int> indicators) {
              return indicators.map(
                (int index) {
                  return TouchedSpotIndicatorData(
                    FlLine(
                        color: Colors.grey[700],
                        strokeWidth: 1,
                        dashArray: [4, 4]),
                    const FlDotData(show: true),
                  );
                },
              ).toList();
            },
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Theme.of(context).colorScheme.surface,
              tooltipBorder: BorderSide(width: 1.25, color: onSurface),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((e) {
                  return LineTooltipItem(
                    e.barIndex == 0
                        ? "Occpuancy:\t${e.y.toInt()}"
                        : "Prediction:\t${e.y.toInt()}",
                    TextStyle(
                      color: onSurface,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          minX: start.toDouble(),
          maxX: end.toDouble(),
          minY: 0,
          maxY: 100,
          borderData: FlBorderData(
            show: true,
            border: Border(
              top: BorderSide(width: 0.3, color: onBackground),
              right: BorderSide(width: 0.3, color: onBackground),
              bottom: BorderSide(width: 1, color: onBackground),
              left: BorderSide(width: 1, color: onBackground),
            ),
          ),
          gridData: const FlGridData(
              show: true,
              drawVerticalLine: true,
              drawHorizontalLine: true,
              verticalInterval: 350,
              horizontalInterval: 20),
          titlesData: FlTitlesData(
            show: true,
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(
                axisNameWidget: Text("Occupancy %"),
                sideTitles: SideTitles(
                    showTitles: true, reservedSize: 33, interval: 20)),
            bottomTitles: AxisTitles(
              axisNameWidget: const Text("Time"),
              sideTitles: SideTitles(
                reservedSize: 30,
                showTitles: true,
                interval: 350,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(value.toInt().toString()),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
                spots: [
                  ...data.map((e) => FlSpot(e.$1.toDouble(), e.$2.toDouble()))
                ],
                barWidth: 2,
                isCurved: true,
                dotData: const FlDotData(show: false),
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [
                      maximumOccupancy > threshold
                          ? threshold / maximumOccupancy
                          : 1,
                      1
                    ],
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.error
                    ])),
            LineChartBarData(
              spots: prediction != null
                  ? [
                      ...prediction!
                          .map((e) => FlSpot(e.$1.toDouble(), e.$2.toDouble()))
                    ]
                  : [],
              barWidth: 1.5,
              isCurved: true,
              dotData: const FlDotData(show: false),
              color: Colors.grey[600],
            )
          ]),
    );
  }
}
