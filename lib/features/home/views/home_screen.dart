import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/services/database_service.dart';
import '../../../features/profile/models/user_model.dart';
import '../../../shared/widgets/section_header.dart';
import '../controllers/home_controller.dart';
import '../widgets/progress_circle_widget.dart';
import '../widgets/today_workout_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: c.loadTodayData,
      child: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 160.h,
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
                    padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
                    child: FutureBuilder<UserModel?>(
                      future: Get.find<DatabaseService>().getUser(),
                      builder: (ctx, snapshot) {
                        final user = snapshot.data;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    c.greeting,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    user?.name.isNotEmpty == true
                                        ? user!.name
                                        : 'FitTrack Pro',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    children: [
                                      Obx(() => _StreakBadge(
                                            streak: c.streak.value,
                                          )),
                                      SizedBox(width: 10.w),
                                      GestureDetector(
                                        onTap: () =>
                                            context.push(AppRoutes.timer),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.w, vertical: 5.h),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.timer_outlined,
                                                  color: Colors.white,
                                                  size: 13.sp),
                                              SizedBox(width: 4.w),
                                              Text(
                                                'timer'.tr,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.push(AppRoutes.reports),
                              child: Container(
                                padding: EdgeInsets.all(10.r),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                                child: Icon(Icons.bar_chart_rounded,
                                    color: Colors.white, size: 22.sp),
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
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 100.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Daily Stats Row ────────────────────────────────────
                  Obx(() => _DailyStatsRow(
                        caloriesBurned: c.todayCaloriesBurned.value,
                        caloriesConsumed: c.caloriesConsumed.value,
                        steps: c.steps.value,
                        stepGoal: HomeController.stepGoal,
                      )).animate().fadeIn(duration: 350.ms).slideY(begin: 0.15),

                  SizedBox(height: 24.h),

                  // ── Water Tracker ─────────────────────────────────────
                  _WaterTracker(controller: c)
                      .animate(delay: 50.ms)
                      .fadeIn(duration: 350.ms)
                      .slideY(begin: 0.15),

                  SizedBox(height: 24.h),

                  // ── Progress Circle ───────────────────────────────────
                  Obx(() => ProgressCircleWidget(
                        percent: c.dailyGoalPercent.value,
                      )).animate(delay: 100.ms).fadeIn(duration: 350.ms),

                  SizedBox(height: 24.h),

                  // ── Today's Workout ───────────────────────────────────
                  SectionHeader(
                    title: 'today_workout'.tr,
                    actionLabel: 'workouts'.tr,
                    onAction: () => context.go(AppRoutes.workouts),
                  ),
                  SizedBox(height: 12.h),
                  Obx(() => TodayWorkoutCard(
                        workouts: c.todayWorkouts,
                        onAdd: () => context.push(AppRoutes.addWorkout),
                      )).animate(delay: 150.ms).fadeIn(duration: 350.ms),

                  SizedBox(height: 24.h),

                  // ── Quick Actions ─────────────────────────────────────
                  SectionHeader(title: 'quick_actions'.tr),
                  SizedBox(height: 12.h),
                  _QuickActionsGrid(context: context)
                      .animate(delay: 200.ms)
                      .fadeIn(duration: 350.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Streak Badge ──────────────────────────────────────────────────────────────
class _StreakBadge extends StatelessWidget {
  final int streak;
  const _StreakBadge({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: streak > 0
            ? const Color(0xFFFDCB6E).withOpacity(0.25)
            : Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: streak > 0
              ? const Color(0xFFFDCB6E).withOpacity(0.6)
              : Colors.white.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🔥', style: TextStyle(fontSize: 12.sp)),
          SizedBox(width: 4.w),
          Text(
            streak > 0 ? '$streak ${'day_streak'.tr}' : 'start_streak'.tr,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Daily Stats Row ───────────────────────────────────────────────────────────
class _DailyStatsRow extends StatelessWidget {
  final int caloriesBurned;
  final int caloriesConsumed;
  final int steps;
  final int stepGoal;

  const _DailyStatsRow({
    required this.caloriesBurned,
    required this.caloriesConsumed,
    required this.steps,
    required this.stepGoal,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
          icon: Icons.local_fire_department_rounded,
          value: '$caloriesBurned',
          label: 'burned'.tr,
          unit: 'kcal'.tr,
          color: AppColors.secondary,
        ),
        SizedBox(width: 10.w),
        _StatCard(
          icon: Icons.restaurant_rounded,
          value: '$caloriesConsumed',
          label: 'consumed'.tr,
          unit: 'kcal'.tr,
          color: AppColors.warning,
        ),
        SizedBox(width: 10.w),
        _StatCard(
          icon: Icons.directions_walk_rounded,
          value: '$steps',
          label: 'steps'.tr,
          unit: '/ $stepGoal',
          color: AppColors.accent,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final String unit;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: color.withOpacity(0.18)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(7.r),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: color, size: 16.sp),
            ),
            SizedBox(height: 10.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            Text(
              unit,
              style: TextStyle(
                  fontSize: 9.5.sp,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Water Tracker ─────────────────────────────────────────────────────────────
class _WaterTracker extends StatelessWidget {
  final HomeController controller;
  const _WaterTracker({required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const waterColor = Color(0xFF0984E3);

    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: waterColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: waterColor.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(7.r),
                decoration: BoxDecoration(
                  color: waterColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.water_drop_rounded,
                    color: waterColor, size: 16.sp),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'water_intake'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  Obx(() => Text(
                        '${controller.waterGlasses.value} / ${HomeController.waterGoalGlasses} ${'glasses'.tr}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: waterColor,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                ],
              ),
              const Spacer(),
              // Remove glass
              GestureDetector(
                onTap: controller.removeWaterGlass,
                child: Container(
                  padding: EdgeInsets.all(7.r),
                  decoration: BoxDecoration(
                    color: waterColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(Icons.remove_rounded,
                      color: waterColor, size: 16.sp),
                ),
              ),
              SizedBox(width: 8.w),
              // Add glass
              GestureDetector(
                onTap: controller.addWaterGlass,
                child: Container(
                  padding: EdgeInsets.all(7.r),
                  decoration: BoxDecoration(
                    color: waterColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(Icons.add_rounded,
                      color: Colors.white, size: 16.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          // Glass icons row
          Obx(() {
            final filled = controller.waterGlasses.value;
            return Row(
              children: List.generate(HomeController.waterGoalGlasses, (i) {
                final isFilled = i < filled;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (isFilled) {
                        // Tap filled glass to remove
                        if (i == filled - 1) controller.removeWaterGlass();
                      } else {
                        // Tap empty glass to fill next
                        if (i == filled) controller.addWaterGlass();
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: isFilled
                            ? waterColor.withOpacity(0.15)
                            : (isDark
                                ? AppColors.darkBackground
                                : const Color(0xFFF0F4F8)),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: isFilled
                              ? waterColor.withOpacity(0.5)
                              : Colors.transparent,
                        ),
                      ),
                      child: Icon(
                        isFilled
                            ? Icons.water_drop_rounded
                            : Icons.water_drop_outlined,
                        color: isFilled
                            ? waterColor
                            : (isDark
                                ? AppColors.darkTextSecondary
                                : const Color(0xFFB2BEC3)),
                        size: 16.sp,
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}

// ── Quick Actions Grid ────────────────────────────────────────────────────────
class _QuickActionsGrid extends StatelessWidget {
  final BuildContext context;
  const _QuickActionsGrid({required this.context});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 10.w,
      mainAxisSpacing: 10.h,
      childAspectRatio: 1.1,
      children: [
        _QAItem(
          icon: Icons.fitness_center_rounded,
          label: 'add_workout'.tr,
          color: AppColors.primary,
          onTap: () => context.push(AppRoutes.addWorkout),
        ),
        _QAItem(
          icon: Icons.flag_rounded,
          label: 'goals'.tr,
          color: AppColors.accent,
          onTap: () => context.go(AppRoutes.goals),
        ),
        _QAItem(
          icon: Icons.restaurant_rounded,
          label: 'nutrition'.tr,
          color: AppColors.warning,
          onTap: () => context.go(AppRoutes.nutrition),
        ),
        _QAItem(
          icon: Icons.bar_chart_rounded,
          label: 'progress'.tr,
          color: AppColors.secondary,
          onTap: () => context.go(AppRoutes.progress),
        ),
        _QAItem(
          icon: Icons.timer_rounded,
          label: 'timer'.tr,
          color: const Color(0xFF6C5CE7),
          onTap: () => context.push(AppRoutes.timer),
        ),
        _QAItem(
          icon: Icons.picture_as_pdf_rounded,
          label: 'reports'.tr,
          color: const Color(0xFFE17055),
          onTap: () => context.push(AppRoutes.reports),
        ),
      ],
    );
  }
}

class _QAItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QAItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: color, size: 20.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
