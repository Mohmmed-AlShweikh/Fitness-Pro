import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../features/home/controllers/home_controller.dart';
import '../../features/nutrition/controllers/nutrition_controller.dart';
import '../../features/nutrition/models/meal_model.dart';

class QuickLogSheet extends StatelessWidget {
  const QuickLogSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const QuickLogSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
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
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'quick_log'.tr,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6.h),
          Text(
            'quick_log_desc'.tr,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              _Tile(
                icon: Icons.fitness_center_rounded,
                label: 'add_workout'.tr,
                color: AppColors.primary,
                onTap: () {
                  Navigator.pop(context);
                  context.push(AppRoutes.addWorkout);
                },
              ),
              SizedBox(width: 12.w),
              _Tile(
                icon: Icons.water_drop_rounded,
                label: 'log_water'.tr,
                color: const Color(0xFF0984E3),
                onTap: () {
                  Navigator.pop(context);
                  _logWater(context);
                },
              ),
              SizedBox(width: 12.w),
              _Tile(
                icon: Icons.restaurant_rounded,
                label: 'log_meal'.tr,
                color: AppColors.warning,
                onTap: () {
                  Navigator.pop(context);
                  _logMeal(context);
                },
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _Tile(
                icon: Icons.directions_walk_rounded,
                label: 'log_steps'.tr,
                color: AppColors.accent,
                onTap: () {
                  Navigator.pop(context);
                  _logSteps(context);
                },
              ),
              SizedBox(width: 12.w),
              _Tile(
                icon: Icons.monitor_weight_rounded,
                label: 'add_weight'.tr,
                color: AppColors.secondary,
                onTap: () {
                  Navigator.pop(context);
                  context.push(AppRoutes.progress);
                },
              ),
              SizedBox(width: 12.w),
              _Tile(
                icon: Icons.flag_rounded,
                label: 'add_goal'.tr,
                color: AppColors.error,
                onTap: () {
                  Navigator.pop(context);
                  context.push(AppRoutes.goals);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _logWater(BuildContext context) {
    Get.find<HomeController>().addWaterGlass();
    if (Get.isRegistered<NutritionController>()) {
      Get.find<NutritionController>().addWaterGlass();
    }
    Get.snackbar(
      '💧',
      'water_logged'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0984E3).withOpacity(0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _logSteps(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text('log_steps'.tr),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'steps_hint'.tr,
            suffixText: 'steps'.tr,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text('cancel'.tr)),
          FilledButton(
            onPressed: () {
              final v = int.tryParse(ctrl.text) ?? 0;
              if (v > 0) {
                Get.find<HomeController>().addSteps(v);
                Get.snackbar('👟', 'steps_logged'.tr,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.accent.withOpacity(0.9),
                    colorText: Colors.white,
                    duration: const Duration(seconds: 2));
              }
              Navigator.pop(ctx);
            },
            child: Text('save'.tr),
          ),
        ],
      ),
    );
  }

  void _logMeal(BuildContext context) {
    final nameCtrl = TextEditingController();
    final calCtrl = TextEditingController();
    String mealType = 'snack';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Container(
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
              Text('log_meal'.tr,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 16.h),
              TextField(
                controller: nameCtrl,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'meal_name'.tr,
                  prefixIcon: const Icon(Icons.restaurant_rounded),
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: calCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'calories'.tr,
                  suffixText: 'kcal'.tr,
                  prefixIcon: const Icon(Icons.local_fire_department_rounded),
                ),
              ),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 8.w,
                children: ['breakfast', 'lunch', 'dinner', 'snack'].map((t) {
                  final selected = mealType == t;
                  return ChoiceChip(
                    label: Text(t.tr),
                    selected: selected,
                    onSelected: (_) => setState(() => mealType = t),
                    selectedColor: AppColors.primary.withOpacity(0.2),
                  );
                }).toList(),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    final name = nameCtrl.text.trim();
                    final cal = int.tryParse(calCtrl.text) ?? 0;
                    if (name.isEmpty || cal == 0) return;
                    if (Get.isRegistered<NutritionController>()) {
                      await Get.find<NutritionController>().addMeal(
                        MealModel(
                          name: name,
                          calories: cal,
                          mealType: mealType,
                        ),
                      );
                    }
                    if (ctx.mounted) Navigator.pop(ctx);
                    Get.snackbar('🍽', 'meal_logged'.tr,
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.warning.withOpacity(0.9),
                        colorText: Colors.white,
                        duration: const Duration(seconds: 2));
                  },
                  child: Text('save'.tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _Tile({
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
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: color.withOpacity(0.25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 26.sp),
              SizedBox(height: 6.h),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.5.sp,
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
