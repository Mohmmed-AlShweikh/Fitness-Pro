import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/storage_service.dart';

class SettingsController extends GetxController {
  final storage = Get.find<StorageService>();

  late ThemeMode themeMode;
  late Locale locale;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    final mode = storage.themeMode;
    themeMode = mode == 'light'
        ? ThemeMode.light
        : mode == 'dark'
            ? ThemeMode.dark
            : ThemeMode.system;

    final lang = storage.language;
    locale = lang == 'ar' ? const Locale('ar', 'SA') : const Locale('en', 'US');
  }

  Future<void> setTheme(String mode) async {
    await storage.setThemeMode(mode);
    themeMode = mode == 'light'
        ? ThemeMode.light
        : mode == 'dark'
            ? ThemeMode.dark
            : ThemeMode.system;
    update();
    Get.forceAppUpdate();
  }

  Future<void> setLanguage(String lang) async {
    await storage.setLanguage(lang);
    locale =
        lang == 'ar' ? const Locale('ar', 'SA') : const Locale('en', 'US');
    Get.updateLocale(locale);
    update();
  }

  Future<void> clearAllData() async {
    await storage.clearAll();
    Get.snackbar('✅', 'data_cleared'.tr, snackPosition: SnackPosition.BOTTOM);
  }
}
