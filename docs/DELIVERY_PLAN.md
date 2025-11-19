# Delivery Plan (Phased)

## Phase 0 – Foundation & Setup
- Routing (`go_router`), base shell with 3 tabs (Prayer, Qiblah, Azkar).
- Services: location, notifications, storage (Hive), timezone init.
- Android/iOS permissions and desugaring (done): enable core library desugaring and add `desugar_jdk_libs`.
- Outcomes: app boots, routes exist, CI basics (analyze/format/test) pass.

## Phase 1 – Prayer Times
- Compute daily times with `adhan`, configurable method/madhab/high‑latitude.
- Location acquisition + graceful errors, cache today’s times.
- UI: list all prayers, highlight next prayer, countdown.
- Tests: logic + DST/high‑latitude sanity.

## Phase 2 – Qiblah Compass
- Stream heading via `flutter_qiblah`, handle sensor absence/calibration.
- UI: compass with Kaaba bearing and accuracy states.
- Tests: Cubit ready/error flows.

## Phase 3 – Azkar
- JSON repository → model; categories (Morning, Evening, Salah, etc.).
- UI: lists + detail with repeat counter, favorites, last progress.
- Persistence: Hive boxes for bookmarks/history.
- Tests: parsing + state transitions.

## Phase 4 – Notifications & Scheduling
- Local notifications per prayer with lead time; reschedule on day/timezone change.
- Optional: quiet hours, per‑prayer toggles.
- Tests: schedule computation; manual device checks.

## Phase 5 – Navigation, UI & Theming
- `go_router` deep links; bottom navigation; state restoration.
- Theming (light/dark), typography, RTL layout, accessibility.

## Phase 6 – i18n & Content
- Localize strings (en/ar) with `intl` and ARB files.
- Expand Azkar content; search and filters.

## Phase 7 – QA, Build & Release
- Widget/integration smoke tests; performance pass.
- App icon, splash, versioning, store metadata.
- Builds: `flutter build apk`, `ipa`, `web`; release checklist.

## Now
- Android build fix applied: desugaring enabled in `android/app/build.gradle.kts` and `desugar_jdk_libs` added.
- Next run: `flutter pub get`, then `flutter run` (or `flutter build apk`).
