import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/custom_card.dart';
import '../controllers/profile_controller.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProfileController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('my_profile'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final user = c.user.value;
        if (user == null) {
          return Center(child: Text('No profile found.'));
        }
        return ListView(
          padding: EdgeInsets.all(16.r),
          children: [
            // Avatar + name
            GradientCard(
              colors: AppColors.gradientPrimary,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40.r,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                      style: TextStyle(
                        fontSize: 36.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    user.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    user.fitnessGoal.tr,
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Stats grid
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.h,
              childAspectRatio: 1.1,
              children: [
                _InfoTile('your_age'.tr, '${user.age}', 'yrs'),
                _InfoTile(
                    'your_height'.tr, user.height.toStringAsFixed(0), 'cm'.tr),
                _InfoTile(
                    'your_weight'.tr, user.weight.toStringAsFixed(1), 'kg'.tr),
              ],
            ),
            SizedBox(height: 16.h),

            // BMI card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('bmi'.tr,
                      style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Text(
                        c.bmi?.toStringAsFixed(1) ?? '-',
                        style: TextStyle(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.bold,
                          color: _bmiColor(c.bmi),
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: _bmiColor(c.bmi).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              c.bmiCategory,
                              style: TextStyle(
                                color: _bmiColor(c.bmi),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text('BMI = weight / height²',
                              style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Calorie needs
            if (c.calorieTargets != null)
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('calorie_needs'.tr,
                        style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(height: 4.h),
                    Text(
                      '${'bmr'.tr}: ${c.bmr?.round()} kcal',
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: Theme.of(context).textTheme.bodyMedium?.color),
                    ),
                    SizedBox(height: 12.h),
                    ...c.calorieTargets!.entries.map((e) => _CalorieRow(
                          label: e.key.tr,
                          value: e.value,
                        )),
                  ],
                ),
              ),
            SizedBox(height: 16.h),

            ElevatedButton.icon(
              onPressed: () => _showEditSheet(context, c, user),
              icon: const Icon(Icons.edit_rounded),
              label: Text('edit_profile'.tr),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48.h)),
            ),
            SizedBox(height: 80.h),
          ],
        );
      }),
    );
  }

  Color _bmiColor(double? bmi) {
    if (bmi == null) return AppColors.primary;
    if (bmi < 18.5) return AppColors.warning;
    if (bmi < 25) return AppColors.accent;
    if (bmi < 30) return AppColors.warning;
    return AppColors.error;
  }

  void _showEditSheet(
      BuildContext context, ProfileController c, UserModel user) {
    final nameCtrl = TextEditingController(text: user.name);
    final ageCtrl = TextEditingController(text: user.age.toString());
    final heightCtrl = TextEditingController(text: user.height.toString());
    final weightCtrl = TextEditingController(text: user.weight.toString());

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
            Text('edit_profile'.tr,
                style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 16.h),
            TextField(
                controller: nameCtrl,
                decoration: InputDecoration(labelText: 'your_name'.tr)),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                    child: TextField(
                        controller: ageCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'your_age'.tr))),
                SizedBox(width: 10.w),
                Expanded(
                    child: TextField(
                        controller: heightCtrl,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(labelText: 'your_height'.tr))),
                SizedBox(width: 10.w),
                Expanded(
                    child: TextField(
                        controller: weightCtrl,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(labelText: 'your_weight'.tr))),
              ],
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {
                user
                  ..name = nameCtrl.text.trim().isNotEmpty
                      ? nameCtrl.text.trim()
                      : user.name
                  ..age = int.tryParse(ageCtrl.text) ?? user.age
                  ..height = double.tryParse(heightCtrl.text) ?? user.height
                  ..weight = double.tryParse(weightCtrl.text) ?? user.weight;
                c.updateUser(user);
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48.h)),
              child: Text('save'.tr),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _InfoTile(this.label, this.value, this.unit);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary)),
          Text(unit,
              style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600)),
          SizedBox(height: 4.h),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10.sp,
                  color: Theme.of(context).textTheme.bodyMedium?.color)),
        ],
      ),
    );
  }
}

class _CalorieRow extends StatelessWidget {
  final String label;
  final int value;

  const _CalorieRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13.sp)),
          Text(
            '$value kcal',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
