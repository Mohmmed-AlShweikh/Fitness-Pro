import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';
import '../controllers/workout_controller.dart';
import '../data/exercise_library.dart';
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

  void _addBlankExercise() {
    setState(() {
      _exercises.add(ExerciseModel(name: '', sets: 3, reps: 10, weight: 0));
    });
  }

  void _removeExercise(int i) {
    setState(() => _exercises.removeAt(i));
  }

  void _showExerciseLibrary() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ExerciseLibrarySheet(
        category: _category,
        onSelected: (name) {
          setState(() {
            _exercises.add(ExerciseModel(name: name, sets: 3, reps: 10, weight: 0));
          });
        },
      ),
    );
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workoutId == null ? 'add_workout'.tr : 'edit'.tr),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('workout_name'.tr),
            TextField(
              controller: _titleCtrl,
              decoration: InputDecoration(
                hintText: 'e.g. Morning Push Day',
                prefixIcon: const Icon(Icons.fitness_center_rounded),
              ),
            ),
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
                          horizontal: 16.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.darkCard
                                : AppColors.lightCard),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        cat.tr,
                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
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
                        decoration: InputDecoration(
                          hintText: '30',
                          suffixText: 'min'.tr,
                        ),
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
                        decoration: InputDecoration(
                          hintText: '200',
                          suffixText: 'kcal'.tr,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Exercises header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('exercises'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    // Library picker
                    GestureDetector(
                      onTap: _showExerciseLibrary,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                              color: AppColors.primary.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.library_books_rounded,
                                color: AppColors.primary, size: 14.sp),
                            SizedBox(width: 4.w),
                            Text('pick_from_library'.tr,
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Custom blank
                    GestureDetector(
                      onTap: _addBlankExercise,
                      child: Container(
                        padding: EdgeInsets.all(7.r),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(Icons.add_rounded,
                            color: AppColors.accent, size: 18.sp),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.h),

            if (_exercises.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20.h),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : const Color(0xFFF8F9FE),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                      color: AppColors.primary.withOpacity(0.15),
                      style: BorderStyle.solid),
                ),
                child: Column(
                  children: [
                    Icon(Icons.fitness_center_outlined,
                        color: AppColors.primary.withOpacity(0.4),
                        size: 32.sp),
                    SizedBox(height: 8.h),
                    Text(
                      'pick_from_library'.tr,
                      style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          fontSize: 13.sp),
                    ),
                  ],
                ),
              ),

            ..._exercises.asMap().entries.map((e) => ExerciseTile(
                  index: e.key,
                  exercise: e.value,
                  onRemove: () => _removeExercise(e.key),
                  onChanged: (ex) => setState(() => _exercises[e.key] = ex),
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

// ── Exercise Library Sheet ─────────────────────────────────────────────────────
class _ExerciseLibrarySheet extends StatefulWidget {
  final String category;
  final ValueChanged<String> onSelected;

  const _ExerciseLibrarySheet(
      {required this.category, required this.onSelected});

  @override
  State<_ExerciseLibrarySheet> createState() => _ExerciseLibrarySheetState();
}

class _ExerciseLibrarySheetState extends State<_ExerciseLibrarySheet> {
  String _searchQuery = '';
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category == 'all' ? 'chest' : widget.category;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final exercises = ExerciseLibrary.search(_searchQuery, _selectedCategory);
    final categories = ExerciseLibrary.byCategory.keys.toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        children: [
          // Handle
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 12.h, bottom: 16.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          // Title + search
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('exercise_library'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 12.h),
                TextField(
                  autofocus: false,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'search'.tr,
                    prefixIcon: const Icon(Icons.search_rounded),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 12.h),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          // Category tabs
          SizedBox(
            height: 36.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: categories.length,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (ctx, i) {
                final cat = categories[i];
                final selected = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : (isDark
                              ? AppColors.darkCard
                              : const Color(0xFFF0F0F0)),
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Text(
                      cat.tr,
                      style: TextStyle(
                        color: selected ? Colors.white : AppColors.primary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8.h),
          // Exercise list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              itemCount: exercises.length,
              itemBuilder: (ctx, i) {
                final name = exercises[i];
                return GestureDetector(
                  onTap: () {
                    widget.onSelected(name);
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(7.r),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(Icons.fitness_center_rounded,
                              color: AppColors.primary, size: 14.sp),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(name,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500)),
                        ),
                        Icon(Icons.add_circle_rounded,
                            color: AppColors.primary, size: 20.sp),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
