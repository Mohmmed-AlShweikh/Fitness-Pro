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
      storage.setDailyWater(0.0);
      storage.setDailyCaloriesConsumed(0);
    }
  }

  Future<void> loadTodayData() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final allWorkouts = await _db.getWorkouts();
    final todayList = allWorkouts
        .where((w) =>
            w.date.isAfter(startOfDay) && w.date.isBefore(endOfDay))
        .toList();

    todayWorkouts.value = todayList;
    todayCaloriesBurned.value =
        todayList.fold(0, (sum, w) => sum + w.calories);

    const totalGoalCal = 2000;
    final burned = todayCaloriesBurned.value;
    dailyGoalPercent.value = (burned / totalGoalCal).clamp(0.0, 1.0);
  }

  int get dailySteps => storage.dailySteps;
  double get dailyWater => storage.dailyWater;
  int get dailyCaloriesConsumed => storage.dailyCaloriesConsumed;
}
