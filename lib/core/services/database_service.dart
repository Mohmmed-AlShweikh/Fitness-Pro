import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/goals/models/goal_model.dart';
import '../../features/nutrition/models/meal_model.dart';
import '../../features/profile/models/user_model.dart';
import '../../features/progress/models/progress_model.dart';
import '../../features/workouts/models/workout_model.dart';

class DatabaseService extends GetxService {
  late SharedPreferences _prefs;

  static const _userKey = 'db_user';
  static const _workoutsKey = 'db_workouts';
  static const _goalsKey = 'db_goals';
  static const _progressKey = 'db_progress';
  static const _mealsKey = 'db_meals';
  static const _nextIdKey = 'db_next_id';

  Future<DatabaseService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // ── ID generator ──────────────────────────────────────────────────────────
  int _nextId() {
    final id = _prefs.getInt(_nextIdKey) ?? 1;
    _prefs.setInt(_nextIdKey, id + 1);
    return id;
  }

  // ── User ──────────────────────────────────────────────────────────────────
  Future<UserModel?> getUser() async {
    final raw = _prefs.getString(_userKey);
    if (raw == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveUser(UserModel user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  // ── Workouts ──────────────────────────────────────────────────────────────
  Future<List<WorkoutModel>> getWorkouts() async {
    final raw = _prefs.getString(_workoutsKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => WorkoutModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveWorkout(WorkoutModel workout) async {
    final list = await getWorkouts();
    if (workout.id == 0) workout.id = _nextId();
    final idx = list.indexWhere((w) => w.id == workout.id);
    if (idx >= 0) {
      list[idx] = workout;
    } else {
      list.add(workout);
    }
    await _prefs.setString(
        _workoutsKey, jsonEncode(list.map((w) => w.toJson()).toList()));
  }

  Future<void> deleteWorkout(int id) async {
    final list = await getWorkouts();
    list.removeWhere((w) => w.id == id);
    await _prefs.setString(
        _workoutsKey, jsonEncode(list.map((w) => w.toJson()).toList()));
  }

  Future<WorkoutModel?> getWorkoutById(int id) async {
    final list = await getWorkouts();
    try {
      return list.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }

  // ── Goals ─────────────────────────────────────────────────────────────────
  Future<List<GoalModel>> getGoals() async {
    final raw = _prefs.getString(_goalsKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => GoalModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveGoal(GoalModel goal) async {
    final list = await getGoals();
    if (goal.id == 0) goal.id = _nextId();
    final idx = list.indexWhere((g) => g.id == goal.id);
    if (idx >= 0) {
      list[idx] = goal;
    } else {
      list.add(goal);
    }
    await _prefs.setString(
        _goalsKey, jsonEncode(list.map((g) => g.toJson()).toList()));
  }

  Future<void> deleteGoal(int id) async {
    final list = await getGoals();
    list.removeWhere((g) => g.id == id);
    await _prefs.setString(
        _goalsKey, jsonEncode(list.map((g) => g.toJson()).toList()));
  }

  // ── Progress ──────────────────────────────────────────────────────────────
  Future<List<ProgressModel>> getProgress() async {
    final raw = _prefs.getString(_progressKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => ProgressModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveProgress(ProgressModel entry) async {
    final list = await getProgress();
    if (entry.id == 0) entry.id = _nextId();
    final idx = list.indexWhere((p) => p.id == entry.id);
    if (idx >= 0) {
      list[idx] = entry;
    } else {
      list.add(entry);
    }
    await _prefs.setString(
        _progressKey, jsonEncode(list.map((p) => p.toJson()).toList()));
  }

  Future<void> deleteProgress(int id) async {
    final list = await getProgress();
    list.removeWhere((p) => p.id == id);
    await _prefs.setString(
        _progressKey, jsonEncode(list.map((p) => p.toJson()).toList()));
  }

  // ── Meals (Nutrition) ─────────────────────────────────────────────────────
  Future<List<MealModel>> getMeals() async {
    final raw = _prefs.getString(_mealsKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => MealModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveMeal(MealModel meal) async {
    final list = await getMeals();
    if (meal.id == 0) meal.id = _nextId();
    final idx = list.indexWhere((m) => m.id == meal.id);
    if (idx >= 0) {
      list[idx] = meal;
    } else {
      list.add(meal);
    }
    await _prefs.setString(
        _mealsKey, jsonEncode(list.map((m) => m.toJson()).toList()));
  }

  Future<void> deleteMeal(int id) async {
    final list = await getMeals();
    list.removeWhere((m) => m.id == id);
    await _prefs.setString(
        _mealsKey, jsonEncode(list.map((m) => m.toJson()).toList()));
  }

  // ── Clear all ─────────────────────────────────────────────────────────────
  Future<void> clearAll() async {
    await _prefs.remove(_userKey);
    await _prefs.remove(_workoutsKey);
    await _prefs.remove(_goalsKey);
    await _prefs.remove(_progressKey);
    await _prefs.remove(_mealsKey);
  }
}
