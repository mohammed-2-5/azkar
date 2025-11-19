import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/notification_prefs.dart';
import '../../domain/calculation_prefs.dart';
import '../../presentation/cubit/prayer_times_cubit.dart';
import 'calculation_settings_block.dart';
import 'notification_settings_block.dart';
import 'prayer_preview_block.dart';

const _previewDayCount = 3;
const _prayerKeys = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
const _leadOptions = [0, 5, 10, 15, 20, 30];
const _snoozeOptions = [3, 5, 10, 15];

Future<void> showPrayerSettingsSheet(
  BuildContext context,
  CalculationPrefs prefs,
) async {
  CalculationPrefs current = prefs;
  NotificationPrefs notif = await context
      .read<PrayerTimesCubit>()
      .currentNotificationPrefs()
      .catchError((_) => const NotificationPrefs());

  await showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) {
      final viewInsets = MediaQuery.of(context).viewInsets.bottom;
      final padBottom = MediaQuery.of(context).padding.bottom;
      return StatefulBuilder(
        builder: (context, setState) {
          final l10n = AppLocalizations.of(context)!;
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: 16 + padBottom + viewInsets,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CalculationSettingsBlock(
                    prefs: current,
                    onPrefsChanged: (value) => setState(() => current = value),
                  ),
                  const Divider(height: 24),
                  PrayerPreviewBlock(
                    prefs: current,
                    dayCount: _previewDayCount,
                  ),
                  const Divider(height: 32),
                  NotificationSettingsBlock(
                    prefs: notif,
                    prayers: _prayerKeys,
                    leadOptions: _leadOptions,
                    snoozeOptions: _snoozeOptions,
                    onPrefsChanged: (value) => setState(() => notif = value),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            Navigator.pop(context);
                            context.read<PrayerTimesCubit>().updatePrefs(
                              current,
                            );
                            await context
                                .read<PrayerTimesCubit>()
                                .saveNotificationPrefs(notif);
                          },
                          icon: const Icon(Icons.check),
                          label: Text(l10n.apply),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            context.go('/notifications');
                          },
                          icon: const Icon(Icons.notifications_active_outlined),
                          label: Text(l10n.prayerSettingsOpenNotifications),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
