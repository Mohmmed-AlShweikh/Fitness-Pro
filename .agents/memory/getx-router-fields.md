---
name: GetX router fields
description: How to wire go_router inside GetMaterialApp with GetX 4.x
---

## Rule
Use three separate named fields on `GetMaterialApp.router`, not `routerConfig`:

```dart
GetMaterialApp.router(
  routeInformationParser: AppRoutes.router.routeInformationParser,
  routerDelegate: AppRoutes.router.routerDelegate,
  routeInformationProvider: AppRoutes.router.routeInformationProvider,
  ...
)
```

**Why:** GetX 4.6.x/4.7.x does not expose `routerConfig` on `GetMaterialApp.router`. Passing `routerConfig` causes a compile error ("named parameter not defined"). The three individual fields are the correct API surface.

**How to apply:** Whenever wiring go_router + GetX in this project, always use the three-field pattern above.
