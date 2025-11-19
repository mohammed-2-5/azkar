import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/audio/azan_voice.dart';
import '../../../../core/services/notification_prefs.dart';
import '../../../../core/services/notification_scheduler.dart';
import '../../../../core/telemetry/telemetry_cubit.dart';
import '../cubit/prayer_times_cubit.dart';
import '../widgets/calculation_labels.dart';
import 'notification_diagnostics_page.dart';

const _prayerKeys = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
const _leadOptions = [0, 5, 10, 15, 20, 30];
const _snoozeOptions = [3, 5, 10, 15];

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  NotificationPrefs _prefs = const NotificationPrefs();
  bool _loading = true;
  late final AudioPlayer _player;
  bool _previewing = false;
  TelemetryCubit get _telemetry => context.read<TelemetryCubit>();

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    context.read<PrayerTimesCubit>().currentNotificationPrefs().then((value) {
      setState(() {
        _prefs = value;
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await context.read<PrayerTimesCubit>().saveNotificationPrefs(_prefs);
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.notificationsSaved)));
    _telemetry.logEvent('notifications_saved', {
      'enabled': _prefs.enabled,
      'lead': _prefs.leadMinutes,
      'snooze': _prefs.snoozeEnabled,
      'voice': _prefs.azanVoice,
      'quiet_hours': _prefs.quietStart != null || _prefs.quietEnd != null,
    });
  }

  Future<void> _pickTime(bool start) async {
    final fallbackMinutes = start
        ? (_prefs.quietStart ?? 22 * 60)
        : (_prefs.quietEnd ?? 6 * 60);
    final initial = TimeOfDay(
      hour: (fallbackMinutes ~/ 60) % 24,
      minute: fallbackMinutes % 60,
    );
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null || !mounted) return;
    final minutes = picked.hour * 60 + picked.minute;
    _updatePrefs(
      (prefs) => start
          ? prefs.copyWith(quietStart: minutes)
          : prefs.copyWith(quietEnd: minutes),
      event: 'notifications_quiet_hours',
      data: {'boundary': start ? 'start' : 'end', 'minutes': minutes},
    );
  }

  void _updatePrefs(
    NotificationPrefs Function(NotificationPrefs) updater, {
    String? event,
    Map<String, dynamic>? data,
  }) {
    setState(() => _prefs = updater(_prefs));
    if (event != null) {
      _telemetry.logEvent(event, data);
    }
  }

  void _handleLeadOverride(String prayer, int? minutes) {
    _updatePrefs(
      (prefs) => prefs.setLeadOverride(prayer, minutes),
      event: 'notifications_lead_override',
      data: {'prayer': prayer, 'minutes': minutes ?? 'default'},
    );
  }

  void _changeVoice(String voiceId) {
    _updatePrefs(
      (prefs) => prefs.copyWith(azanVoice: voiceId),
      event: 'notifications_voice_change',
      data: {'voice': voiceId},
    );
  }

  void _logError(Object error, StackTrace stackTrace, String contextLabel) {
    if (!mounted) return;
    _telemetry.logError(error, stackTrace, context: contextLabel);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications),
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            tooltip: 'Diagnostics',
            onPressed: () {
              _telemetry.logEvent('notifications_diagnostics_opened');
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NotificationDiagnosticsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: Text(l10n.enableReminders),
            value: _prefs.enabled,
            onChanged: (v) => _updatePrefs(
              (prefs) => prefs.copyWith(enabled: v),
              event: 'notifications_toggle',
              data: {'enabled': v},
            ),
          ),
          Row(
            children: [
              Text(l10n.leadTime),
              const SizedBox(width: 12),
              DropdownButton<int>(
                value: _prefs.leadMinutes,
                items: _leadOptions
                    .map(
                      (m) => DropdownMenuItem(
                        value: m,
                        child: Text(AppLocalizations.of(context)!.minutes(m)),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  final minutes = v ?? _prefs.leadMinutes;
                  _updatePrefs(
                    (prefs) => prefs.copyWith(leadMinutes: minutes),
                    event: 'notifications_lead_minutes',
                    data: {'minutes': minutes},
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: Text(localizedPrayerName(l10n, 'Fajr')),
                selected: _prefs.fajr,
                onSelected: (v) => _updatePrefs(
                  (prefs) => prefs.copyWith(fajr: v),
                  event: 'notifications_prayer_toggle',
                  data: {'prayer': 'Fajr', 'enabled': v},
                ),
              ),
              FilterChip(
                label: Text(localizedPrayerName(l10n, 'Dhuhr')),
                selected: _prefs.dhuhr,
                onSelected: (v) => _updatePrefs(
                  (prefs) => prefs.copyWith(dhuhr: v),
                  event: 'notifications_prayer_toggle',
                  data: {'prayer': 'Dhuhr', 'enabled': v},
                ),
              ),
              FilterChip(
                label: Text(localizedPrayerName(l10n, 'Asr')),
                selected: _prefs.asr,
                onSelected: (v) => _updatePrefs(
                  (prefs) => prefs.copyWith(asr: v),
                  event: 'notifications_prayer_toggle',
                  data: {'prayer': 'Asr', 'enabled': v},
                ),
              ),
              FilterChip(
                label: Text(localizedPrayerName(l10n, 'Maghrib')),
                selected: _prefs.maghrib,
                onSelected: (v) => _updatePrefs(
                  (prefs) => prefs.copyWith(maghrib: v),
                  event: 'notifications_prayer_toggle',
                  data: {'prayer': 'Maghrib', 'enabled': v},
                ),
              ),
              FilterChip(
                label: Text(localizedPrayerName(l10n, 'Isha')),
                selected: _prefs.isha,
                onSelected: (v) => _updatePrefs(
                  (prefs) => prefs.copyWith(isha: v),
                  event: 'notifications_prayer_toggle',
                  data: {'prayer': 'Isha', 'enabled': v},
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
          _LeadOverrideList(
            prefs: _prefs,
            options: _leadOptions,
            defaultLabel: l10n.leadDefaultLabel,
            onChanged: _handleLeadOverride,
          ),
          const Divider(height: 24),
          Text(l10n.quietHours, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(l10n.quietInfo, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickTime(true),
                  icon: const Icon(Icons.nightlight_round),
                  label: Text(
                    '${l10n.quietStartLabel}: ${_formatQuietLabel(context, _prefs.quietStart, l10n)}',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickTime(false),
                  icon: const Icon(Icons.wb_sunny),
                  label: Text(
                    '${l10n.quietEndLabel}: ${_formatQuietLabel(context, _prefs.quietEnd, l10n)}',
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _updatePrefs(
                (prefs) => prefs.copyWith(quietStart: null, quietEnd: null),
                event: 'notifications_quiet_clear',
              ),
              icon: const Icon(Icons.clear),
              label: Text(l10n.quietClear),
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text(l10n.snoozeLabel),
            subtitle: Text(l10n.snoozeInfo),
            value: _prefs.snoozeEnabled,
            onChanged: (v) => _updatePrefs(
              (prefs) => prefs.copyWith(snoozeEnabled: v),
              event: 'notifications_snooze_toggle',
              data: {'enabled': v},
            ),
          ),
          Row(
            children: [
              Text(l10n.snoozeMinutesLabel),
              const SizedBox(width: 12),
              DropdownButton<int>(
                value: _prefs.snoozeMinutes,
                items: _snoozeOptions
                    .map(
                      (m) => DropdownMenuItem(
                        value: m,
                        child: Text(l10n.minutes(m)),
                      ),
                    )
                    .toList(),
                onChanged: _prefs.snoozeEnabled
                    ? (v) {
                        final minutes = v ?? _prefs.snoozeMinutes;
                        _updatePrefs(
                          (prefs) => prefs.copyWith(snoozeMinutes: minutes),
                          event: 'notifications_snooze_minutes',
                          data: {'minutes': minutes},
                        );
                      }
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _AzanVoiceSelector(
            prefs: _prefs,
            onChanged: _changeVoice,
            onPreview: _previewVoice,
            onStop: _stopPreview,
            previewing: _previewing,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () async {
              final cubit = context.read<PrayerTimesCubit>();
              _telemetry.logEvent('notifications_test_schedule', {
                'voice': _prefs.azanVoice,
                'lead': _prefs.leadMinutes,
              });
              // Schedule both notification and sound
              await cubit.scheduleTestNotification(_prefs);

              // Also show an instant notification so user knows it's working
              await cubit.scheduler.service.showInstant(
                id: 777,
                title: l10n.notificationsTestScheduledTitle,
                body: l10n.notificationsTestScheduledBody,
              );

              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.notificationsTestScheduledSnack),
                  duration: const Duration(seconds: 5),
                ),
              );
            },
            icon: const Icon(Icons.volume_up),
            label: Text(l10n.notificationsButtonTestScheduled),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () async {
              _telemetry.logEvent('notifications_test_instant');
              final cubit = context.read<PrayerTimesCubit>();
              await cubit.scheduler.service.showInstant(
                id: 888,
                title: l10n.notificationsInstantTitle,
                body: l10n.notificationsInstantBody,
              );
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.notificationsInstantSnack)),
              );
            },
            icon: const Icon(Icons.notifications_active),
            label: Text(l10n.notificationsButtonInstant),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () async {
              _telemetry.logEvent('notifications_sound_only_test', {
                'voice': _prefs.azanVoice,
              });
              // Direct audio playback test
              try {
                if (_prefs.azanVoice != 'default') {
                  await _player.stop();
                  final voice = AzanVoice.byId(_prefs.azanVoice);
                  if (voice.assetPath != null) {
                    await _player.setAsset(voice.assetPath!);
                    await _player.setVolume(1.0);
                    await _player.play();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.notificationsSoundPlaying)),
                    );
                  }
                } else {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.notificationsSoundSelectVoice)),
                  );
                }
              } catch (e, stack) {
                _logError(e, stack, 'notifications_sound_only_test');
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.notificationsSoundFailed('$e'))),
                );
              }
            },
            icon: const Icon(Icons.music_note),
            label: Text(l10n.notificationsButtonSoundOnly),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: Text(l10n.save),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () async {
              await context.read<PrayerTimesCubit>().saveNotificationPrefs(
                _prefs.copyWith(),
              );
              if (!context.mounted) return;
              _telemetry.logEvent('notifications_reschedule_now');
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.rescheduleNow)));
            },
            icon: const Icon(Icons.schedule),
            label: Text(l10n.rescheduleNow),
          ),
        ],
      ),
    );
  }

  String _formatQuietLabel(
    BuildContext context,
    int? minutes,
    AppLocalizations l10n,
  ) {
    if (minutes == null) return l10n.quietOff;
    final always24 = MediaQuery.of(context).alwaysUse24HourFormat;
    final tod = TimeOfDay(hour: (minutes ~/ 60) % 24, minute: minutes % 60);
    return MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(tod, alwaysUse24HourFormat: always24);
  }

  Future<void> _previewVoice(AzanVoice voice) async {
    final l10n = AppLocalizations.of(context)!;
    if (voice.assetPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.notificationsPreviewUnavailable)),
      );
      return;
    }
    _telemetry.logEvent('notifications_voice_preview', {'voice': voice.id});
    try {
      setState(() => _previewing = true);
      await _player.stop();
      await _player.setAsset(voice.assetPath!);
      await _player.play();
    } catch (e, stack) {
      _logError(e, stack, 'notifications_voice_preview');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.notificationsPreviewFailed('$e'))),
      );
    } finally {
      if (mounted) setState(() => _previewing = false);
    }
  }

  Future<void> _stopPreview() async {
    await _player.stop();
    if (mounted) {
      setState(() => _previewing = false);
    }
    _telemetry.logEvent('notifications_voice_stop_preview');
  }
}

