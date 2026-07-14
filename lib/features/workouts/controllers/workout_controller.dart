import 'package:get/get.dart';

import '../../../core/services/database_service.dart';
import '../models/workout_model.dart';

class WorkoutController extends GetxController {
  final _db = Get.find<DatabaseService>();
  final workouts = <WorkoutModel>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final selectedCategory = 'all'.obs;

  List<WorkoutModel> get filtered {
    var list = workouts.toList();
    if (selectedCategory.value != 'all') {
      list = list.where((w) => w.category == selectedCategory.value).toList();
    }
    if (searchQuery.value.isNotEmpty) {
      list = list
          .where((w) =>
              w.title.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  void onInit() {
    super.onInit();
    loadWorkouts();
  }

  Future<void> loadWorkouts() async {
    isLoading.value = true;
    workouts.value = await _db.getWorkouts();
    isLoading.value = false;
  }

  Future<void> saveWorkout(WorkoutModel workout) async {
    await _db.saveWorkout(workout);
    await loadWorkouts();
  }

  Future<void> deleteWorkout(int id) async {
    await _db.deleteWorkout(id);
    await loadWorkouts();
  }

  Future<WorkoutModel?> getWorkout(int id) => _db.getWorkoutById(id);

  void setSearch(String q) => searchQuery.value = q;
  void setCategory(String cat) => selectedCategory.value = cat;
}
