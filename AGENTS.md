# Repository Guidelines

## Project Structure & Module Organization
- `lib/` — Dart source (entry: `lib/main.dart`). Organize by feature: `lib/features/<feature>/`, shared UI in `lib/ui/widgets/`, core in `lib/core/`.
- `test/` — Unit/widget tests mirroring `lib/` (e.g., `test/features/<feature>/..._test.dart`).
- Platforms: `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/`.
- Config: `pubspec.yaml` (dependencies, assets), `analysis_options.yaml` (lints), `l10n.yaml` (localization).

## Build, Test, and Development Commands
- `flutter pub get` — Install/update dependencies.
- `flutter run -d <device>` — Run locally (e.g., `-d chrome`, `-d windows`).
- `flutter analyze` — Static analysis with `flutter_lints`.
- `dart format .` — Format code in place.
- `flutter test` — Run unit/widget tests.
- Common builds: `flutter build apk`, `flutter build web`, `flutter build windows`.

## Coding Style & Naming Conventions
- Indentation: 2 spaces; run `dart format` before commits.
- Files: `snake_case.dart` (e.g., `prayer_times_page.dart`).
- Types (classes, enums): `PascalCase`; variables/methods: `lowerCamelCase`.
- Constants: prefer `const`/`static const` in `lowerCamelCase` (no `k` prefixes).
- Keep files concise (<250 lines). Extract UI into small widgets and logic into helpers/extensions.

## Testing Guidelines
- Framework: `flutter_test`.
- Mirror `lib/` paths under `test/` with `*_test.dart` names.
- Use `group` and behavior-focused names. Keep tests deterministic and fast.

## Commit & Pull Request Guidelines
- Conventional Commits: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `build:`, `ci:`, `chore:`.
- Subjects are present-tense and concise; include scope when helpful (e.g., `feat(quran): reader screen`).
- PRs: include summary, rationale, linked issues, and screenshots/GIFs for UI changes.
- Before PR: run `dart format --output=none --set-exit-if-changed .`, `flutter analyze`, and `flutter test`.

## Security & Configuration Tips
- Never commit secrets. Pass values via `--dart-define=KEY=VALUE` and read with `const String.fromEnvironment`.
- Declare assets and fonts in `pubspec.yaml`; avoid unused assets.

## Agent-Specific Instructions
- Keep changes focused; avoid unrelated refactors.
- Match the structure above for new code; add brief docs where clarity helps.
