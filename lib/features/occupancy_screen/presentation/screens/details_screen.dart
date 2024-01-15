import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/core/functions/uk_datetime.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/prediction_widgets/prediction.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/schedule_widgets/schedule_data.dart';
import 'package:intl/intl.dart';

class DetailsScreen extends ConsumerStatefulWidget {
  const DetailsScreen({super.key});

  @override
  ConsumerState<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends ConsumerState<DetailsScreen> {

  DateFormat titleFormatter = DateFormat("dd EEE MMM yyyy");


  @override
  Widget build(BuildContext context) {
    DateTime date = ukDateTimeNow();
    date = date.subtract(Duration(days: - date.weekday + 1));
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment:  CrossAxisAlignment.center,
            mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: Text("Week starting ${titleFormatter.format(date)}", style: Theme.of(context).textTheme.bodyLarge),
              ),
              Divider(
                indent: MediaQuery.of(context).size.width * 0.02,
                endIndent: MediaQuery.of(context).size.width * 0.02
              ),
              ScheduleData(date: date),
              const Divider(),
              const Prediction()
            ],
          ),
        );
  }
}
