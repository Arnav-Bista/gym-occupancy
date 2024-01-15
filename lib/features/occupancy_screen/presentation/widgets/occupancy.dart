import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/core/widgets/custom_shimmer.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_graph_controller.dart';
import 'package:gym_occupancy/main.dart';

enum DataState { data, loading, error }

class Occupancy extends ConsumerStatefulWidget {
  const Occupancy({super.key});

  @override
  ConsumerState<Occupancy> createState() => _OccupancyState();
}

class _OccupancyState extends ConsumerState<Occupancy>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(firebaseGraphController.notifier).getData();
        ref.read(firebaseController.notifier).addListenerToLatest();
      default:
        ref.read(firebaseController.notifier).removeListenerToLatest();
    }
  }

  DataState state = DataState.loading;

  @override
  Widget build(BuildContext context) {
    late (DateTime, int) renderData;

    ref.watch(firebaseController).when(data: (data) {
      renderData = data;
      state = DataState.data;
    }, loading: () {
      state = DataState.loading;
    }, error: (error, stacktrace) {
      state = DataState.error;
    });

    return Padding(
      padding: const EdgeInsets.all(10),
      child: LayoutBuilder(builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxWidth,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                fit: StackFit.loose,
                children: [
                  SizedBox(
                      height: min(constraints.maxHeight, constraints.maxWidth),
                      width: min(constraints.maxHeight, constraints.maxWidth),
                      child: switch (state) {
                        DataState.loading => Builder(builder: (context) {
                            final isDarkMode = ref.watch(darkThemeProvider);
                            return CircularProgressIndicator(
                                strokeWidth: 10,
                                color: isDarkMode
                                    ? const Color(0xFF808080)
                                    : const Color(0x60808080));
                          }),
                        DataState.data => HookBuilder(builder: (context) {
                            final isDarkMode = ref.watch(darkThemeProvider);
                            return CircularProgressIndicator(
                                value: renderData.$2.toDouble() / 100,
                                strokeWidth: 10,
                                backgroundColor: isDarkMode
                                    ? const Color(0x20808080)
                                    : const Color(0x10000000));
                          }),
                        DataState.error => const CircularProgressIndicator(
                            value: 1, strokeWidth: 10)
                      }),
                  Container(
                    height: min(constraints.maxWidth, constraints.maxHeight),
                    padding: EdgeInsets.all(
                        min(constraints.maxWidth, constraints.maxHeight) *
                            0.25),
                    child: switch (state) {
                      DataState.data => FittedBox(
                          child: NumberDisplay(
                              key: ValueKey(renderData), number: renderData.$2),
                        ),
                      DataState.loading => CustomShimmer(
                          height:
                              min(constraints.maxHeight, constraints.maxWidth),
                          width:
                              min(constraints.maxHeight, constraints.maxWidth),
                          padding: 20,
                          borderRadius: 100,
                        ),
                      DataState.error => const Icon(Icons.error)
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

class NumberDisplay extends StatelessWidget {
  const NumberDisplay({super.key, required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return Text("$number%",
        style: Theme.of(context)
            .textTheme
            .headlineLarge
            ?.copyWith(fontWeight: FontWeight.bold));
  }
}
