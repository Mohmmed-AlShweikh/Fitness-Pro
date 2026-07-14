import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_colors.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  int _locationToIndex(String location) {
    if (location.startsWith(AppRoutes.workouts)) return 1;
    if (location.startsWith(AppRoutes.goals)) return 2;
    if (location.startsWith(AppRoutes.progress)) return 3;
    if (location.startsWith(AppRoutes.profile)) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _locationToIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60.h,
            child: Row(
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'home'.tr,
                  index: 0,
                  currentIndex: currentIndex,
                  onTap: () => context.go(AppRoutes.home),
                ),
                _NavItem(
                  icon: Icons.fitness_center_rounded,
                  label: 'workouts'.tr,
                  index: 1,
                  currentIndex: currentIndex,
                  onTap: () => context.go(AppRoutes.workouts),
                ),
                _NavItem(
                  icon: Icons.flag_rounded,
                  label: 'goals'.tr,
                  index: 2,
                  currentIndex: currentIndex,
                  onTap: () => context.go(AppRoutes.goals),
                ),
                _NavItem(
                  icon: Icons.bar_chart_rounded,
                  label: 'progress'.tr,
                  index: 3,
                  currentIndex: currentIndex,
                  onTap: () => context.go(AppRoutes.progress),
                ),
                _NavItem(
                  icon: Icons.person_rounded,
                  label: 'profile'.tr,
                  index: 4,
                  currentIndex: currentIndex,
                  onTap: () => context.go(AppRoutes.profile),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;
    final activeColor = Theme.of(context).colorScheme.primary;
    final inactiveColor =
        Theme.of(context).bottomNavigationBarTheme.unselectedItemColor ??
            Colors.grey;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isActive
                    ? activeColor.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Icon(
                icon,
                color: isActive ? activeColor : inactiveColor,
                size: 22.sp,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
