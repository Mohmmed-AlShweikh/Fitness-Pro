import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/custom_card.dart';

class ProgressCircleWidget extends StatelessWidget {
  final double percent;

  const ProgressCircleWidget({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    final pct = (percent * 100).round();
    return GradientCard(
      colors: AppColors.gradientPrimary,
      child: Row(
        children: [
          SizedBox(
            width: 80.w,
            height: 80.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80.w,
                  height: 80.w,
                  child: CircularProgressIndicator(
                    value: percent,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 7,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Text(
                  '$pct%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'daily_goal'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  pct >= 100
                      ? '🎉 Goal Achieved!'
                      : '${100 - pct}% remaining to reach your goal',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
