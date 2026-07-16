import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/services/storage_service.dart';

class SplashController extends GetxController {

  void navigate(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 2200));

    final storage = Get.find<StorageService>();

    if (storage.isFirstTime || !storage.isProfileSetup) {
      context.go(AppRoutes.onboarding);
    } else {
      context.go(AppRoutes.home);
    }
  }
}