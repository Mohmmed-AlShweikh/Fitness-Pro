import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../core/services/database_service.dart';

class ReportController extends GetxController {
  final _db = Get.find<DatabaseService>();
  final isGenerating = false.obs;

  Future<void> generateAndShare() async {
    isGenerating.value = true;
    try {
      final pdf = await _buildPdf();
      await Printing.sharePdf(
        bytes: pdf,
        filename: 'fittrack_report.pdf',
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate report',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isGenerating.value = false;
    }
  }

  Future<void> previewPdf() async {
    isGenerating.value = true;
    try {
      final pdf = await _buildPdf();
      await Printing.layoutPdf(
        onLayout: (_) async => pdf,
        name: 'FitTrack Report',
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to preview report',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isGenerating.value = false;
    }
  }

  Future<Uint8List> _buildPdf() async {
    final user = await _db.getUser();
    final workouts = await _db.getWorkouts();
    final goals = await _db.getGoals();

    final totalCalories =
        workouts.fold<int>(0, (sum, w) => sum + w.calories);
    final completedGoals = goals.where((g) => g.completed).length;

    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (ctx) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'FitTrack Pro — Fitness Report',
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.deepPurple,
                  ),
                ),
                pw.Text(
                  'Generated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  style: const pw.TextStyle(
                      fontSize: 10, color: PdfColors.grey600),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text('User Information',
              style: pw.TextStyle(
                  fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.Divider(),
          _row('Name', user?.name ?? 'N/A'),
          _row('Age', user != null ? '${user.age} years' : 'N/A'),
          _row('Height', user != null ? '${user.height} cm' : 'N/A'),
          _row('Weight', user != null ? '${user.weight} kg' : 'N/A'),
          _row('Goal', user?.fitnessGoal ?? 'N/A'),
          pw.SizedBox(height: 20),
          pw.Text('Statistics',
              style: pw.TextStyle(
                  fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.Divider(),
          _row('Total Workouts', '${workouts.length}'),
          _row('Total Calories Burned', '$totalCalories kcal'),
          _row('Completed Goals', '$completedGoals / ${goals.length}'),
          pw.SizedBox(height: 20),
          pw.Text('Recent Workouts',
              style: pw.TextStyle(
                  fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.Divider(),
          ...workouts.take(10).map((w) => pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 4),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(w.title,
                        style: const pw.TextStyle(fontSize: 12)),
                    pw.Text(
                      '${w.duration} min · ${w.calories} kcal',
                      style: const pw.TextStyle(
                          fontSize: 12, color: PdfColors.grey600),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
    return doc.save();
  }

  pw.Widget _row(String label, String value) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 4),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(label,
                style: pw.TextStyle(
                    fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.Text(value,
                style: const pw.TextStyle(
                    fontSize: 12, color: PdfColors.grey700)),
          ],
        ),
      );
}
