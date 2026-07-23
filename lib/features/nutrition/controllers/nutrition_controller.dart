import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/services/database_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../features/home/controllers/home_controller.dart';
import '../models/meal_model.dart';

class NutritionController extends GetxController {
  final _db = Get.find<DatabaseService>();
  final _storage = Get.find<StorageService>();

  final meals = <MealModel>[].obs;
  final isLoading = false.obs;
  final waterGlasses = 0.obs;

  static const int waterGoal = 8;
  static const int calorieGoal = 2000;

  int get todayCalories => meals.fold(0, (s, m) => s + m.calories);
  double get todayProtein => meals.fold(0.0, (s, m) => s + m.protein);
  double get todayCarbs => meals.fold(0.0, (s, m) => s + m.carbs);
  double get todayFat => meals.fold(0.0, (s, m) => s + m.fat);

  List<MealModel> get breakfast =>
      meals.where((m) => m.mealType == 'breakfast').toList();
  List<MealModel> get lunch =>
      meals.where((m) => m.mealType == 'lunch').toList();
  List<MealModel> get dinner =>
      meals.where((m) => m.mealType == 'dinner').toList();
  List<MealModel> get snacks =>
      meals.where((m) => m.mealType == 'snack').toList();

  @override
  void onInit() {
    super.onInit();
    loadTodayMeals();
    waterGlasses.value = _storage.dailyWaterGlasses;
  }

  Future<void> loadTodayMeals() async {
    isLoading.value = true;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final all = await _db.getMeals();
    meals.value = all
        .where((m) => DateFormat('yyyy-MM-dd').format(m.date) == today)
        .toList();
    isLoading.value = false;
  }

  Future<void> addMeal(MealModel meal) async {
    await _db.saveMeal(meal);
    await loadTodayMeals();
    // Sync to home controller
    if (Get.isRegistered<HomeController>()) {
      await Get.find<HomeController>().loadTodayData();
    }
  }

  Future<void> deleteMeal(int id) async {
    await _db.deleteMeal(id);
    await loadTodayMeals();
    if (Get.isRegistered<HomeController>()) {
      await Get.find<HomeController>().loadTodayData();
    }
  }

  Future<void> addWaterGlass() async {
    if (waterGlasses.value >= waterGoal) return;
    final next = waterGlasses.value + 1;
    waterGlasses.value = next;
    await _storage.setDailyWaterGlasses(next);
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().waterGlasses.value = next;
    }
  }

  Future<void> removeWaterGlass() async {
    if (waterGlasses.value <= 0) return;
    final next = waterGlasses.value - 1;
    waterGlasses.value = next;
    await _storage.setDailyWaterGlasses(next);
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().waterGlasses.value = next;
    }
  }
}
