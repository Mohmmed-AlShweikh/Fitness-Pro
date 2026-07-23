import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/services/storage_service.dart';
import '../../../shared/widgets/empty_state.dart';
import '../controllers/goal_controller.dart';
import '../models/goal_model.dart';
import '../widgets/goal_card.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<GoalController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text('my_goals'.tr)),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final all = c.goals;
        return RefreshIndicator(
          onRefresh: c.loadGoals,
          child: ListView(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 100.h),
            children: [
              // Achievements section
              _AchievementsSection(isDark: isDark)
                  .animate()
                  .fadeIn(duration: 350.ms)
                  .slideY(begin: 0.1),

              SizedBox(height: 20.h),

              if (all.isEmpty)
                EmptyState(
                  icon: Icons.flag_rounded,
                  message: 'no_goals'.tr,
                  actionLabel: 'add_goal'.tr,
                  onAction: () => _showAddGoalSheet(context, c),
                )
              else ...[
                if (c.active.isNotEmpty) ...[
                  _SectionLabel(label: 'active'.tr, color: AppColors.accent),
                  SizedBox(height: 10.h),
                  ...c.active.asMap().entries.map((e) => GoalCard(
                        goal: e.value,
                        onUpdate: (val) =>
                            c.updateProgress(e.value.id, val),
                        onDelete: () => c.deleteGoal(e.value.id),
                      ).animate(delay: Duration(milliseconds: e.key * 50)).fadeIn(duration: 300.ms)),
                  SizedBox(height: 16.h),
                ],
                if (c.completed.isNotEmpty) ...[
                  _SectionLabel(
                      label: 'completed'.tr, color: AppColors.primary),
                  SizedBox(height: 10.h),
                  ...c.completed.asMap().entries.map((e) => GoalCard(
                        goal: e.value,
                        onUpdate: (val) =>
                            c.updateProgress(e.value.id, val),
                        onDelete: () => c.deleteGoal(e.value.id),
                      ).animate(delay: Duration(milliseconds: e.key * 50)).fadeIn(duration: 300.ms)),
                ],
              ],
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddGoalSheet(context, c),
        backgroundColor: AppColors.accent,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('add_goal'.tr,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  void _showAddGoalSheet(BuildContext context, GoalController c) {
    final titleCtrl = TextEditingController();
    final targetCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        padding: EdgeInsets.fromLTRB(
            20.w, 20.h, 20.w, MediaQuery.of(ctx).viewInsets.bottom + 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2.r)),
              ),
            ),
            SizedBox(height: 16.h),
            Text('add_goal'.tr,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 16.h),
            TextField(
              controller: titleCtrl,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'goal_examples'.tr,
                labelText: 'goal_title'.tr,
                prefixIcon: const Icon(Icons.flag_rounded),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: targetCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'target'.tr,
                prefixIcon: const Icon(Icons.track_changes_rounded),
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final goal = GoalModel(
                    title: titleCtrl.text.trim(),
                    target: double.tryParse(targetCtrl.text) ?? 100,
                  );
                  if (goal.title.isEmpty) return;
                  c.saveGoal(goal);
                  Get.snackbar('🎯', 'goal_saved'.tr,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.accent.withOpacity(0.9),
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2));
                  Navigator.pop(ctx);
                },
                child: Text('save'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;
  const _SectionLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 16.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(label,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// ── Achievements ──────────────────────────────────────────────────────────────
class _AchievementsSection extends StatelessWidget {
  final bool isDark;
  const _AchievementsSection({required this.isDark});

  static final _achievements = [
    _Achievement(
      key: 'first_workout',
      icon: '🏋️',
      titleKey: 'first_workout',
      descKey: 'first_workout_desc',
      color: AppColors.primary,
      check: (workouts, completed) => workouts >= 1,
    ),
    _Achievement(
      key: 'streak_7',
      icon: '🔥',
      titleKey: 'streak_7',
      descKey: 'streak_7_desc',
      color: AppColors.warning,
      check: (workouts, completed) =>
          Get.find<StorageService>().workoutStreak >= 7,
    ),
    _Achievement(
      key: 'workouts_50',
      icon: '💪',
      titleKey: 'workouts_50',
      descKey: 'workouts_50_desc',
      color: AppColors.secondary,
      check: (workouts, completed) => workouts >= 50,
    ),
    _Achievement(
      key: 'goals_10',
      icon: '🎯',
      titleKey: 'goals_10',
      descKey: 'goals_10_desc',
      color: AppColors.accent,
      check: (workouts, completed) => completed >= 10,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoalController>(builder: (c) {
      final totalWorkouts = Get.isRegistered<GoalController>()
          ? c.goals.length // proxy for progress; real count needs WorkoutController
          : 0;
      final completedGoals = c.completed.length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(7.r),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.emoji_events_rounded,
                    color: AppColors.warning, size: 16.sp),
              ),
              SizedBox(width: 10.w),
              Text('achievements'.tr,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 12.h),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
            childAspectRatio: 1.6,
            children: _achievements.map((a) {
              final unlocked = a.check(totalWorkouts, completedGoals);
              return _AchievementCard(
                  achievement: a, unlocked: unlocked, isDark: isDark);
            }).toList(),
          ),
        ],
      );
    });
  }
}

class _Achievement {
  final String key;
  final String icon;
  final String titleKey;
  final String descKey;
  final Color color;
  final bool Function(int workouts, int completed) check;

  const _Achievement({
    required this.key,
    required this.icon,
    required this.titleKey,
    required this.descKey,
    required this.color,
    required this.check,
  });
}

class _AchievementCard extends StatelessWidget {
  final _Achievement achievement;
  final bool unlocked;
  final bool isDark;

  const _AchievementCard(
      {required this.achievement, required this.unlocked, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = unlocked ? achievement.color : Colors.grey;
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: unlocked ? color.withOpacity(0.3) : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: unlocked
                ? color.withOpacity(0.1)
                : Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            unlocked ? achievement.icon : '🔒',
            style: TextStyle(fontSize: 24.sp),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  achievement.titleKey.tr,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: unlocked
                        ? (isDark ? AppColors.darkText : AppColors.lightText)
                        : Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  unlocked ? achievement.descKey.tr : 'locked'.tr,
                  style: TextStyle(
                    fontSize: 9.5.sp,
                    color: unlocked ? color : Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
