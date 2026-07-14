import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/custom_card.dart';
import '../models/workout_model.dart';

class ExerciseTile extends StatefulWidget {
  final int index;
  final ExerciseModel exercise;
  final VoidCallback onRemove;
  final ValueChanged<ExerciseModel> onChanged;

  const ExerciseTile({
    super.key,
    required this.index,
    required this.exercise,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  State<ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _setsCtrl;
  late final TextEditingController _repsCtrl;
  late final TextEditingController _weightCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.exercise.name ?? '');
    _setsCtrl = TextEditingController(text: (widget.exercise.sets ?? 3).toString());
    _repsCtrl = TextEditingController(text: (widget.exercise.reps ?? 10).toString());
    _weightCtrl = TextEditingController(text: (widget.exercise.weight ?? 0).toString());
  }

  void _notify() {
    widget.onChanged(ExerciseModel()
      ..name = _nameCtrl.text
      ..sets = int.tryParse(_setsCtrl.text) ?? 3
      ..reps = int.tryParse(_repsCtrl.text) ?? 10
      ..weight = double.tryParse(_weightCtrl.text) ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: AppCard(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${'exercises'.tr} ${widget.index + 1}',
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                ),
                GestureDetector(
                  onTap: widget.onRemove,
                  child: Icon(Icons.close_rounded, size: 18.sp, color: AppColors.error),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            TextField(
              controller: _nameCtrl,
              onChanged: (_) => _notify(),
              decoration: InputDecoration(hintText: 'exercise_name'.tr),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(child: _numField(_setsCtrl, 'sets'.tr)),
                SizedBox(width: 8.w),
                Expanded(child: _numField(_repsCtrl, 'reps'.tr)),
                SizedBox(width: 8.w),
                Expanded(child: _numField(_weightCtrl, 'weight'.tr)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _numField(TextEditingController ctrl, String hint) => TextField(
        controller: ctrl,
        onChanged: (_) => _notify(),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(hintText: hint),
        textAlign: TextAlign.center,
      );

  @override
  void dispose() {
    _nameCtrl.dispose();
    _setsCtrl.dispose();
    _repsCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }
}
