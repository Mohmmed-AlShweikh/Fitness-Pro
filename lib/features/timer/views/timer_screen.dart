import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/timer_controller.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TimerController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text('timer'.tr)),
      body: ListView(
        padding: EdgeInsets.all(20.r),
        children: [
          // ── Workout Stopwatch ────────────────────────────────────────
          _WorkoutTimerCard(controller: c, isDark: isDark)
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.15),

          SizedBox(height: 20.h),

          // ── Rest Timer ───────────────────────────────────────────────
          _RestTimerCard(controller: c, isDark: isDark)
              .animate(delay: 100.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.15),
        ],
      ),
    );
  }
}

// ── Workout Stopwatch Card ────────────────────────────────────────────────────
class _WorkoutTimerCard extends StatelessWidget {
  final TimerController controller;
  final bool isDark;

  const _WorkoutTimerCard(
      {required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.gradientPrimary,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.all(24.r),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child:
                    Icon(Icons.timer_rounded, color: Colors.white, size: 18.sp),
              ),
              SizedBox(width: 10.w),
              Text(
                'workout_timer'.tr,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Circular progress ring
          Obx(() {
            final secs = controller.elapsed.value.inSeconds % 60;
            final pct = secs / 60.0;
            return SizedBox(
              width: 160.w,
              height: 160.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 160.w,
                    height: 160.w,
                    child: CircularProgressIndicator(
                      value: pct,
                      strokeWidth: 8,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        controller.formattedElapsed,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38.sp,
                          fontWeight: FontWeight.bold,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      Text(
                        controller.isRunning.value
                            ? 'active'.tr
                            : controller.elapsed.value == Duration.zero
                                ? 'ready'.tr
                                : 'paused'.tr,
                        style: TextStyle(
                            color: Colors.white60, fontSize: 12.sp),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 28.h),
          Row(
            children: [
              // Reset
              GestureDetector(
                onTap: controller.resetWorkout,
                child: Container(
                  width: 52.w,
                  height: 52.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(Icons.refresh_rounded,
                      color: Colors.white, size: 22.sp),
                ),
              ),
              SizedBox(width: 12.w),
              // Start / Pause
              Expanded(
                child: Obx(() => GestureDetector(
                      onTap: () => controller.isRunning.value
                          ? controller.pauseWorkout()
                          : controller.startWorkout(),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: controller.isRunning.value
                              ? const Color(0xFFFDCB6E)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Center(
                          child: Text(
                            controller.isRunning.value
                                ? 'pause'.tr
                                : controller.elapsed.value == Duration.zero
                                    ? 'start'.tr
                                    : 'resume'.tr,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Rest Timer Card ───────────────────────────────────────────────────────────
class _RestTimerCard extends StatelessWidget {
  final TimerController controller;
  final bool isDark;

  const _RestTimerCard({required this.controller, required this.isDark});

  static const _presets = [30, 45, 60, 90, 120, 180];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.all(24.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.hourglass_bottom_rounded,
                    color: AppColors.accent, size: 18.sp),
              ),
              SizedBox(width: 10.w),
              Text(
                'rest_timer'.tr,
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Countdown display
          Obx(() {
            final running = controller.restRunning.value;
            final secs = controller.restSeconds.value;
            final total = controller.restTotalSeconds.value;
            final pct = total > 0 ? (secs / total).clamp(0.0, 1.0) : 0.0;

            return Center(
              child: SizedBox(
                width: 140.w,
                height: 140.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 140.w,
                      height: 140.w,
                      child: CircularProgressIndicator(
                        value: pct,
                        strokeWidth: 7,
                        backgroundColor: AppColors.accent.withOpacity(0.15),
                        valueColor: AlwaysStoppedAnimation<Color>(
                            running ? AppColors.accent : Colors.grey),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatSecs(secs),
                          style: TextStyle(
                            fontSize: 34.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darkText
                                : AppColors.lightText,
                            fontFeatures: const [
                              FontFeature.tabularFigures()
                            ],
                          ),
                        ),
                        Text(
                          running ? 'resting'.tr : 'set_rest_time'.tr,
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: 20.h),

          // Preset chips
          Text('set_rest_time'.tr,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  fontWeight: FontWeight.w500)),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _presets.map((s) {
              return Obx(() {
                final isActive = controller.restRunning.value &&
                    controller.restTotalSeconds.value == s;
                return GestureDetector(
                  onTap: () => controller.startRest(seconds: s),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 9.h),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.accent
                          : AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                          color: AppColors.accent.withOpacity(0.4)),
                    ),
                    child: Text(
                      s >= 60 ? '${s ~/ 60}m ${s % 60 == 0 ? '' : '${s % 60}s'}' : '${s}s',
                      style: TextStyle(
                        color: isActive ? Colors.white : AppColors.accent,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                );
              });
            }).toList(),
          ),
          SizedBox(height: 16.h),
          Obx(() => controller.restRunning.value
              ? SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: controller.stopRest,
                    icon: const Icon(Icons.stop_rounded),
                    label: Text('reset'.tr),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: BorderSide(color: AppColors.error.withOpacity(0.5)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r)),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  String _formatSecs(int totalSecs) {
    final m = (totalSecs ~/ 60).toString().padLeft(2, '0');
    final s = (totalSecs % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
