# MeditaBK

A new Flutter project.

## Getting Started

FlutterFlow projects are built to run on the Flutter _stable_ release.

## Secrets & configuration

- Firebase config files are no longer committed. Before running builds, place your private `google-services.json` in `android/app/` and `GoogleService-Info.plist` in `ios/Runner/` (templates live next to them with the `.example` suffix).
- Web Firebase config is read from dart-define values; at minimum set `FIREBASE_WEB_API_KEY`, and optionally override `FIREBASE_AUTH_DOMAIN`, `FIREBASE_PROJECT_ID`, `FIREBASE_STORAGE_BUCKET`, `FIREBASE_MESSAGING_SENDER_ID`, `FIREBASE_APP_ID`, and `FIREBASE_MEASUREMENT_ID`.
- YouTube API calls expect a `YOUTUBE_API_KEY` provided via `--dart-define`. Keep keys in your secret manager and inject them per-environment (local dev, CI, production).
