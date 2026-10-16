# Copilot instructions for C4 Dialer V2

## Project overview

This repository is a Flutter mobile app for `c4dialer_v2` with Firebase-backed auth, push notifications, analytics, and call-handling flows. The app entry point is `lib/main.dart`, which initializes Firebase, mobile ads, and the app-level `MultiProvider` setup before building the root `MaterialApp`.

The app pattern is:
- `lib/main.dart`: app bootstrap, Firebase initialization, provider registration, root theme and home screen selection
- `lib/provider/*.dart`: stateful view models (`AuthProvider`, `CategoryProviderViewModel`) used across screens
- `lib/*.dart` at the root: screen-level widgets and feature entry points
- `lib/Utils/`: shared colors, strings, analytics, common UI helpers and small utilities
- `lib/notification/`: notification setup and provider logic
- `lib/bottom_bar/` and `lib/widgets/`: UI composition and reusable navigation/widgets
- `lib/generated/` and generated Firebase config files: generated output; treat as build artifacts, not hand-authored domain logic

The README also calls out analytics conventions: page-level events should use stable `RouteSettings(name: 'ScreenName')`, and important interactions can be tracked with `AppAnalytics.trackClick(...)`.

## Build, test, and lint commands

Use the standard Flutter workflow for this repo:

- Install dependencies after manifest changes:
  - `flutter pub get`
- Run the analyzer:
  - `flutter analyze`
- Run the full test suite:
  - `flutter test`
- Run a single test file:
  - `flutter test test/widget_test.dart`
  - `flutter test test/review_prompt_test.dart`
- Run a single test case by name (when needed):
  - `flutter test test/widget_test.dart --plain-name "Counter increments smoke test"`
- Run the app locally:
  - `flutter run`
- Build platform artifacts when needed:
  - `flutter build apk`
  - `flutter build ios`

There is no custom project script wrapper; use the standard Flutter commands above unless a platform-specific setup step is required.

## Architecture and conventions

### Provider-driven app state

The app uses `provider` for app-wide state. `main.dart` registers the providers directly via `MultiProvider`:
- `CategoryProviderViewModel`
- `AuthProvider`
- `NotificationProvider`

Prefer following this existing pattern for UI state and cross-screen data rather than introducing a different state-management layer.

### Firebase and mobile runtime setup

The app initializes Firebase at startup and sets up Firebase Messaging background handling in `lib/main.dart`. The app also initializes Google Mobile Ads and stores session/login state via `SharedPreferences`.

When working around startup, auth, notification, or analytics flows, keep those integrations consistent with the existing setup rather than creating alternate initialization patterns.

### Screen and navigation patterns

Screen code is mostly organized at the root of `lib/` rather than in deeply nested feature folders. Navigation is standard Flutter `Navigator.push(...)`/`Navigator.pop(...)` flows, and analytics expects route names to remain stable for page-level reporting.

If you add a new screen or route that should be tracked, keep the route naming convention consistent with the analytics notes in the README.

### Shared utilities and config

- `lib/Utils/` contains app-wide constants and helper logic; prefer editing existing shared helpers over duplicating logic in individual screens.
- `lib/firebase_options.dart` is generated and should not be treated as a manual app configuration file unless you are intentionally regenerating Firebase config.
- `android/`, `ios/`, `windows/`, `web/`, and generated build output are platform/build artifacts; do not treat them as primary source-of-truth code unless the task specifically targets a platform integration.

### Testing expectations

The repo contains basic Flutter widget tests in `test/` and is not a large, highly abstracted test suite. Keep test coverage focused on behavior directly relevant to the screen or provider logic being changed.

## Relevant repo notes

- The app uses Firebase Analytics and should keep screen names stable for page-level reporting.
- The app uses `SharedPreferences` for persisted login status and selected call configuration.
- There are platform-specific call flows and native mobile permissions in the app; avoid breaking the Android/iOS branching logic when editing call-related code.
