import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/core/widgets/custom_shimmer.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_graph_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/widgets/graph.dart';
import 'package:shimmer/shimmer.dart';

class OccupancyGraph extends ConsumerWidget{
  const OccupancyGraph({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(firebaseGraphController);
    final height= MediaQuery.of(context).size.height * 0.25;
    final width= MediaQuery.of(context).size.width * 1;
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
