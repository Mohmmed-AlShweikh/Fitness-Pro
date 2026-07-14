import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/services/storage_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2200));
    final storage = Get.find<StorageService>();

    final context = Get.context;
    if (context == null) return;

    if (storage.isFirstTime || !storage.isProfileSetup) {
      GoRouter.of(context).go(AppRoutes.onboarding);
    } else {
      GoRouter.of(context).go(AppRoutes.home);
    }
  }
}
