# Product Roadmap

This document captures the remaining plan for the app and a focused roadmap for the Qur’an feature. It is implementation‑oriented and grouped by phases to keep delivery incremental and testable.

## App Roadmap (All Features)

- Phase 0 — Foundation (done)
  - Project structure, l10n, routing, theming, CI basics.
- Phase 1 — Prayer Times (complete/iterate)
  - Device location; calculation settings; notifications; countdown; city search.
  - Iteration: exact alarms fallback UI, edge cases (high latitude), battery rules docs.
- Phase 2 — Qiblah (complete/iterate)
  - Compass with calibration hints; Islamic arrow; edge handling and smoothing.
- Phase 3 — Azkar (complete/iterate)
  - Categories, cards, details, favorites; share/copy.
- Phase 4 — Appearance & Language
  - System/dark/light; color seeds; AR/EN toggle; Arabic‑Indic digits.
- Phase 5 — Notifications & Schedules
  - Quiet hours; per‑prayer lead time; bulk reschedule; reliability watchdog.
- Phase 6 — Qur’an (in progress)
  - Reader UI (Tiles + Mushaf), search, quick jump, anchors + autoscroll.
- Phase 7 — Data & Offline
  - Robust asset/version checks; optional packs (audio, tafsir, fonts); cache policies.
- Phase 8 — Quality & DX
  - Widget tests for critical flows; performance traces; crash/log pipeline; in‑app diagnostics page.

## Qur’an Roadmap (Focused)

- Phase A — Anchors & Scrolling (done)
  - AyahRef, anchors for both views, ensureVisible autoscroll, shared registry.
- Phase B — Search v1 (done)
  - Arabic diacritics‑insensitive search (local surah) with highlights.
- Phase C — Deep Link v1 (done)
  - Router `?ayah=` support; reader scrolls after first frame.
- Phase D — Quick Jump v1 (done)
  - Surah picker + Recent positions; autoscroll into ayah.
- Phase E — Global Search v2
  - Build a lightweight index across all surahs (normalize AR + EN); fast results with surah/juz/page chips; navigate with autoscroll + flash highlight.
- Phase F — Page/Juz Metadata
  - Add per‑ayah metadata (page, juz, hizb, sajda). Show ribbons in header and soft page breaks in Mushaf. Quick Jump tabs: Juz | Page.
- Phase G — Audio & Recitation
  - 1–2 reciters (stream + offline), aya‑sync highlighting, A–B loop, background controls. Tie callbacks to anchors for smooth follow‑along.
- Phase H — Tafsir & Word‑by‑Word
  - Pluggable tafsir packs (e.g., Saadi, Jalalayn), offline caching; word‑by‑word meanings popup; basic morphology/roots (if data available).
- Phase I — Memorization Tools
  - Spaced repetition sets, hide‑words modes, daily targets, streaks, recap review. Progress stored per user device.
- Phase J — Share & Social
  - Share as image (templates with backgrounds, logo), deep links to ayah; optional private “study circle” notes.
- Phase K — Typography & Mushaf Polish
  - Uthmani font option, better ligatures/kerning; classic page backgrounds; exact pagination (TextPainter flow) and per‑page navigation.
- Phase L — Accessibility & Intl
  - Screen reader labels, larger font ranges, dyslexia‑friendly settings; more languages (UR/ID/TR) for UI and translations.

## Technical Backlog & Engineering Tasks

- Data/Assets
  - Source and verify page/juz/hizb/sajda metadata; add integrity checks and versioning.
  - Optional audio/tafsir/font packs with size budgets and lazy install.
- Performance
  - Precompute normalized text; cache search indices (Hive/SQLite); isolate for heavy jobs.
  - List virtualization sanity for large surahs; measure build/paint times.
- UX/Visual
  - Islamic frame themes (light/dark), geometric dividers between ayat, refined medallions; better share templates.
- QA
  - Golden tests for medallion/frame; widget tests for quick jump and deep link scroll; smoke suite on CI.

## Milestones (Suggested)

- M1: Global search + Juz/Page metadata + quick jump tabs (2–3 days)
- M2: Audio (1–2 reciters) + aya sync + A–B loop (4–6 days)
- M3: Tafsir pack + word‑by‑word tooltips (4–6 days)
- M4: Memorization starter (hide‑words + spaced repetition) (4–6 days)
- M5: Share as image + ribbons/pattern polish (2–3 days)

Notes
- Keep each UI file < 250 lines; extract widgets and helpers.
- Persist preferences (layout mode, font scale, toggles). Avoid blocking main thread on heavy work.
- Maintain AR/EN parity and RTL correctness; use anchors for all jump/scroll flows.

