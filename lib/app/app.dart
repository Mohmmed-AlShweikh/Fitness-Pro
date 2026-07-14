import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/bindings/initial_binding.dart';
import '../app/routes/app_routes.dart';
import '../app/theme/app_theme.dart';
import '../app/translations/app_translations.dart';
import '../features/settings/controllers/settings_controller.dart';

class FitTrackApp extends StatelessWidget {
  const FitTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      init: SettingsController(),
      builder: (settings) {
        return GetMaterialApp.router(
          title: 'FitTrack Pro',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,
          translations: AppTranslations(),
          locale: settings.locale,
          fallbackLocale: const Locale('en', 'US'),
          routeInformationParser: AppRoutes.router.routeInformationParser,
          routerDelegate: AppRoutes.router.routerDelegate,
          routeInformationProvider: AppRoutes.router.routeInformationProvider,
          initialBinding: InitialBinding(),
        );
      },
    );
  }
}
