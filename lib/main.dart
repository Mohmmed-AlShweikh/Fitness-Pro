import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'app/app.dart';
import 'core/services/database_service.dart';
import 'core/services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service (SharedPreferences)
  await Get.putAsync(() => StorageService().init());

  // Initialize JSON database service
  await Get.putAsync(() => DatabaseService().init());

  runApp(
    ScreenUtilInit(
      designSize: const Size(411, 914),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => const FitTrackApp(),
    ),
  );
}
