import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/core/widgets/custom_shimmer.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_graph_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/widgets/graph.dart';

class OccupancyGraph extends ConsumerWidget{
  const OccupancyGraph({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(firebaseGraphController);

    return 
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: data.when(
            data: (data) {
              return SizedBox(
                key: const ValueKey(0),
                height: height,
                width: width,
                child: Graph(data: data)
              );
            },
            loading: () {
              return CustomShimmer(
                key: const ValueKey(1),
                height:  height,
                width: width,
                padding: 1,
              );
              // return const CircularProgressIndicator();
            },
            error: (error, stacktrace) {
              return CustomShimmer(
                height:  height,
                width: width,
                padding: 1,
              );
            }
    ),
    );
  }
}
