import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_occupancy/main.dart';
import 'package:shimmer/shimmer.dart';
class CustomShimmer extends ConsumerWidget{
  const CustomShimmer({super.key, required this.height, required this.width, required this.padding, this.borderRadius});
  final double height;
  final double width;
  final int padding;
  final double? borderRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(darkThemeProvider);
    return 
        Shimmer.fromColors(
          period: const Duration(milliseconds: 800),
          baseColor: Colors.grey,
          highlightColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(padding.toDouble()),
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius ?? 5),
                color: isDarkTheme ? const Color(0x80202020) : const Color(0x80808080)
              ),
            ),
          ),
        );
  }
}
