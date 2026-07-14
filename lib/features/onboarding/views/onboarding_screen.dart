import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(OnboardingController());

    final pages = [
      _OnboardingPage(
        icon: Icons.fitness_center_rounded,
        title: 'onboarding_title_1'.tr,
        desc: 'onboarding_desc_1'.tr,
        color: AppColors.primary,
      ),
      _OnboardingPage(
        icon: Icons.directions_run_rounded,
        title: 'onboarding_title_2'.tr,
        desc: 'onboarding_desc_2'.tr,
        color: AppColors.secondary,
      ),
      _OnboardingPage(
        icon: Icons.local_fire_department_rounded,
        title: 'onboarding_title_3'.tr,
        desc: 'onboarding_desc_3'.tr,
        color: AppColors.accent,
      ),
      _OnboardingPage(
        icon: Icons.trending_up_rounded,
        title: 'onboarding_title_4'.tr,
        desc: 'onboarding_desc_4'.tr,
        color: AppColors.warning,
      ),
      _ProfileSetupPage(c: c),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Obx(() => c.currentPage.value < 4
                ? Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () => c.pageController.jumpToPage(4),
                      child: Text('skip'.tr,
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp)),
                    ),
                  )
                : const SizedBox.shrink()),

            // Pages
            Expanded(
              child: PageView(
                controller: c.pageController,
                onPageChanged: c.onPageChanged,
                children: pages,
              ),
            ),

            // Dots + button
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
              child: Column(
                children: [
                  // Dots
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          pages.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: EdgeInsets.symmetric(horizontal: 3.w),
                            width: c.currentPage.value == i ? 20.w : 8.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                              color: c.currentPage.value == i
                                  ? AppColors.primary
                                  : AppColors.primary.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(height: 20.h),
                  Obx(() => c.currentPage.value < 4
                      ? GradientButton(
                          text: 'next'.tr,
                          onTap: c.nextPage,
                        )
                      : Obx(() => GradientButton(
                            text: 'get_started'.tr,
                            onTap: () => c.saveProfile(context),
                            isLoading: c.isLoading.value,
                          ))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final Color color;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.desc,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140.w,
            height: 140.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(40.r),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(icon, size: 64.sp, color: Colors.white),
          )
              .animate()
              .scale(duration: 500.ms, curve: Curves.elasticOut)
              .fadeIn(),
          SizedBox(height: 40.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.headlineMedium?.color,
            ),
          )
              .animate(delay: 100.ms)
              .slideY(begin: 0.3, duration: 400.ms)
              .fadeIn(),
          SizedBox(height: 16.h),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              color: Theme.of(context).textTheme.bodyMedium?.color,
              height: 1.6,
            ),
          )
              .animate(delay: 200.ms)
              .slideY(begin: 0.3, duration: 400.ms)
              .fadeIn(),
        ],
      ),
    );
  }
}

class _ProfileSetupPage extends StatelessWidget {
  final OnboardingController c;
  const _ProfileSetupPage({required this.c});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'setup_profile'.tr,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 6.h),
          Text(
            'Tell us about yourself to personalize your experience.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 24.h),
          _label(context, 'your_name'.tr),
          TextField(
            controller: c.nameController,
            decoration: InputDecoration(hintText: 'your_name'.tr),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label(context, 'your_age'.tr),
                    TextField(
                      controller: c.ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: '25'),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label(context, 'your_height'.tr),
                    TextField(
                      controller: c.heightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: '170 cm'),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label(context, 'your_weight'.tr),
                    TextField(
                      controller: c.weightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: '70 kg'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _label(context, 'your_gender'.tr),
          Obx(() => Row(
                children: [
                  _ChoiceChip(
                    label: 'male'.tr,
                    selected: c.selectedGender.value == 'male',
                    onTap: () => c.selectedGender.value = 'male',
                  ),
                  SizedBox(width: 10.w),
                  _ChoiceChip(
                    label: 'female'.tr,
                    selected: c.selectedGender.value == 'female',
                    onTap: () => c.selectedGender.value = 'female',
                  ),
                ],
              )),
          SizedBox(height: 16.h),
          _label(context, 'fitness_goal'.tr),
          Obx(() => Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  'lose_weight',
                  'maintain_weight',
                  'gain_muscle',
                ].map((g) => _ChoiceChip(
                      label: g.tr,
                      selected: c.selectedGoal.value == g,
                      onTap: () => c.selectedGoal.value = g,
                    )).toList(),
              )),
          SizedBox(height: 16.h),
          _label(context, 'activity_level'.tr),
          Obx(() => Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  'sedentary',
                  'lightly_active',
                  'moderately_active',
                  'very_active',
                  'extra_active',
                ].map((a) => _ChoiceChip(
                      label: a.tr,
                      selected: c.selectedActivity.value == a,
                      onTap: () => c.selectedActivity.value = a,
                    )).toList(),
              )),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _label(BuildContext context, String text) => Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
        ),
      );
}

class _ChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: selected
                ? AppColors.primary
                : Theme.of(context).dividerColor,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: selected ? Colors.white : null,
            fontWeight:
                selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
