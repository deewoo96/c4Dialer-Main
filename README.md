# c4dialer_v2

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Analytics

The app uses Firebase Analytics. Enable Google Analytics for the Firebase
project used by this app to see events in its linked GA4 property.

- `screen_view` is recorded when a named route or bottom-navigation tab is
  opened.
- `screen_time` records the number of foreground seconds spent on a screen
  when navigating away or backgrounding the app.
- `ui_click` is recorded for bottom-navigation taps and pushed-page navigation. Add
  `AppAnalytics.trackClick('action_name', screenName: 'Screen')` to other
  important actions that should be measured.

For page-level reports, set a stable `RouteSettings(name: 'ScreenName')` on
each pushed page route. Unnamed routes currently use their route class as a
fallback screen name and therefore won't be distinguishable from other
unnamed routes of the same class.
