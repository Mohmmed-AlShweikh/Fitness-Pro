import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/services/database_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../features/profile/models/user_model.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;

  // Form fields
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  final selectedGender = 'male'.obs;
  final selectedGoal = 'lose_weight'.obs;
  final selectedActivity = 'moderately_active'.obs;

  final isLoading = false.obs;

  void nextPage() {
    if (currentPage.value < 4) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void onPageChanged(int page) => currentPage.value = page;

  Future<void> saveProfile(BuildContext context) async {
    final name = nameController.text.trim();
    final age = int.tryParse(ageController.text.trim()) ?? 25;
    final height = double.tryParse(heightController.text.trim()) ?? 170;
    final weight = double.tryParse(weightController.text.trim()) ?? 70;

    if (name.isEmpty) {
      Get.snackbar('Error', 'Please enter your name',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    final user = UserModel(
      id: 1,
      name: name,
      age: age,
      height: height,
      weight: weight,
      gender: selectedGender.value,
      fitnessGoal: selectedGoal.value,
      activityLevel: selectedActivity.value,
    );

    final db = Get.find<DatabaseService>();
    await db.saveUser(user);

    final storage = Get.find<StorageService>();
    await storage.setFirstTimeDone();
    await storage.setProfileSetup();

    isLoading.value = false;

    if (context.mounted) {
      GoRouter.of(context).go(AppRoutes.home);
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    nameController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.onClose();
  }
}
