import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/custom_card.dart';
import '../models/goal_model.dart';

class GoalCard extends StatelessWidget {
  final GoalModel goal;
  final ValueChanged<double> onUpdate;
  final VoidCallback onDelete;

  const GoalCard({
    super.key,
    required this.goal,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goal.target > 0
        ? (goal.current / goal.target).clamp(0.0, 1.0)
        : 0.0;
    final pct = (progress * 100).round();
    final color = goal.completed ? AppColors.accent : AppColors.primary;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(goal.title,
                          style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(height: 4.h),
                      Text(
                        '${goal.current.toStringAsFixed(0)} / ${goal.target.toStringAsFixed(0)}',
                        style: TextStyle(
                            fontSize: 13.sp,
                            color: Theme.of(context).textTheme.bodyMedium?.color),
                      ),
                    ],
                  ),
                ),
                if (goal.completed)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text('✅ ${'completed'.tr}',
                        style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600)),
                  )
                else
                  Row(
                    children: [
                      Text('$pct%',
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: color)),
                      SizedBox(width: 8.w),
                      IconButton(
                        icon: Icon(Icons.edit_rounded,
                            size: 18.sp, color: AppColors.primary),
                        onPressed: () => _showUpdateSheet(context),
                      ),
                    ],
                  ),
                IconButton(
                  icon: Icon(Icons.delete_outline_rounded,
                      size: 18.sp, color: AppColors.error),
                  onPressed: onDelete,
                ),
              ],
            ),
            SizedBox(height: 10.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8.h,
                backgroundColor: color.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateSheet(BuildContext context) {
    final ctrl = TextEditingController(text: goal.current.toString());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            20.w, 20.h, 20.w, MediaQuery.of(ctx).viewInsets.bottom + 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('edit'.tr, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 16.h),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'current'.tr),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                final val = double.tryParse(ctrl.text) ?? goal.current;
                onUpdate(val);
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48.h)),
              child: Text('save'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
