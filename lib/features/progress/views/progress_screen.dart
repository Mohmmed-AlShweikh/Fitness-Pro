import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/stat_tile.dart';
import '../controllers/progress_controller.dart';
import '../models/progress_model.dart';
import '../widgets/weight_chart.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProgressController>();
    return Scaffold(
      appBar: AppBar(title: Text('progress'.tr)),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: c.loadEntries,
          child: ListView(
            padding: EdgeInsets.all(16.r),
            children: [
              // Summary stats
              if (c.entries.isNotEmpty) ...[
                Row(
                  children: [
                    Expanded(
                      child: StatTile(
                        label: 'Current',
                        value: c.latestWeight?.toStringAsFixed(1) ?? '-',
                        unit: 'kg'.tr,
                        icon: Icons.monitor_weight_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: StatTile(
                        label: 'Lowest',
                        value: c.lowestWeight?.toStringAsFixed(1) ?? '-',
                        unit: 'kg'.tr,
                        icon: Icons.arrow_downward_rounded,
                        color: AppColors.accent,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: StatTile(
                        label: 'Highest',
                        value: c.highestWeight?.toStringAsFixed(1) ?? '-',
                        unit: 'kg'.tr,
                        icon: Icons.arrow_upward_rounded,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
              ],

              // Weight chart
              SectionHeader(title: 'weight_chart'.tr),
              SizedBox(height: 12.h),
              c.entries.isEmpty
                  ? EmptyState(
                      icon: Icons.show_chart_rounded,
                      message: 'no_progress'.tr,
                      actionLabel: 'add_progress'.tr,
                      onAction: () => _showAddSheet(context, c),
                    )
                  : WeightChart(entries: c.entries),

              SizedBox(height: 24.h),

              // History list
              if (c.entries.isNotEmpty) ...[
                SectionHeader(title: 'History'),
                SizedBox(height: 12.h),
                ...c.entries.reversed.take(10).map((e) => _ProgressTile(
                      entry: e,
                      onDelete: () => c.deleteEntry(e.id),
                    )),
              ],
              SizedBox(height: 80.h),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSheet(context, c),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  void _showAddSheet(BuildContext context, ProgressController c) {
    final weightCtrl = TextEditingController();
    final fatCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            20.w, 20.h, 20.w, MediaQuery.of(ctx).viewInsets.bottom + 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('add_progress'.tr,
                style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 16.h),
            TextField(
                controller: weightCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'weight'.tr, suffixText: 'kg'.tr)),
            SizedBox(height: 10.h),
            TextField(
                controller: fatCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'body_fat'.tr, suffixText: '%')),
            SizedBox(height: 10.h),
            TextField(
                controller: notesCtrl,
                decoration: InputDecoration(labelText: 'notes'.tr)),
            SizedBox(height: 20.h),
            GradientButton(
              text: 'save'.tr,
              onTap: () {
                final entry = ProgressModel(
                  weight: double.tryParse(weightCtrl.text) ?? 70,
                  bodyFat: double.tryParse(fatCtrl.text),
                  notes: notesCtrl.text.isEmpty ? null : notesCtrl.text,
                );
                c.addEntry(entry);
                Navigator.pop(ctx);
                Get.snackbar('✅', 'progress_saved'.tr,
                    snackPosition: SnackPosition.BOTTOM);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressTile extends StatelessWidget {
  final ProgressModel entry;
  final VoidCallback onDelete;

  const _ProgressTile({required this.entry, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 2.h),
      leading: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(Icons.monitor_weight_rounded,
            color: AppColors.primary, size: 20.sp),
      ),
      title: Text(
        '${entry.weight.toStringAsFixed(1)} kg',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp),
      ),
      subtitle: Text(
        '${entry.date.day}/${entry.date.month}/${entry.date.year}'
        '${entry.bodyFat != null ? ' · ${entry.bodyFat!.toStringAsFixed(1)}% fat' : ''}',
        style: TextStyle(fontSize: 12.sp),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete_outline_rounded,
            color: AppColors.error, size: 18.sp),
        onPressed: onDelete,
      ),
    );
  }
}
