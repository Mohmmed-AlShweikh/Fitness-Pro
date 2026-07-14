import 'package:get/get.dart';

import '../../../core/services/database_service.dart';
import '../../../core/utils/calorie_calculator.dart';
import '../models/user_model.dart';

class ProfileController extends GetxController {
  final _db = Get.find<DatabaseService>();
  final user = Rxn<UserModel>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  Future<void> loadUser() async {
    isLoading.value = true;
    user.value = await _db.getUser();
    isLoading.value = false;
  }

  Future<void> updateUser(UserModel updated) async {
    await _db.saveUser(updated);
    await loadUser();
    Get.snackbar('✅', 'profile_saved'.tr, snackPosition: SnackPosition.BOTTOM);
  }

  double? get bmi {
    final u = user.value;
    if (u == null) return null;
    return CalorieCalculator.calculateBMI(
        weightKg: u.weight, heightCm: u.height);
  }

  String get bmiCategory {
    final b = bmi;
    if (b == null) return '';
    return CalorieCalculator.bmiCategory(b).tr;
  }

  Map<String, int>? get calorieTargets {
    final u = user.value;
    if (u == null) return null;
    return CalorieCalculator.getCalorieTargets(
      weightKg: u.weight,
      heightCm: u.height,
      age: u.age,
      gender: u.gender,
      activityLevel: u.activityLevel,
    );
  }

  double? get bmr {
    final u = user.value;
    if (u == null) return null;
    return CalorieCalculator.calculateBMR(
      weightKg: u.weight,
      heightCm: u.height,
      age: u.age,
      gender: u.gender,
    );
  }
}
