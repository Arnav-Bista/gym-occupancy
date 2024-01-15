import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_schedule_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/infrastructure/models/schedule_model.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/schedule_widgets/schedule_entry.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/schedule_widgets/schedule_entry_header.dart';
import 'package:shimmer/shimmer.dart';

class ScheduleData extends ConsumerStatefulWidget {
  const ScheduleData({super.key, required this.date});

  final DateTime date;

  @override
  ConsumerState<ScheduleData> createState() => _ScheduleDataState();
}

class _ScheduleDataState extends ConsumerState<ScheduleData> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(firebaseScheduleController);
    final controller = ref.watch(firebaseScheduleController.notifier);
    return state.when(
      data: (_) {
        ScheduleModel data = controller.getAllSchedule();
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const ScheduleEntryHeader(),
            Divider(
              height: 8,
              thickness: 0,
              indent: MediaQuery.of(context).size.width * 0.1,
              endIndent: MediaQuery.of(context).size.width * 0.1,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(data.data.length, (index) => ScheduleEntry(data: data.getEntry(index), index: index)),
            )
          ],
        );
      },
    loading: () {
      return Shimmer.fromColors(
        baseColor: Colors.transparent,
        highlightColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10)
            ),
          ),
        ),
      );
    },
    error: (error, stackTrace) {
      return Icon(Icons.error, size: MediaQuery.of(context).size.width * 0.6);
    }
    );
  }
}
