---
name: Isar removed — web incompatible
description: Why Isar was removed and what replaced it
---

## Rule
Never add Isar (or isar_flutter_libs / isar_generator / build_runner) back to this project. All local persistence goes through `DatabaseService` (lib/core/services/database_service.dart), which stores JSON in SharedPreferences.

**Why:** Isar uses 64-bit schema ID integers that cannot be represented in JavaScript (Flutter Web compiles to JS). Its FFI native binaries also don't exist for the web target. The error manifests at runtime with cryptic JS integer overflow or missing symbol errors.

**How to apply:** All models are plain Dart classes with `toJson()`/`fromJson()`. DatabaseService provides CRUD for User, Workouts, Goals, and Progress entries with an auto-incrementing ID generator. No code generation step is needed.
