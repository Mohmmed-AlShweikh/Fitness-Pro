import 'package:get/get.dart';

import '../../../core/services/database_service.dart';
import '../models/progress_model.dart';

class ProgressController extends GetxController {
  final _db = Get.find<DatabaseService>();
  final entries = <ProgressModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadEntries();
  }

  Future<void> loadEntries() async {
    isLoading.value = true;
    await _reloadEntries();
    isLoading.value = false;
  }

  Future<void> _reloadEntries() async {
    final all = await _db.getProgress();
    all.sort((a, b) => a.date.compareTo(b.date));
    entries.assignAll(all);
  }

  Future<void> addEntry(ProgressModel entry) async {
    await _db.saveProgress(entry);
    await _reloadEntries();
  }

  Future<void> deleteEntry(int id) async {
    await _db.deleteProgress(id);
    await _reloadEntries();
  }

  double? get latestWeight => entries.isEmpty ? null : entries.last.weight;
  double? get lowestWeight => entries.isEmpty
      ? null
      : entries.map((e) => e.weight).reduce((a, b) => a < b ? a : b);
  double? get highestWeight => entries.isEmpty
      ? null
      : entries.map((e) => e.weight).reduce((a, b) => a > b ? a : b);
}
