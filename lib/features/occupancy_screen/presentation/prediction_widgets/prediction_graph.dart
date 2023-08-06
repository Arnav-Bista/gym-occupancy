import 'package:flutter/material.dart';
import 'package:gym_occupancy/core/widgets/custom_shimmer.dart';

class PredictionGraph extends StatefulWidget {
  const PredictionGraph({super.key, required this.date});
  final DateTime date;

  @override
  State<PredictionGraph> createState() => _PredictionGraphState();
}

class _PredictionGraphState extends State<PredictionGraph> {


  
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.15;
    final width = MediaQuery.of(context).size.width * 0.9;
    return CustomShimmer(height: height, width: width, padding: 10);
  }
}