class _AzanVoiceSelector extends StatelessWidget {
  const _AzanVoiceSelector({
    required this.prefs,
    required this.onChanged,
    required this.onPreview,
    required this.onStop,
    required this.previewing,
  });

  final NotificationPrefs prefs;
  final ValueChanged<String> onChanged;
  final ValueChanged<AzanVoice> onPreview;
  final VoidCallback onStop;
  final bool previewing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final voices = AzanVoice.all;
    final current = AzanVoice.byId(prefs.azanVoice);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.notificationsVoiceLabel, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: current.id,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: voices
              .map((v) => DropdownMenuItem(value: v.id, child: Text(v.label)))
              .toList(),
          onChanged: (id) {
            if (id != null) onChanged(id);
          },
        ),
        const SizedBox(height: 8),
        Text(current.description, style: theme.textTheme.bodySmall),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: current.assetPath == null || previewing
                    ? null
                    : () => onPreview(current),
                icon: const Icon(Icons.play_arrow),
                label: Text(l10n.notificationsPreview),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: previewing ? onStop : null,
                icon: const Icon(Icons.stop_circle),
                label: Text(l10n.notificationsStop),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LeadOverrideList extends StatelessWidget {
  const _LeadOverrideList({
    required this.prefs,
    required this.options,
    required this.defaultLabel,
    required this.onChanged,
  });

  final NotificationPrefs prefs;
  final List<int> options;
  final String defaultLabel;
  final void Function(String prayer, int? minutes) onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        for (final prayer in _prayerKeys)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(child: Text(localizedPrayerName(l10n, prayer))),
                DropdownButton<int?>(
                  value: prefs.leadOverrides[prayer],
                  items: <DropdownMenuItem<int?>>[
                    DropdownMenuItem<int?>(child: Text(defaultLabel)),
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
