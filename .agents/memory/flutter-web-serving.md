---
name: Flutter Web serving
description: How FitTrack Pro is built and served on Replit for web preview
---

## Build command
```
flutter pub get          # if pub-cache is wiped
flutter build web --release
```

## Serving (SPA-aware)
Use `serve.py` (Python SPA server at project root) instead of `dhttpd`:
```
python3 serve.py 5000
```
**Why:** `dhttpd` has no SPA-fallback flag — any deep-link (`/home`, `/workouts`, etc.) returns 404 because those aren't real files. `serve.py` returns `index.html` for any path that isn't a real static file, so Flutter's service worker can install and GoRouter handles the routing client-side.

**Why not dhttpd:** `dhttpd 4.1.0` only supports `--port`, `--path`, `--host`, `--headers`. No `--default-document` or SPA mode.

## pub-cache disappears on Replit restarts
Run `dart pub global activate dhttpd` (or `flutter pub get`) before rebuilding if you get "No such file or directory" errors for `.pub-cache` packages.

## Service worker behaviour
- Flutter web bundles a versioned service worker (`v=<hash>`).
- First load: installs new SW, fetches all assets fresh.
- Subsequent loads: "Loading from existing SW" — serves cached files.
- Screenshot tool always captures the 2.2 s splash because Flutter always starts at `/splash`.

## Workflow config
```
name: Start application
command: python3 serve.py 5000
waitForPort: 5000
outputType: webview
```
