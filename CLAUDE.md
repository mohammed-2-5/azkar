# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Azkar is a Flutter-based Islamic application for prayer times, Qiblah direction, Quran reading with memorization features, and daily Azkar (remembrances). The app uses BLoC pattern for state management and supports Arabic/English localization.

## Build and Development Commands

### Dependencies and Setup
- `flutter pub get` — Install/update dependencies
- `flutter pub run build_runner build` — Generate code (assets, etc.)
- `flutter pub run build_runner build --delete-conflicting-outputs` — Force regenerate

### Running the App
- `flutter run` — Run on default device
- `flutter run -d windows` — Run on Windows
- `flutter run -d chrome` — Run on web
- `flutter run -d <device-id>` — Run on specific device

### Testing
- `flutter test` — Run all tests
- `flutter test test/core/notification_scheduler_test.dart` — Run specific test file

### Code Quality
- `flutter analyze` — Static analysis
- `dart format .` — Format all Dart code

### Building
- `flutter build apk` — Build Android APK
- `flutter build appbundle` — Build Android App Bundle
- `flutter build windows` — Build Windows desktop app
- `flutter build web` — Build web app

## Architecture

### Application Bootstrap (lib/app/app.dart)
The app initializes through `AppBootstrap.init()` which:
1. Initializes Flutter bindings
2. Sets up Hive (local database)
3. Initializes notification service and timezone data
4. Creates `AppDependencies` containing core services

Entry point: `lib/main.dart` wraps the app in `PermissionGate` for location/notification permissions before rendering the main `App`.

### State Management
Uses `flutter_bloc` with the following global cubits:
- `PrayerTimesCubit` — Manages prayer time calculations, location, and scheduling
- `QiblahCubit` — Manages Qiblah compass and direction
- `AzkarCubit` — Manages Azkar categories, favorites, and progress tracking
- `QuranCubit` — Manages Quran reading, bookmarks, and tafseer
- `MemorizationCubit` — Manages Quran memorization deck
- `ThemeCubit` — Theme mode and color seed
- `LocaleCubit` — Locale switching (ar/en)

All cubits are provided globally in `lib/app/app.dart` and injected via `BlocProvider`.

### Routing
Uses `go_router` with a `ShellRoute` containing the bottom navigation scaffold (`_NavScaffold`). Main routes defined in `lib/app/router.dart`:
- `/prayer` — Prayer times (initial route)
- `/qiblah` — Qiblah compass
- `/quran` — Quran index
- `/quran/:id` — Quran reader for specific surah
- `/azkar` — Azkar browser
- `/notifications`, `/appearance`, `/language` — Settings pages

### Feature Structure
Features follow clean architecture with domain/data/presentation layers:

```
lib/features/<feature>/
  ├── data/
  │   ├── models/          # Data models
  │   ├── <feature>_repository.dart  # Data fetching/asset loading
  │   └── <feature>_storage.dart     # Hive/SharedPreferences persistence
  ├── domain/              # Business logic entities (optional)
  └── presentation/
      ├── cubit/          # BLoC state management
      ├── pages/          # Full-screen pages
      └── widgets/        # Reusable UI components
```

**Prayer Times**: Calculates Islamic prayer times using the `adhan` package with customizable calculation methods (MWL, ISNA, etc.), madhabs, and high-latitude rules. Times are computed via `PrayerCalculator` and scheduled notifications via `NotificationScheduler`. Supports device location or manual location selection.

**Qiblah**: Uses `flutter_qiblah` package with device sensors to show Qiblah direction via compass widget.

**Quran**: Loads surah headers and verses from JSON assets (`assets/quran/chapters/ar/*.json` and `assets/quran/chapters/en/*.json`). Supports:
- Two layout modes: `tiles` (verse-by-verse list) and `mushaf` (page-like continuous scroll)
- Bookmarks, last-read tracking, tafseer (from `assets/tafseer.json`)
- Memorization deck using spaced repetition (stored in Hive)
- Word-by-word translations

**Azkar**: Loads Azkar items from JSON assets (`assets/azkar/*.json`), organized by category. Tracks daily progress, favorites, and repeat counts using Hive storage.

### Core Services (lib/core/services/)
- `LocationService` — Wraps `geolocator` for GPS access
- `NotificationService` — Wraps `flutter_local_notifications` for platform notifications
- `NotificationScheduler` — Schedules prayer notifications with lead time, quiet hours, and azan audio

### Localization
Generated via `flutter_localizations` with ARB files. Access via:
```dart
final l10n = AppLocalizations.of(context)!;
```
Locale state managed by `LocaleCubit` and persisted to SharedPreferences.

### Data Persistence
- **Hive**: Used for Azkar favorites/progress and Quran memorization deck
- **SharedPreferences**: Used for prayer calculation settings, notification preferences, theme/locale, and Quran bookmarks/last-read

### Notification System
Prayer notifications are scheduled using `timezone` package with:
- Lead time (e.g., 10 minutes before prayer)
- Per-prayer enable/disable (Fajr, Dhuhr, Asr, Maghrib, Isha)
- Quiet hours (no notifications during specified time window)
- Azan audio playback (using `just_audio` package)

Notifications are rescheduled daily at midnight and when settings change.

## Development Guidelines

### When Adding New Features
1. Follow the feature folder structure above
2. Create models in `data/models/` with `Equatable` for value comparison
3. Add repository for data loading and storage for persistence
4. Create cubit with immutable state classes using `copyWith` pattern
5. Provide cubit in `lib/app/app.dart` if global, or locally in page if feature-scoped
6. Add routes in `lib/app/router.dart` if creating new pages

### Asset Management
Assets are declared in `pubspec.yaml`. To add new assets:
1. Place files in appropriate `assets/` subdirectory
2. Add path to `pubspec.yaml` under `flutter.assets`
3. Run `flutter pub run build_runner build` if using code generation
4. Access via `rootBundle.loadString()` or generated `Assets` class

### Notification Development
For prayer notification changes, ensure you:
1. Update `NotificationPrefs` if adding new settings
2. Persist new settings in `PrayerTimesCubit.saveNotificationPrefs()`
3. Re-schedule notifications after settings changes via `NotificationScheduler.scheduleForTimes()`

### Testing Notifications
Use `PrayerTimesCubit.scheduleTestNotification()` which triggers an immediate demo notification without waiting for actual prayer time.

### Quran Asset Updates
Quran data is loaded from JSON files. Each surah has:
- `assets/quran/chapters/ar/<id>.json` (required) — Arabic text
- `assets/quran/chapters/en/<id>.json` (optional) — English translation/transliteration

The repository falls back to Arabic-only if English file is missing.

### Important Conventions
- Use `const` constructors wherever possible for performance
- State classes must be immutable with `Equatable` and `copyWith`
- Use `dev.log()` with named loggers for debugging (e.g., `name: 'quran.cubit'`)
- Keep widget files focused: extract complex widgets into separate files under `widgets/`
- Localize all user-facing strings; never hardcode English/Arabic text in widgets
