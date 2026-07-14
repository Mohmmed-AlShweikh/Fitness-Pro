import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../features/workouts/models/workout_model.dart';
import '../../../shared/widgets/custom_card.dart';

class TodayWorkoutCard extends StatelessWidget {
  final List<WorkoutModel> workouts;
  final VoidCallback onAdd;

  const TodayWorkoutCard({
    super.key,
    required this.workouts,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return AppCard(
        onTap: onAdd,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.add_rounded, color: AppColors.primary, size: 24.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('no_workout_today'.tr,
                      style: Theme.of(context).textTheme.bodyMedium),
                  SizedBox(height: 4.h),
                  Text('add_workout'.tr,
                      style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: workouts.map((w) => Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: AppCard(
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: _categoryColor(w.category).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.fitness_center_rounded,
                  color: _categoryColor(w.category),
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(w.title, style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(height: 4.h),
                    Text(
                      '${w.duration} ${'min'.tr} · ${w.calories} ${'kcal'.tr}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _categoryColor(w.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  w.category.tr,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: _categoryColor(w.category),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      )).toList(),
    );
  }

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'chest': return AppColors.chest;
      case 'back': return AppColors.back;
      case 'legs': return AppColors.legs;
      case 'arms': return AppColors.arms;
      case 'cardio': return AppColors.cardio;
      default: return AppColors.fullBody;
    }
  }
}
