---
name: Flutter Web serving
description: How to serve Flutter web builds in Replit preview reliably
---

## Rule
Use `dhttpd --path build/web --port 5000 --host 0.0.0.0` to serve the pre-built release output. Do NOT use `flutter run -d web-server` as the workflow command — it takes 40+ seconds to compile on each restart and causes blank-screen timeouts in the screenshot tool.

**Why:** `flutter run` recompiles Dart on every cold start (debug mode). The pre-built `build/web` folder is instant. Install dhttpd once: `dart pub global activate dhttpd`, then call it via `$HOME/.pub-cache/bin/dhttpd`.

**How to apply:** After any code change, run `flutter build web --release` from the project root, then restart the workflow. The workflow command stays as the dhttpd static-serve invocation.

## Service worker warning
The release build registers a service worker. In Replit's proxied iframe the SW registration may fail with "Exception while loading service worker" — this is harmless. Flutter falls back to direct JS loading and the app renders normally.
