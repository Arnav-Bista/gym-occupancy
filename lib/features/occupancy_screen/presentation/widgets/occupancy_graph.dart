import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_graph_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/widgets/graph.dart';

class OccupancyGraph extends ConsumerWidget{
  const OccupancyGraph({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(firebaseGraphController);
    List<(DateTime, int)> graphData = [];
    data.when(
      data: (data) {
        graphData = data;
      },
      loading: () {
        graphData = [];
        // return const CircularProgressIndicator();
      },
      error: (error, stacktrace) {
        graphData = [];
        // return const Icon(Icons.error);
      }
    );
    return SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 1,
          child: Graph(data:graphData)
    );
  }
}
