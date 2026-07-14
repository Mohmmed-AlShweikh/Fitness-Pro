import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SettingsController>();
    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr)),
      body: ListView(
        children: [
          _SectionTitle('appearance'.tr),
          GetBuilder<SettingsController>(
            builder: (s) => Column(
              children: [
                _SettingsTile(
                  icon: Icons.light_mode_rounded,
                  iconColor: AppColors.warning,
                  title: 'theme'.tr,
                  subtitle: s.themeMode == ThemeMode.light
                      ? 'light_mode'.tr
                      : s.themeMode == ThemeMode.dark
                          ? 'dark_mode'.tr
                          : 'system_default'.tr,
                  onTap: () => _showThemePicker(context, c),
                ),
                _SettingsTile(
                  icon: Icons.language_rounded,
                  iconColor: AppColors.primary,
                  title: 'language'.tr,
                  subtitle: s.locale.languageCode == 'ar'
                      ? 'arabic'.tr
                      : 'english'.tr,
                  onTap: () => _showLanguagePicker(context, c),
                ),
              ],
            ),
          ),
          _SectionTitle('data'.tr),
          _SettingsTile(
            icon: Icons.delete_sweep_rounded,
            iconColor: AppColors.error,
            title: 'clear_data'.tr,
            subtitle: 'Delete all your fitness data',
            onTap: () => _confirmClear(context, c),
          ),
          _SectionTitle('about'.tr),
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            iconColor: AppColors.primary,
            title: 'about_app'.tr,
            subtitle: '${'version'.tr} 1.0.0',
            onTap: () => _showAbout(context),
          ),
        ],
      ),
    );
  }

  void _showThemePicker(BuildContext context, SettingsController c) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('theme'.tr, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 16.h),
            ...['system', 'light', 'dark'].map((mode) => ListTile(
                  leading: Icon(
                    mode == 'light'
                        ? Icons.light_mode_rounded
                        : mode == 'dark'
                            ? Icons.dark_mode_rounded
                            : Icons.settings_brightness_rounded,
                    color: AppColors.primary,
                  ),
                  title: Text(mode == 'light'
                      ? 'light_mode'.tr
                      : mode == 'dark'
                          ? 'dark_mode'.tr
                          : 'system_default'.tr),
                  onTap: () {
                    c.setTheme(mode);
                    Navigator.pop(ctx);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, SettingsController c) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('language'.tr, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 16.h),
            ListTile(
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
              title: Text('english'.tr),
              onTap: () {
                c.setLanguage('en');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Text('🇸🇦', style: TextStyle(fontSize: 24)),
              title: Text('arabic'.tr),
              onTap: () {
                c.setLanguage('ar');
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmClear(BuildContext context, SettingsController c) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('clear_data'.tr),
        content: Text('clear_data_confirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              c.clearAllData();
            },
            child: Text('confirm'.tr,
                style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'FitTrack Pro',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2024 FitTrack Pro',
      children: [
        SizedBox(height: 12.h),
        const Text(
            'A professional fitness tracking app to help you achieve your health goals.'),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 4.h),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, color: iconColor, size: 20.sp),
      ),
      title: Text(title, style: TextStyle(fontSize: 15.sp)),
      subtitle: Text(subtitle,
          style: TextStyle(fontSize: 12.sp,
              color: Theme.of(context).textTheme.bodyMedium?.color)),
      trailing: Icon(Icons.chevron_right_rounded,
          color: Theme.of(context).textTheme.bodyMedium?.color),
      onTap: onTap,
    );
  }
}
