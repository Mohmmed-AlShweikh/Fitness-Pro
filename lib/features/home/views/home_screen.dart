import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/services/database_service.dart';
import '../../../features/profile/models/user_model.dart';
import '../../../shared/widgets/section_header.dart';
import '../controllers/home_controller.dart';
import '../widgets/daily_summary_card.dart';
import '../widgets/progress_circle_widget.dart';
import '../widgets/today_workout_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();

    return RefreshIndicator(
      onRefresh: c.loadTodayData,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140.h,
            floating: true,
            snap: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.gradientPrimary,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
                    child: FutureBuilder<UserModel?>(
                      future: Get.find<DatabaseService>().getUser(),
                      builder: (ctx, snapshot) {
                        final user = snapshot.data;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.greeting,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              user?.name ?? 'FitTrack Pro',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.h),

                  // Daily Summary
                  SectionHeader(title: 'daily_summary'.tr),
                  SizedBox(height: 12.h),
                  Obx(() => DailySummaryCard(
                        caloriesBurned: c.todayCaloriesBurned.value,
                        caloriesConsumed: c.dailyCaloriesConsumed,
                        waterLiters: c.dailyWater,
                        steps: c.dailySteps,
                      )),

                  SizedBox(height: 30.h),

                  // Progress Circle
                  Obx(() => ProgressCircleWidget(
                        percent: c.dailyGoalPercent.value,
                      )),

                  SizedBox(height: 24.h),

                  // Today's workout
                  SectionHeader(
                    title: 'today_workout'.tr,
                    actionLabel: 'workouts'.tr,
                    onAction: () => context.go(AppRoutes.workouts),
                  ),
                  SizedBox(height: 12.h),
                  TodayWorkoutCard(
                        workouts: c.todayWorkouts,
                        onAdd: () => context.go(AppRoutes.addWorkout),
                      ),

                  SizedBox(height: 24.h),

                  // Quick actions
                  SectionHeader(title: 'quick_actions'.tr),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      _QuickAction(
                        icon: Icons.fitness_center_rounded,
                        label: 'add_workout'.tr,
                        color: AppColors.primary,
                        onTap: () => context.push(AppRoutes.addWorkout),
                      ),
                      SizedBox(width: 12.w),
                      _QuickAction(
                        icon: Icons.flag_rounded,
                        label: 'add_goal'.tr,
                        color: AppColors.accent,
                        onTap: () => context.push(AppRoutes.goals),
                      ),
                      SizedBox(width: 12.w),
                      _QuickAction(
                        icon: Icons.monitor_weight_rounded,
                        label: 'add_weight'.tr,
                        color: AppColors.secondary,
                        onTap: () => context.push(AppRoutes.progress),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            border: Border.all(color: color.withValues(alpha: 0.25)),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 26.sp),
              SizedBox(height: 6.h),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
