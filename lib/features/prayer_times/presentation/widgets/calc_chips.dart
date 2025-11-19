import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../presentation/cubit/prayer_times_state.dart';
import 'calculation_labels.dart';

class CalcChips extends StatelessWidget {
  const CalcChips({super.key, required this.state});
  final PrayerTimesState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        Semantics(
          container: true,
          label: '${l10n.method}: ${calcMethodLabel(l10n, state.prefs.method)}',
          child: Chip(
            avatar: const Icon(Icons.public, size: 18),
            label: Text(
              '${l10n.method}: ${calcMethodLabel(l10n, state.prefs.method)}',
            ),
          ),
        ),
        Semantics(
          container: true,
          label: '${l10n.madhab}: ${madhabLabel(l10n, state.prefs.madhab)}',
          child: Chip(
            avatar: const Icon(Icons.account_balance, size: 18),
            label: Text(
              '${l10n.madhab}: ${madhabLabel(l10n, state.prefs.madhab)}',
            ),
          ),
        ),
        Semantics(
          container: true,
          label:
              '${l10n.highLatitude}: ${highLatitudeLabel(l10n, state.prefs.highLatitude)}',
          child: Chip(
            avatar: const Icon(Icons.thermostat, size: 18),
            label: Text(
              '${l10n.highLatitude}: ${highLatitudeLabel(l10n, state.prefs.highLatitude)}',
            ),
          ),
        ),
        if (state.locationName != null)
          Semantics(
            container: true,
            label: '${l10n.location}: ${state.locationName!}',
            child: Chip(
              avatar: const Icon(Icons.location_on, size: 18),
              label: Text('${l10n.location}: ${state.locationName!}'),
            ),
          ),
      ],
    );
  }
}
