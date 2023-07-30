import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/core/functions/text_size.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_graph_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/widgets/timer.dart';
import 'package:gym_occupancy/main.dart';
import 'package:shimmer/shimmer.dart';


enum DataState {data, loading, error}

class Occupancy extends ConsumerWidget {
  Occupancy({super.key});

  DataState state = DataState.loading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fbController = ref.watch(firebaseController);
    final size = MediaQuery.of(context).size.width * 0.5;
    final extra = MediaQuery.of(context).size.width * 0.12;
    final height = MediaQuery.of(context).size.height * 0.5;
    final Size lastUpdatedTextSize = getTextSize("Last updated XX hours and XX seconds ago", Theme.of(context).textTheme.bodyMedium!);
    late (DateTime, int) renderData;
    fbController.when(
      data: (data) {
        renderData = data;
        state = DataState.data;
      },
      loading: () {
        state = DataState.loading;
      },
      error: (error, stacktrace) {
        state = DataState.error;
      }
    );

    return 
        SizedBox(
          height: height,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                fit: StackFit.loose,
                children: [
                  SizedBox(
                    height: size + extra,
                    width: size + extra,
                    child: switch (state) {
                      DataState.loading => const CircularProgressIndicator(strokeWidth: 10),
                      DataState.data => 
                          HookBuilder(builder: (context) {
                            final isDarkMode = ref.watch(darkThemeProvider);
                            return CircularProgressIndicator(
                              value: renderData.$2.toDouble() / 100, 
                              strokeWidth: 10, 
                              backgroundColor: isDarkMode ? const Color(0x20808080) : const Color(0x10000000)
                            );
                          }),
                      DataState.error => const CircularProgressIndicator(value: 1, strokeWidth:  10)
                    }
                  ),
                  Padding(
                    padding: const EdgeInsets.all(100),
                    child: SizedBox(
                      height: size,
                      width: size,
                      child: switch (state) {
                        DataState.data => 
                            FittedBox(
                              child: Text(
                                "${renderData.$2}%",
                                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.bold
                                )
                              ),
                            ),
                        DataState.loading =>
                            Shimmer.fromColors(
                              baseColor: Colors.transparent,
                              highlightColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                        DataState.error => const Icon(Icons.error)
                      },
                      ),
                      ),
                      ],
                      ),
                      switch (state) {
                        DataState.data => 
                            TimerWidget(key: ValueKey(renderData), startDate: renderData.$1),
                        DataState.loading => 
                            Shimmer.fromColors(
                              baseColor: Colors.transparent,
                              highlightColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(1),
                                child: Container(
                                  width: lastUpdatedTextSize.width,
                                  height: lastUpdatedTextSize.height,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(5)
                                  )
                                )
                              )
                            ),
                        DataState.error => 
                            const Icon(Icons.error)
                      },
                        ],
                        ),
                        );
  }
}
