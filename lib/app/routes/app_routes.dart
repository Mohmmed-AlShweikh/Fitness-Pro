import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/goals/views/goals_screen.dart';
import '../../features/home/views/home_screen.dart';
import '../../features/onboarding/views/onboarding_screen.dart';
import '../../features/profile/views/profile_screen.dart';
import '../../features/progress/views/progress_screen.dart';
import '../../features/reports/views/reports_screen.dart';
import '../../features/settings/views/settings_screen.dart';
import '../../features/splash/views/splash_screen.dart';
import '../../features/timer/views/timer_screen.dart';
import '../../features/workouts/views/add_workout_screen.dart';
import '../../features/workouts/views/workouts_screen.dart';
import '../../shared/widgets/main_scaffold.dart';

abstract class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const workouts = '/workouts';
  static const addWorkout = '/add-workout';
  static const goals = '/goals';
  static const progress = '/progress';
  static const reports = '/reports';
  static const profile = '/profile';
  static const settings = '/settings';
  static const timer = '/timer';

  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: reports,
        builder: (context, state) => const ReportsScreen(),
      ),
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: timer,
        builder: (context, state) => const TimerScreen(),
      ),
      GoRoute(
        path: addWorkout,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return AddWorkoutScreen(workoutId: extra?['workoutId'] as int?);
        },
      ),
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: home,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: workouts,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: WorkoutsScreen()),
          ),
          GoRoute(
            path: goals,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: GoalsScreen()),
          ),
          GoRoute(
            path: progress,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProgressScreen()),
          ),
          GoRoute(
            path: profile,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),
    ],
  );
}
