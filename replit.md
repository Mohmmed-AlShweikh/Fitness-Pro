# FitTrack Pro

A complete Flutter fitness tracking app that runs in the browser (Flutter Web).

## Tech Stack
- **Flutter 3.32 / Dart 3.8** (web target)
- **GetX** – state management, dependency injection, translations (EN/AR)
- **go_router** – ShellRoute with 5-tab bottom nav
- **fl_chart** – weight progress chart
- **pdf + printing** – report generation
- **flutter_animate** – animations
- **flutter_screenutil** – responsive sizing
- **Google Fonts (Poppins)**
- **shared_preferences** – persistence (JSON over SharedPreferences; Isar removed for web compatibility)

## Project Structure
```
lib/
  main.dart                  # App entry point; initialises services
  app/
    app.dart                 # GetMaterialApp.router
    routes/app_routes.dart   # go_router ShellRoute + modal routes
    theme/                   # AppColors, AppTheme
    translations/            # EN + AR strings
    bindings/                # InitialBinding (lazy-puts all controllers)
  core/
    services/
      storage_service.dart   # SharedPreferences wrapper
      database_service.dart  # JSON CRUD for User/Workouts/Goals/Progress
    utils/
      calorie_calculator.dart
      responsive.dart
  features/
    splash/     home/       onboarding/
    workouts/   goals/      progress/
    reports/    profile/    settings/    timer/
  shared/widgets/            # Reusable UI components
```

## Running
The workflow runs:
```
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 5000
```

The built web output is in `build/web/`.

## User Preferences
- Keep all models as plain Dart classes with `toJson()`/`fromJson()` — no code generation.
- Never reintroduce Isar (incompatible with Flutter Web).
- Use `GetMaterialApp.router` with separate `routeInformationParser`, `routerDelegate`, and `routeInformationProvider` fields (GetX 4.x doesn't expose `routerConfig` directly).
