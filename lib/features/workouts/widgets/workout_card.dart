import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/custom_card.dart';
import '../models/workout_model.dart';

class WorkoutCard extends StatelessWidget {
  final WorkoutModel workout;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const WorkoutCard({
    super.key,
    required this.workout,
    required this.onTap,
    required this.onDelete,
  });

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

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor(workout.category);
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(Icons.fitness_center_rounded, color: color, size: 24.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(workout.title, style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    _chip(context, '${workout.duration} ${'min'.tr}', Icons.timer_outlined, color),
                    SizedBox(width: 8.w),
                    _chip(context, '${workout.calories} ${'kcal'.tr}', Icons.local_fire_department_outlined, AppColors.secondary),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  DateFormat('MMM d, yyyy').format(workout.date),
                  style: TextStyle(fontSize: 11.sp, color: Theme.of(context).textTheme.bodyMedium?.color),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20.sp),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String text, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 12.sp, color: color),
        SizedBox(width: 3.w),
        Text(text, style: TextStyle(fontSize: 11.sp, color: color, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
