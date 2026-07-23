import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/nutrition_controller.dart';
import '../models/meal_model.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<NutritionController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('nutrition'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _showAddMealSheet(context, c, 'snack'),
          ),
        ],
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: c.loadTodayMeals,
          child: ListView(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 100.h),
            children: [
              // ── Calorie Ring + Macros ─────────────────────────────────
              _CalorieSummaryCard(controller: c, isDark: isDark)
                  .animate()
                  .fadeIn(duration: 350.ms)
                  .slideY(begin: 0.1),

              SizedBox(height: 20.h),

              // ── Water Tracker ─────────────────────────────────────────
              _WaterCard(controller: c, isDark: isDark)
                  .animate(delay: 60.ms)
                  .fadeIn(duration: 350.ms)
                  .slideY(begin: 0.1),

              SizedBox(height: 24.h),

              // ── Meals by type ─────────────────────────────────────────
              ...[
                ('breakfast', Icons.wb_sunny_rounded, AppColors.warning),
                ('lunch', Icons.light_mode_rounded, AppColors.accent),
                ('dinner', Icons.nights_stay_rounded, AppColors.primary),
                ('snack', Icons.cookie_rounded, AppColors.secondary),
              ].asMap().entries.map((e) {
                final idx = e.key;
                final type = e.value.$1;
                final icon = e.value.$2;
                final color = e.value.$3;
                final items = c.meals
                    .where((m) => m.mealType == type)
                    .toList();
                return _MealSection(
                  type: type,
                  icon: icon,
                  color: color,
                  meals: items,
                  isDark: isDark,
                  onAdd: () => _showAddMealSheet(context, c, type),
                  onDelete: (id) => c.deleteMeal(id),
                ).animate(delay: Duration(milliseconds: 80 + idx * 50))
                    .fadeIn(duration: 350.ms)
                    .slideY(begin: 0.1);
              }),
            ],
          ),
        );
      }),
    );
  }

  void _showAddMealSheet(
      BuildContext context, NutritionController c, String defaultType) {
    final nameCtrl = TextEditingController();
    final calCtrl = TextEditingController();
    final proteinCtrl = TextEditingController();
    final carbsCtrl = TextEditingController();
    final fatCtrl = TextEditingController();
    String mealType = defaultType;

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
          child: SingleChildScrollView(
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
                SizedBox(height: 16.h),
                Text('log_meal'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 16.h),
                Wrap(
                  spacing: 8.w,
                  children:
                      ['breakfast', 'lunch', 'dinner', 'snack'].map((t) {
                    return ChoiceChip(
                      label: Text(t.tr),
                      selected: mealType == t,
                      onSelected: (_) => setState(() => mealType = t),
                      selectedColor: AppColors.primary.withOpacity(0.2),
                    );
                  }).toList(),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: nameCtrl,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'meal_name'.tr,
                    prefixIcon: const Icon(Icons.restaurant_rounded),
                  ),
                ),
                SizedBox(height: 10.h),
                TextField(
                  controller: calCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'calories'.tr,
                    suffixText: 'kcal'.tr,
                    prefixIcon:
                        const Icon(Icons.local_fire_department_rounded),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: proteinCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'protein'.tr,
                          suffixText: 'g',
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        controller: carbsCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'carbs'.tr,
                          suffixText: 'g',
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        controller: fatCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'fat'.tr,
                          suffixText: 'g',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      final name = nameCtrl.text.trim();
                      final cal = int.tryParse(calCtrl.text) ?? 0;
                      if (name.isEmpty) return;
                      await c.addMeal(MealModel(
                        name: name,
                        calories: cal,
                        protein:
                            double.tryParse(proteinCtrl.text) ?? 0,
                        carbs: double.tryParse(carbsCtrl.text) ?? 0,
                        fat: double.tryParse(fatCtrl.text) ?? 0,
                        mealType: mealType,
                      ));
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                    child: Text('save'.tr),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Calorie Summary ───────────────────────────────────────────────────────────
class _CalorieSummaryCard extends StatelessWidget {
  final NutritionController controller;
  final bool isDark;

  const _CalorieSummaryCard(
      {required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFe17055), Color(0xFFFDCB6E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('calories_today'.tr,
                        style: TextStyle(
                            color: Colors.white70, fontSize: 13.sp)),
                    SizedBox(height: 4.h),
                    Obx(() => Text(
                          '${controller.todayCalories}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Text(
                      '/ ${NutritionController.calorieGoal} ${'kcal'.tr}',
                      style: TextStyle(
                          color: Colors.white70, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 70.w,
                height: 70.h,
                child: Obx(() {
                  final pct = (controller.todayCalories /
                          NutritionController.calorieGoal)
                      .clamp(0.0, 1.0);
                  return CircularProgressIndicator(
                    value: pct,
                    strokeWidth: 7,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Obx(() => Row(
                children: [
                  _MacroChip(
                      label: 'protein'.tr,
                      value: '${controller.todayProtein.toInt()}g',
                      color: Colors.white),
                  SizedBox(width: 8.w),
                  _MacroChip(
                      label: 'carbs'.tr,
                      value: '${controller.todayCarbs.toInt()}g',
                      color: Colors.white),
                  SizedBox(width: 8.w),
                  _MacroChip(
                      label: 'fat'.tr,
                      value: '${controller.todayFat.toInt()}g',
                      color: Colors.white),
                ],
              )),
        ],
      ),
    );
  }
}

class _MacroChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MacroChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp)),
            Text(label,
                style: TextStyle(color: Colors.white70, fontSize: 10.sp)),
          ],
        ),
      ),
    );
  }
}

