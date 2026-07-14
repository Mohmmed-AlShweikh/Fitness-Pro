import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/empty_state.dart';
import '../controllers/workout_controller.dart';
import '../widgets/workout_card.dart';

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  static const _categories = [
    'all', 'chest', 'back', 'legs', 'arms', 'cardio', 'full_body'
  ];

  @override
  Widget build(BuildContext context) {
    final c = Get.find<WorkoutController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('my_workouts'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => context.go(AppRoutes.addWorkout),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
            child: TextField(
              onChanged: c.setSearch,
              decoration: InputDecoration(
                hintText: 'search'.tr,
                prefixIcon: const Icon(Icons.search_rounded),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Category filter chips
          SizedBox(
            height: 36.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (ctx, i) {
                final cat = _categories[i];
                return Obx(() {
                  final selected = c.selectedCategory.value == cat;
                  return GestureDetector(
                    onTap: () => c.setCategory(cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : Theme.of(context).dividerColor),
                      ),
                      child: Text(
                        (cat == 'all' ? 'All' : cat.tr),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: selected ? Colors.white : null,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: Obx(() {
              if (c.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final list = c.filtered;
              if (list.isEmpty) {
                return EmptyState(
                  icon: Icons.fitness_center_rounded,
                  message: 'no_workouts'.tr,
                  actionLabel: 'add_workout'.tr,
                  onAction: () => context.go(AppRoutes.addWorkout),
                );
              }
              return RefreshIndicator(
                onRefresh: c.loadWorkouts,
                child: ListView.separated(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemBuilder: (ctx, i) => WorkoutCard(
                    workout: list[i],
                    onTap: () => context.go(AppRoutes.addWorkout,
                        extra: {'workoutId': list[i].id}),
                    onDelete: () => _confirmDelete(context, c, list[i].id),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(AppRoutes.addWorkout),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WorkoutController c, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('delete_workout'.tr),
        content: Text('delete_workout_confirm'.tr),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('cancel'.tr)),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              c.deleteWorkout(id);
            },
            child: Text('delete'.tr,
                style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
