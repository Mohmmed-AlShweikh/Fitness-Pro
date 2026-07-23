import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/services/database_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../features/workouts/models/workout_model.dart';

class HomeController extends GetxController {
  final _db = Get.find<DatabaseService>();
  final storage = Get.find<StorageService>();

  final todayWorkouts = <WorkoutModel>[].obs;
  final todayCaloriesBurned = 0.obs;
  final dailyGoalPercent = 0.0.obs;
  final waterGlasses = 0.obs;
  final steps = 0.obs;
  final caloriesConsumed = 0.obs;
  final streak = 0.obs;

  static const int waterGoalGlasses = 8;
  static const int stepGoal = 10000;

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'good_morning'.tr;
    if (hour < 18) return 'good_afternoon'.tr;
    return 'good_evening'.tr;
  }

  @override
  void onInit() {
    super.onInit();
    _resetDailyDataIfNeeded();
    loadTodayData();
  }

  void _resetDailyDataIfNeeded() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (storage.lastResetDate != today) {
      storage.setLastResetDate(today);
      storage.setDailySteps(0);
      storage.setDailyWaterGlasses(0);
      storage.setDailyCaloriesConsumed(0);
    }
  }

  Future<void> loadTodayData() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final allWorkouts = await _db.getWorkouts();
    final todayList = allWorkouts
        .where((w) => w.date.isAfter(startOfDay) && w.date.isBefore(endOfDay))
        .toList();

    todayWorkouts.value = todayList;
    todayCaloriesBurned.value = todayList.fold(0, (sum, w) => sum + w.calories);

    waterGlasses.value = storage.dailyWaterGlasses;
    steps.value = storage.dailySteps;
    caloriesConsumed.value = storage.dailyCaloriesConsumed;
    streak.value = storage.workoutStreak;

    // Recompute streak from workout history
    await _recomputeStreak(allWorkouts);

    const totalGoalCal = 2000;
    dailyGoalPercent.value =
        (todayCaloriesBurned.value / totalGoalCal).clamp(0.0, 1.0);
  }

  Future<void> _recomputeStreak(List<WorkoutModel> allWorkouts) async {
    // Build a set of dates with at least one workout
    final workoutDates = <String>{};
    for (final w in allWorkouts) {
      workoutDates.add(DateFormat('yyyy-MM-dd').format(w.date));
    }

    int s = 0;
    var date = DateTime.now();
    while (true) {
      final key = DateFormat('yyyy-MM-dd').format(date);
      if (workoutDates.contains(key)) {
        s++;
        date = date.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    streak.value = s;
    await storage.setWorkoutStreak(s);
  }

  // Water glass actions
  Future<void> addWaterGlass() async {
    if (waterGlasses.value >= waterGoalGlasses) return;
    final next = waterGlasses.value + 1;
    waterGlasses.value = next;
    await storage.setDailyWaterGlasses(next);
  }

  Future<void> removeWaterGlass() async {
    if (waterGlasses.value <= 0) return;
    final next = waterGlasses.value - 1;
    waterGlasses.value = next;
    await storage.setDailyWaterGlasses(next);
  }

  // Steps actions
  Future<void> addSteps(int count) async {
    final next = steps.value + count;
    steps.value = next;
    await storage.setDailySteps(next);
  }

  // Calories consumed
  Future<void> addCaloriesConsumed(int cal) async {
    final next = caloriesConsumed.value + cal;
    caloriesConsumed.value = next;
    await storage.setDailyCaloriesConsumed(next);
    const totalGoalCal = 2000;
    dailyGoalPercent.value =
        (todayCaloriesBurned.value / totalGoalCal).clamp(0.0, 1.0);
  }

  double get dailyWater => storage.dailyWater;
  int get dailySteps => storage.dailySteps;
  int get dailyCaloriesConsumed => storage.dailyCaloriesConsumed;
}
