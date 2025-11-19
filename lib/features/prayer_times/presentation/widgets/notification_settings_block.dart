import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/notification_prefs.dart';
import 'calculation_labels.dart';

class NotificationSettingsBlock extends StatelessWidget {
  const NotificationSettingsBlock({
    super.key,
    required this.prefs,
    required this.prayers,
    required this.leadOptions,
    required this.snoozeOptions,
    required this.onPrefsChanged,
  });

  final NotificationPrefs prefs;
  final List<String> prayers;
  final List<int> leadOptions;
  final List<int> snoozeOptions;
  final ValueChanged<NotificationPrefs> onPrefsChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.notifications, style: Theme.of(context).textTheme.titleLarge),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.enableReminders),
          value: prefs.enabled,
          onChanged: (v) => onPrefsChanged(prefs.copyWith(enabled: v)),
        ),
        Row(
          children: [
            Text(l10n.leadTime),
            const SizedBox(width: 12),
            DropdownButton<int>(
              value: prefs.leadMinutes,
              items: leadOptions
                  .map(
                    (m) => DropdownMenuItem(
                      value: m,
                      child: Text(AppLocalizations.of(context)!.minutes(m)),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  onPrefsChanged(prefs.copyWith(leadMinutes: v));
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          l10n.perPrayerLeadTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          l10n.perPrayerLeadInfo,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        LeadOverrideList(
          prefs: prefs,
          defaultLabel: l10n.leadDefaultLabel,
          options: leadOptions,
          prayers: prayers,
          onChanged: (prayer, minutes) =>
              onPrefsChanged(prefs.setLeadOverride(prayer, minutes)),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final prayer in prayers)
              FilterChip(
                label: Text(localizedPrayerName(l10n, prayer)),
                selected: _prayerEnabled(prayer),
                onSelected: (value) =>
                    onPrefsChanged(_updatePrayerToggle(prayer, value)),
              ),
          ],
        ),
        const Divider(height: 24),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.snoozeLabel),
          subtitle: Text(l10n.snoozeInfo),
          value: prefs.snoozeEnabled,
          onChanged: (v) => onPrefsChanged(prefs.copyWith(snoozeEnabled: v)),
        ),
        Row(
          children: [
            Text(l10n.snoozeMinutesLabel),
            const SizedBox(width: 12),
            DropdownButton<int>(
              value: prefs.snoozeMinutes,
              items: snoozeOptions
                  .map(
                    (m) => DropdownMenuItem(
                      value: m,
                      child: Text(l10n.minutes(m)),
                    ),
                  )
                  .toList(),
              onChanged: prefs.snoozeEnabled
                  ? (v) {
                      if (v != null) {
                        onPrefsChanged(prefs.copyWith(snoozeMinutes: v));
                      }
                    }
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(l10n.quietHours, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(l10n.quietInfo, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _pickQuietTime(
                  context: context,
                  isStart: true,
                  prefs: prefs,
                  onMinutes: (minutes) =>
                      onPrefsChanged(prefs.copyWith(quietStart: minutes)),
                ),
                icon: const Icon(Icons.nightlight_round),
                label: Text(
                  '${l10n.quietStartLabel}: ${_formatQuietLabel(context, prefs.quietStart, l10n)}',
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _pickQuietTime(
                  context: context,
                  isStart: false,
                  prefs: prefs,
                  onMinutes: (minutes) =>
                      onPrefsChanged(prefs.copyWith(quietEnd: minutes)),
                ),
                icon: const Icon(Icons.wb_sunny),
                label: Text(
                  '${l10n.quietEndLabel}: ${_formatQuietLabel(context, prefs.quietEnd, l10n)}',
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => onPrefsChanged(
              prefs.copyWith(quietStart: null, quietEnd: null),
            ),
            icon: const Icon(Icons.clear),
            label: Text(l10n.quietClear),
          ),
        ),
      ],
    );
  }

  bool _prayerEnabled(String prayer) {
    switch (prayer) {
      case 'Fajr':
        return prefs.fajr;
      case 'Dhuhr':
        return prefs.dhuhr;
      case 'Asr':
        return prefs.asr;
      case 'Maghrib':
        return prefs.maghrib;
      case 'Isha':
        return prefs.isha;
      default:
        return true;
    }
  }

  NotificationPrefs _updatePrayerToggle(String prayer, bool value) {
    switch (prayer) {
      case 'Fajr':
        return prefs.copyWith(fajr: value);
      case 'Dhuhr':
        return prefs.copyWith(dhuhr: value);
      case 'Asr':
        return prefs.copyWith(asr: value);
      case 'Maghrib':
        return prefs.copyWith(maghrib: value);
      case 'Isha':
        return prefs.copyWith(isha: value);
      default:
        return prefs;
    }
  }
}

class LeadOverrideList extends StatelessWidget {
  const LeadOverrideList({
    super.key,
    required this.prefs,
    required this.defaultLabel,
    required this.options,
    required this.prayers,
    required this.onChanged,
  });

  final NotificationPrefs prefs;
  final String defaultLabel;
  final List<int> options;
  final List<String> prayers;
  final void Function(String prayer, int? minutes) onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        for (final prayer in prayers)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    localizedPrayerName(l10n, prayer),
                    style: textTheme.bodyMedium,
                  ),
                ),
                DropdownButton<int?>(
                  value: prefs.leadOverrides[prayer],
                  items: <DropdownMenuItem<int?>>[
                    DropdownMenuItem<int?>(
                      value: null,
                      child: Text(defaultLabel),
                    ),
                    ...options.map(
                      (m) => DropdownMenuItem<int?>(
                        value: m,
                        child: Text(AppLocalizations.of(context)!.minutes(m)),
                      ),
                    ),
                  ],
                  onChanged: (value) => onChanged(prayer, value),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

Future<void> _pickQuietTime({
  required BuildContext context,
  required bool isStart,
  required NotificationPrefs prefs,
  required ValueChanged<int?> onMinutes,
}) async {
  final fallbackMinutes = isStart
      ? (prefs.quietStart ?? 22 * 60)
      : (prefs.quietEnd ?? 6 * 60);
  final initial = _minutesToTimeOfDay(fallbackMinutes);
  final picked = await showTimePicker(context: context, initialTime: initial);
  if (picked == null) return;
  final minutes = picked.hour * 60 + picked.minute;
  onMinutes(minutes);
}

String _formatQuietLabel(
  BuildContext context,
  int? minutes,
  AppLocalizations l10n,
) {
  if (minutes == null) return l10n.quietOff;
  final always24 = MediaQuery.maybeOf(context)?.alwaysUse24HourFormat ?? false;
  final tod = _minutesToTimeOfDay(minutes);
  return MaterialLocalizations.of(
    context,
  ).formatTimeOfDay(tod, alwaysUse24HourFormat: always24);
}

TimeOfDay _minutesToTimeOfDay(int minutes) {
  final normalized = minutes % (24 * 60);
  final hour = normalized ~/ 60;
  final minute = normalized % 60;
  return TimeOfDay(hour: hour, minute: minute);
}
