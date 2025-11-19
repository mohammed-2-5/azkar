# Premium UI Validation Checklist

## Accessibility
- [ ] Verify min contrast (4.5:1) for hero tiles and Azkar cards in both light/dark modes (use Flutter’s `SemanticsDebugger` or external contrast tools).
- [ ] Test large text (system font scale 1.3x+) to confirm `PrayerTile`, `AzkarCard`, and navigation shell do not overflow.
- [ ] Screen reader labels: ensure bottom-navigation destinations, azkar buttons, and Qiblah compass controls expose semantic labels.
- [ ] RTL/language toggle: flip between EN/AR via Appearance > Language and confirm layout mirrors correctly.

## Motion & Interaction
- [ ] Inspect new animations (`PrayerTile` glow, Azkar badges, navigation blur) on low-end hardware to ensure no dropped frames.
- [ ] Confirm haptics/feedback where supported (Navigation destinations, favorite toggle).
- [ ] Validate that transitions respect “Remove animations” (Android) / “Reduce motion” (iOS) accessibility settings.

## Regression / QA
- [ ] Golden tests for `PrayerTile` (expanded + compact) and `AzkarCard`.
- [ ] Widget tests ensuring action handlers (`onFavorite`, `showPrayerSettingsSheet`, `/notifications`) fire correctly.
- [ ] Manual smoke test of each tab after hot restart and cold start to ensure gradients/backdrops do not cause artifacts.
- [ ] Cross-device review (phone + tablet) to finetune paddings/margins defined in `ThemeTokens`.
