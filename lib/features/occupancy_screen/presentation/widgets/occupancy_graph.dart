import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_graph_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/widgets/graph.dart';

class OccupancyGraph extends ConsumerWidget{
  const OccupancyGraph({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(firebaseGraphController);
    return data.when(
      data: (data) {
        return SizedBox(
          height: 200,
          width: 500,
          child: Graph(data:data)
        );
      },
      loading: () {
        return const CircularProgressIndicator();
      },
      error: (error, stacktrace) {
        return const Icon(Icons.error);
      }
    );
  }
}
