import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
     final controller = Get.put(SplashController());

  WidgetsBinding.instance.addPostFrameCallback((_) {
    controller.navigate(context);
  });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.gradientPrimary,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 220.r,
                height: 220.r,
                decoration: BoxDecoration(
                 shape: BoxShape.circle
                ),
                child: Image.asset('assets/images/fitness.png'),
              )
                  .animate()
                  .scale(
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(),

              SizedBox(height: 24.h),

              Text(
                'FitTrack Pro',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              )
                  .animate(delay: 300.ms)
                  .slideY(
                    begin: 0.4,
                    duration: 500.ms,
                    curve: Curves.easeOut,
                  )
                  .fadeIn(),

              SizedBox(height: 8.h),

              Text(
                'Your fitness journey starts here',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14.sp,
                ),
              )
                  .animate(delay: 500.ms)
                  .fadeIn(),

              SizedBox(height: 40.h),

              SizedBox(
                width: 32.r,
                height: 32.r,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
                  .animate(delay: 800.ms)
                  .fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}