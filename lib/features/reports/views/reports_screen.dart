import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_card.dart';
import '../controllers/report_controller.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ReportController>();
    return Scaffold(
      appBar: AppBar(title: Text('reports'.tr)),
      body: ListView(
        padding: EdgeInsets.all(20.r),
        children: [
          GradientCard(
            colors: AppColors.gradientPrimary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(Icons.picture_as_pdf_rounded,
                          color: Colors.white, size: 28.sp),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'report_title'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Your complete fitness summary',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: Obx(() => GradientButton(
                            text: c.isGenerating.value
                                ? 'generating_report'.tr
                                : 'preview_report'.tr,
                            colors: [
                              Colors.black,
                              Colors.white.withOpacity(0.85)
                            ],
                            isLoading: c.isGenerating.value,
                            onTap: () => c.previewPdf(),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.2),
          SizedBox(height: 20.h),

          // What's included
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('What\'s included',
                    style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 14.h),
                ...[
                  ('user_profile', Icons.person_rounded, AppColors.primary),
                  ('total_workouts', Icons.fitness_center_rounded, AppColors.secondary),
                  ('total_calories', Icons.local_fire_department_rounded, AppColors.warning),
                  ('completed_goals', Icons.flag_rounded, AppColors.accent),
                ].map((item) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(6.r),
                            decoration: BoxDecoration(
                              color: item.$3.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(item.$2, color: item.$3, size: 16.sp),
                          ),
                          SizedBox(width: 12.w),
                          Text(item.$1.tr,
                              style: TextStyle(fontSize: 14.sp)),
                          const Spacer(),
                          Icon(Icons.check_circle_rounded,
                              color: AppColors.accent, size: 16.sp),
                        ],
                      ),
                    )),
              ],
            ),
          )
              .animate(delay: 150.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.2),
          SizedBox(height: 16.h),

          Obx(() => GradientButton(
                text: 'share_report'.tr,
                icon: Icons.share_rounded,
                colors: AppColors.gradientSecondary,
                isLoading: c.isGenerating.value,
                onTap: () => c.generateAndShare(),
              ))
              .animate(delay: 300.ms)
              .fadeIn(duration: 400.ms),
        ],
      ),
    );
  }
}
