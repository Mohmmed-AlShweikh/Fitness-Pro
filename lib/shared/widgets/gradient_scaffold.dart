import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/theme/app_colors.dart';

class GradientScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBackButton;
  final List<Color> gradientColors;

  const GradientScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.showBackButton = true,
    this.gradientColors = AppColors.gradientPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: title != null
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                title!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              actions: actions,
            )
          : null,
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: [
          Container(
            height: 280.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          body,
        ],
      ),
    );
  }
}
