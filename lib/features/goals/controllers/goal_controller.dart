import 'package:get/get.dart';

import '../../../core/services/database_service.dart';
import '../models/goal_model.dart';

class GoalController extends GetxController {
  final _db = Get.find<DatabaseService>();
  final goals = <GoalModel>[].obs;
  final isLoading = false.obs;

  List<GoalModel> get active => goals.where((g) => !g.completed).toList();
  List<GoalModel> get completed => goals.where((g) => g.completed).toList();

  @override
  void onInit() {
    super.onInit();
    loadGoals();
  }

  Future<void> loadGoals() async {
    isLoading.value = true;
    goals.value = await _db.getGoals();
    isLoading.value = false;
  }

  Future<void> saveGoal(GoalModel goal) async {
    await _db.saveGoal(goal);
    await loadGoals();
  }

  Future<void> updateProgress(int id, double current) async {
    final list = await _db.getGoals();
    final goal = list.firstWhereOrNull((g) => g.id == id);
    if (goal == null) return;
    goal.current = current;
    if (current >= goal.target) goal.completed = true;
    await _db.saveGoal(goal);
    await loadGoals();
  }

  Future<void> deleteGoal(int id) async {
    await _db.deleteGoal(id);
    await loadGoals();
  }
}
