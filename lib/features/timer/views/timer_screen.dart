import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_card.dart';
import '../controllers/timer_controller.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TimerController>();
    return Scaffold(
      appBar: AppBar(title: Text('timer'.tr)),
      body: ListView(
        padding: EdgeInsets.all(20.r),
        children: [
          // Workout Timer
          GradientCard(
            colors: AppColors.gradientPrimary,
            child: Column(
              children: [
                Text(
                  'timer'.tr,
                  style:
                      TextStyle(color: Colors.white70, fontSize: 14.sp),
                ),
                SizedBox(height: 8.h),
                Obx(() => Text(
                      c.formattedElapsed,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 56.sp,
                        fontWeight: FontWeight.bold,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    )),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: Obx(() => GradientButton(
                            text: c.isRunning.value
                                ? 'pause'.tr
                                : c.elapsed.value == Duration.zero
                                    ? 'start'.tr
                                    : 'resume'.tr,
                            colors: c.isRunning.value
                                ? [AppColors.warning, AppColors.secondary]
                                : [Colors.white, Colors.white.withOpacity(0.85)],
                            onTap: () => c.isRunning.value
                                ? c.pauseWorkout()
                                : c.startWorkout(),
                          )),
                    ),
                    SizedBox(width: 12.w),
                    GestureDetector(
                      onTap: c.resetWorkout,
                      child: Container(
                        width: 52.w,
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(Icons.refresh_rounded,
                            color: Colors.white, size: 24.sp),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2),
          SizedBox(height: 20.h),

          // Rest Timer
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('rest_timer'.tr,
                    style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 16.h),
                Obx(() => c.restRunning.value
                    ? Column(
                        children: [
                          SizedBox(
                            width: 100.w,
                            height: 100.w,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 100.w,
                                  height: 100.w,
                                  child: CircularProgressIndicator(
                                    value: c.restSeconds.value / 60,
                                    strokeWidth: 6,
                                    backgroundColor:
                                        AppColors.accent.withOpacity(0.2),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            AppColors.accent),
                                    strokeCap: StrokeCap.round,
                                  ),
                                ),
                                Text(
                                  '${c.restSeconds.value}s',
                                  style: TextStyle(
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.accent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),
                          OutlineButton(
                            text: 'Stop Rest',
                            onTap: c.stopRest,
                            borderColor: AppColors.error,
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: [30, 60, 90, 120].map((s) {
                              return GestureDetector(
                                onTap: () => c.startRest(seconds: s),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 10.h),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.accent.withOpacity(0.1),
                                    border: Border.all(
                                        color: AppColors.accent
                                            .withOpacity(0.4)),
                                    borderRadius:
                                        BorderRadius.circular(20.r),
                                  ),
                                  child: Text(
                                    '${s}s',
                                    style: TextStyle(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      )),
              ],
            ),
          ).animate(delay: 150.ms).fadeIn(duration: 400.ms).slideY(begin: 0.2),
        ],
      ),
    );
  }
}
