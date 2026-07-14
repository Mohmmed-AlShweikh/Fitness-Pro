import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Theme
  String get themeMode => _prefs.getString('theme_mode') ?? 'system';
  Future<void> setThemeMode(String mode) => _prefs.setString('theme_mode', mode);

  // Language
  String get language => _prefs.getString('language') ?? 'en';
  Future<void> setLanguage(String lang) => _prefs.setString('language', lang);

  // Onboarding
  bool get isFirstTime => _prefs.getBool('is_first_time') ?? true;
  Future<void> setFirstTimeDone() => _prefs.setBool('is_first_time', false);

  // Profile setup
  bool get isProfileSetup => _prefs.getBool('profile_setup') ?? false;
  Future<void> setProfileSetup() => _prefs.setBool('profile_setup', true);

  // Daily goals (simple counters reset daily)
  String get lastResetDate => _prefs.getString('last_reset_date') ?? '';
  Future<void> setLastResetDate(String date) =>
      _prefs.setString('last_reset_date', date);

  int get dailySteps => _prefs.getInt('daily_steps') ?? 0;
  Future<void> setDailySteps(int steps) => _prefs.setInt('daily_steps', steps);

  double get dailyWater => _prefs.getDouble('daily_water') ?? 0.0;
  Future<void> setDailyWater(double liters) =>
      _prefs.setDouble('daily_water', liters);

  int get dailyCaloriesConsumed =>
      _prefs.getInt('daily_calories_consumed') ?? 0;
  Future<void> setDailyCaloriesConsumed(int cal) =>
      _prefs.setInt('daily_calories_consumed', cal);

  Future<void> clearAll() => _prefs.clear();
}