// ── Water Card ────────────────────────────────────────────────────────────────
class _WaterCard extends StatelessWidget {
  final NutritionController controller;
  final bool isDark;

  const _WaterCard({required this.controller, required this.isDark});

  static const waterColor = Color(0xFF0984E3);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: waterColor.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.water_drop_rounded, color: waterColor, size: 20.sp),
              SizedBox(width: 8.w),
              Text('water_intake'.tr,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                      color: isDark
                          ? AppColors.darkText
                          : AppColors.lightText)),
              const Spacer(),
              GestureDetector(
                onTap: controller.removeWaterGlass,
                child: Icon(Icons.remove_circle_outline_rounded,
                    color: waterColor, size: 22.sp),
              ),
              SizedBox(width: 12.w),
              Obx(() => Text(
                    '${controller.waterGlasses.value}',
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: waterColor),
                  )),
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: controller.addWaterGlass,
                child: Icon(Icons.add_circle_rounded,
                    color: waterColor, size: 22.sp),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Obx(() {
            final filled = controller.waterGlasses.value;
            return Row(
              children: List.generate(NutritionController.waterGoal, (i) {
                final isFilled = i < filled;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (!isFilled && i == filled) {
                        controller.addWaterGlass();
                      } else if (isFilled && i == filled - 1) {
                        controller.removeWaterGlass();
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
                              ? waterColor.withOpacity(0.4)
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
          SizedBox(height: 8.h),
          Obx(() => Text(
                '${'goal'.tr}: ${NutritionController.waterGoal} ${'glasses'.tr} · ${(controller.waterGlasses.value * 0.25).toStringAsFixed(2)} L / ${(NutritionController.waterGoal * 0.25).toStringAsFixed(1)} L',
                style: TextStyle(
                    fontSize: 11.sp,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
              )),
        ],
      ),
    );
  }
}

// ── Meal Section ──────────────────────────────────────────────────────────────
class _MealSection extends StatelessWidget {
  final String type;
  final IconData icon;
  final Color color;
  final List<MealModel> meals;
  final bool isDark;
  final VoidCallback onAdd;
  final Function(int) onDelete;

  const _MealSection({
    required this.type,
    required this.icon,
    required this.color,
    required this.meals,
    required this.isDark,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final totalCal = meals.fold(0, (s, m) => s + m.calories);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(7.r),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: color, size: 16.sp),
            ),
            SizedBox(width: 10.w),
            Text(
              type.tr,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15.sp,
                  color:
                      isDark ? AppColors.darkText : AppColors.lightText),
            ),
            if (totalCal > 0) ...[
              SizedBox(width: 8.w),
              Text(
                '$totalCal ${'kcal'.tr}',
                style: TextStyle(
                    fontSize: 12.sp,
                    color: color,
                    fontWeight: FontWeight.w600),
              ),
            ],
            const Spacer(),
            GestureDetector(
              onTap: onAdd,
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_rounded, color: color, size: 14.sp),
                    SizedBox(width: 3.w),
                    Text('add'.tr,
                        style: TextStyle(
                            color: color,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        if (meals.isEmpty)
          Container(
            width: double.infinity,
            padding:
                EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkCard
                  : const Color(0xFFF8F9FE),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                  color: color.withOpacity(0.1), style: BorderStyle.solid),
            ),
            child: Text(
              'no_meals_yet'.tr,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
            ),
          )
        else
          ...meals.map((meal) => _MealTile(
                meal: meal,
                isDark: isDark,
                onDelete: () => onDelete(meal.id),
              )),
        SizedBox(height: 8.h),
      ],
    );
  }
}

class _MealTile extends StatelessWidget {
  final MealModel meal;
  final bool isDark;
  final VoidCallback onDelete;

  const _MealTile(
      {required this.meal, required this.isDark, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meal.name,
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13.sp)),
                if (meal.protein > 0 ||
                    meal.carbs > 0 ||
                    meal.fat > 0)
                  Text(
                    'P: ${meal.protein.toInt()}g · C: ${meal.carbs.toInt()}g · F: ${meal.fat.toInt()}g',
                    style: TextStyle(
                        fontSize: 10.5.sp,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                  ),
              ],
            ),
          ),
          Text(
            '${meal.calories} ${'kcal'.tr}',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13.sp,
                color: AppColors.warning),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: onDelete,
            child: Icon(Icons.close_rounded,
                size: 16.sp,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary),
          ),
        ],
      ),
    );
  }
}
