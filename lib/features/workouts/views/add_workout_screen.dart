import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';
import '../controllers/workout_controller.dart';
import '../models/workout_model.dart';
import '../widgets/exercise_tile.dart';

class AddWorkoutScreen extends StatefulWidget {
  final int? workoutId;
  const AddWorkoutScreen({super.key, this.workoutId});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final _titleCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  final _caloriesCtrl = TextEditingController();
  String _category = 'chest';
  final List<ExerciseModel> _exercises = [];
  bool _isSaving = false;

  final _categories = ['chest', 'back', 'legs', 'arms', 'cardio', 'full_body'];

  @override
  void initState() {
    super.initState();
    if (widget.workoutId != null) _loadExisting();
  }

  Future<void> _loadExisting() async {
    final c = Get.find<WorkoutController>();
    final w = await c.getWorkout(widget.workoutId!);
    if (w != null && mounted) {
      setState(() {
        _titleCtrl.text = w.title;
        _durationCtrl.text = w.duration.toString();
        _caloriesCtrl.text = w.calories.toString();
        _category = w.category;
        _exercises.addAll(w.exercises);
      });
    }
  }

  void _addExercise() {
    setState(() {
      _exercises.add(ExerciseModel(name: '', sets: 3, reps: 10, weight: 0));
    });
  }

  void _removeExercise(int i) {
    setState(() => _exercises.removeAt(i));
  }

  Future<void> _save() async {
    if (_titleCtrl.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a workout name',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    setState(() => _isSaving = true);

    final workout = WorkoutModel(
      id: widget.workoutId ?? 0,
      title: _titleCtrl.text.trim(),
      category: _category,
      duration: int.tryParse(_durationCtrl.text) ?? 30,
      calories: int.tryParse(_caloriesCtrl.text) ?? 200,
      date: DateTime.now(),
      exercises: List.from(_exercises),
    );

    await Get.find<WorkoutController>().saveWorkout(workout);

    setState(() => _isSaving = false);
    Get.snackbar('✅', 'workout_saved'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.accent.withValues(alpha: 0.9),
        colorText: Colors.white);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.workoutId == null ? 'add_workout'.tr : 'edit'.tr),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('workout_name'.tr),
            TextField(
                controller: _titleCtrl,
                decoration:
                    InputDecoration(hintText: 'e.g. Morning Push Day')),
            SizedBox(height: 16.h),
            _label('category'.tr),
            SizedBox(
              height: 38.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => SizedBox(width: 8.w),
                itemBuilder: (ctx, i) {
                  final cat = _categories[i];
                  final selected = _category == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _category = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : Theme.of(context).dividerColor,
                        ),
                      ),
                      child: Text(
                        cat.tr,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: selected ? Colors.white : null,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('duration'.tr),
                      TextField(
                        controller: _durationCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: '30'),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('calories'.tr),
                      TextField(
                        controller: _caloriesCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: '200'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('exercises'.tr,
                    style: Theme.of(context).textTheme.titleMedium),
                TextButton.icon(
                  onPressed: _addExercise,
                  icon: const Icon(Icons.add_rounded),
                  label: Text('add_exercise'.tr),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            ..._exercises.asMap().entries.map((e) => ExerciseTile(
                  index: e.key,
                  exercise: e.value,
                  onRemove: () => _removeExercise(e.key),
                  onChanged: (ex) =>
                      setState(() => _exercises[e.key] = ex),
                )),
            SizedBox(height: 32.h),
            GradientButton(
              text: 'save'.tr,
              onTap: _save,
              isLoading: _isSaving,
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Text(text,
            style: TextStyle(
                fontSize: 13.sp, fontWeight: FontWeight.w600)),
      );

  @override
  void dispose() {
    _titleCtrl.dispose();
    _durationCtrl.dispose();
    _caloriesCtrl.dispose();
    super.dispose();
  }
}
