import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/custom_card.dart';
import '../models/progress_model.dart';

class WeightChart extends StatelessWidget {
  final List<ProgressModel> entries;

  const WeightChart({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    if (entries.length == 1) {
      final entry = entries.first;
      return AppCard(
        child: SizedBox(
          height: 160.h,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.monitor_weight_rounded,
                    color: AppColors.primary, size: 36.sp),
                SizedBox(height: 10.h),
                Text(
                  '${entry.weight.toStringAsFixed(1)} kg',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${entry.date.day}/${entry.date.month}/${entry.date.year}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final spots = entries.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.weight);
    }).toList();

    final weights = entries.map((e) => e.weight).toList(growable: false);
    final lowest = weights.reduce((a, b) => a < b ? a : b);
    final highest = weights.reduce((a, b) => a > b ? a : b);
    final padding = lowest == highest ? 2.0 : 1.5;
    final minY = (lowest - padding).floorToDouble();
    final maxY = (highest + padding).ceilToDouble();

    return AppCard(
      padding: EdgeInsets.fromLTRB(12.w, 16.h, 16.w, 8.h),
      child: SizedBox(
        height: 200.h,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: (entries.length - 1).toDouble(),
            minY: minY,
            maxY: maxY,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) => FlLine(
                color: Theme.of(context).dividerColor,
                strokeWidth: 1,
                dashArray: [4, 4],
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36.w,
                  getTitlesWidget: (v, _) => Text(
                    v.toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, _) {
                    final i = v.toInt();
                    if (i < 0 || i >= entries.length) return const SizedBox();
                    final date = entries[i].date;
                    return Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text(
                        '${date.day}/${date.month}',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    );
                  },
                ),
              ),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                gradient:
                    const LinearGradient(colors: AppColors.gradientPrimary),
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (s, _, __, ___) => FlDotCirclePainter(
                    radius: 4,
                    color: AppColors.primary,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.25),
                      AppColors.primary.withOpacity(0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
