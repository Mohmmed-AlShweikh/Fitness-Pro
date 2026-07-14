import 'package:get/get.dart';

import '../../core/services/database_service.dart';
import '../../features/goals/controllers/goal_controller.dart';
import '../../features/home/controllers/home_controller.dart';
import '../../features/profile/controllers/profile_controller.dart';
import '../../features/progress/controllers/progress_controller.dart';
import '../../features/reports/controllers/report_controller.dart';
import '../../features/settings/controllers/settings_controller.dart';
import '../../features/timer/controllers/timer_controller.dart';
import '../../features/workouts/controllers/workout_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<WorkoutController>(() => WorkoutController(), fenix: true);
    Get.lazyPut<GoalController>(() => GoalController(), fenix: true);
    Get.lazyPut<ProgressController>(() => ProgressController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<ReportController>(() => ReportController(), fenix: true);
    Get.lazyPut<TimerController>(() => TimerController(), fenix: true);
    Get.lazyPut<SettingsController>(() => SettingsController(), fenix: true);
    // DatabaseService is already registered via Get.putAsync in main.dart
    Get.lazyPut<DatabaseService>(() => DatabaseService(), fenix: true);
  }
}
