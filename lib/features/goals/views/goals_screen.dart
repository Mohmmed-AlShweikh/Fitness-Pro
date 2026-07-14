import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/empty_state.dart';
import '../controllers/goal_controller.dart';
import '../models/goal_model.dart';
import '../widgets/goal_card.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<GoalController>();
    return Scaffold(
      appBar: AppBar(title: Text('my_goals'.tr)),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final all = c.goals;
        if (all.isEmpty) {
          return EmptyState(
            icon: Icons.flag_rounded,
            message: 'no_goals'.tr,
            actionLabel: 'add_goal'.tr,
            onAction: () => _showAddGoalSheet(context, c),
          );
        }
        return RefreshIndicator(
          onRefresh: c.loadGoals,
          child: ListView(
            padding: EdgeInsets.all(16.r),
            children: [
              if (c.active.isNotEmpty) ...[
                Text('active'.tr, style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 10.h),
                ...c.active.map((g) => GoalCard(
                      goal: g,
                      onUpdate: (val) => c.updateProgress(g.id, val),
                      onDelete: () => c.deleteGoal(g.id),
                    )),
                SizedBox(height: 16.h),
              ],
              if (c.completed.isNotEmpty) ...[
                Text('completed'.tr, style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 10.h),
                ...c.completed.map((g) => GoalCard(
                      goal: g,
                      onUpdate: (val) => c.updateProgress(g.id, val),
                      onDelete: () => c.deleteGoal(g.id),
                    )),
              ],
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGoalSheet(context, c),
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  void _showAddGoalSheet(BuildContext context, GoalController c) {
    final titleCtrl = TextEditingController();
    final targetCtrl = TextEditingController();
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
            Text('add_goal'.tr, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 16.h),
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(
                  hintText: 'goal_examples'.tr, labelText: 'goal_title'.tr),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: targetCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'target'.tr),
            ),
            SizedBox(height: 20.h),
            GradientButton(
              text: 'save'.tr,
              colors: AppColors.gradientSuccess,
              onTap: () {
                final goal = GoalModel(
                  title: titleCtrl.text.trim(),
                  target: double.tryParse(targetCtrl.text) ?? 100,
                  current: 0,
                  completed: false,
                );
                c.saveGoal(goal);
                Navigator.pop(ctx);
                Get.snackbar('✅', 'goal_saved'.tr,
                    snackPosition: SnackPosition.BOTTOM);
              },
            ),
          ],
        ),
      ),
    );
  }
}
