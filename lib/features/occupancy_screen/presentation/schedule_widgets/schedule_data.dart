import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_multi_schedule_controller.dart';
import 'package:gym_occupancy/features/occupancy_screen/application/controllers/firebase_schedule_controller.dart';
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
    final state = ref.watch(firebaseMultiScheduleController);
    return state.when(
      data: (data) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const ScheduleEntryHeader(),
            Divider(
              height: 8,
              thickness: 0,
              indent: MediaQuery.of(context).size.width * 0.1,
              endIndent: MediaQuery.of(context).size.width * 0.1,
            ),
            if (data != null) ...data.map((e) => ScheduleEntry(data: e)),
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
      //TODO better errror
      return Icon(Icons.error, size: MediaQuery.of(context).size.width * 0.6,);
    }
    );
  }
}
