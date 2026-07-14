import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/stat_tile.dart';

class DailySummaryCard extends StatelessWidget {
  final int caloriesBurned;
  final int caloriesConsumed;
  final double waterLiters;
  final int steps;

  const DailySummaryCard({
    super.key,
    required this.caloriesBurned,
    required this.caloriesConsumed,
    required this.waterLiters,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: 1.4,
      children: [
        StatTile(
          label: 'calories_burned'.tr,
          value: caloriesBurned.toString(),
          unit: 'kcal'.tr,
          icon: Icons.local_fire_department_rounded,
          color: AppColors.secondary,
        ),
        StatTile(
          label: 'calories_consumed'.tr,
          value: caloriesConsumed.toString(),
          unit: 'kcal'.tr,
          icon: Icons.restaurant_rounded,
          color: AppColors.warning,
        ),
        StatTile(
          label: 'water_intake'.tr,
          value: waterLiters.toStringAsFixed(1),
          unit: 'L',
          icon: Icons.water_drop_rounded,
          color: AppColors.primary,
        ),
        StatTile(
          label: 'steps'.tr,
          value: steps.toString(),
          unit: 'steps'.tr,
          icon: Icons.directions_walk_rounded,
          color: AppColors.accent,
        ),
      ],
    );
  }
}
