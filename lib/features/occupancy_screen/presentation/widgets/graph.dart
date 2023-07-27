import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Graph extends StatefulWidget {
  const Graph({super.key, required this.data});

  final List<(DateTime,int)> data;

  @override
  State<Graph> createState() => _GraphState();
}
class _GraphState extends State<Graph> {

  DateFormat dateFormat = DateFormat("HH:mm");

  Widget getBottomTileWidget(double value, TitleMeta meta) {
    return Text(
      dateFormat.format(widget.data[value.toInt()].$1),
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  AxisTitles noShow = const AxisTitles(sideTitles: SideTitles(showTitles: false));

  @override
  Widget build(BuildContext context) {
    int index = -1;
    return LineChart(
      LineChartData(
        minY: 0,
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: noShow,
          topTitles: noShow,
          rightTitles: noShow,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 10,
              getTitlesWidget: getBottomTileWidget
            )
          )
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            dotData: const FlDotData(show: false),
            isStrokeCapRound: true,
            isCurved: true,
            shadow: const Shadow(color: Colors.grey),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue
            ),
            spots: [
              ...widget.data.map((e) {
                index += 1;
                return FlSpot(
                  index.toDouble(),
                  e.$2.toDouble(),
                );
              }),
            ]
          )
        ]
        ),
    );
  }
}
