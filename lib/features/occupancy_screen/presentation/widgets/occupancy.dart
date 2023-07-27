import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/widgets/timer.dart';

class Occupancy extends ConsumerWidget {
  const Occupancy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fbController = ref.watch(firebaseController);
    final size = MediaQuery.of(context).size.width * 0.5;
    final extra = MediaQuery.of(context).size.width * 0.12;
    return fbController.when(
      data: (data) {
        return Column(
          children: [
            Stack(
              alignment: Alignment.center,
              fit: StackFit.loose,
              children: [
                SizedBox(
                  height: size + extra,
                  width: size + extra,
                  child: CircularProgressIndicator(value: data.$2.toDouble() / 100, strokeWidth: 10),
                ),
                Padding(
                  padding: const EdgeInsets.all(100),
                  child: SizedBox(
                    height: size,
                    width: size,
                    child: FittedBox(
                      child: Text(
                        "${data.$2}%",
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ),
                  ),
                ),
                ],
                ),
                TimerWidget(key: ValueKey(data), startDate: data.$1)
                ],
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
