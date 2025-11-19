import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/calculation_prefs.dart';
import '../../presentation/cubit/prayer_times_cubit.dart';
import '../../presentation/pages/location_search_page.dart';
import 'calculation_labels.dart';

class CalculationSettingsBlock extends StatelessWidget {
  const CalculationSettingsBlock({
    super.key,
    required this.prefs,
    required this.onPrefsChanged,
  });

  final CalculationPrefs prefs;
  final ValueChanged<CalculationPrefs> onPrefsChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.calcTitle, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(l10n.location, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () =>
                    context.read<PrayerTimesCubit>().useDeviceLocation(),
                icon: const Icon(Icons.my_location),
                label: Text(l10n.useDevice),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LocationSearchPage(),
                    ),
                  );
                  if (res is Map) {
                    final lat = (res['lat'] as num).toDouble();
                    final lng = (res['lng'] as num).toDouble();
                    final label = res['label'] as String;
                    // ignore: use_build_context_synchronously
                    await context.read<PrayerTimesCubit>().setFixedLocation(
                      lat: lat,
                      lng: lng,
                      label: label,
                    );
                  }
                },
                icon: const Icon(Icons.location_city),
                label: Text(l10n.chooseCity),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _SettingsDropdown<CalcMethod>(
          label: l10n.method,
          value: prefs.method,
          values: CalcMethod.values,
          toText: (v) => calcMethodLabel(l10n, v),
          onChanged: (v) {
            if (v != null) onPrefsChanged(prefs.copyWith(method: v));
          },
        ),
        _SettingsDropdown<MadhabPref>(
          label: l10n.madhab,
          value: prefs.madhab,
          values: MadhabPref.values,
          toText: (v) => madhabLabel(l10n, v),
          onChanged: (v) {
            if (v != null) onPrefsChanged(prefs.copyWith(madhab: v));
          },
        ),
        _SettingsDropdown<HighLatitudePref>(
          label: l10n.highLatitude,
          value: prefs.highLatitude,
          values: HighLatitudePref.values,
          toText: (v) => highLatitudeLabel(l10n, v),
          onChanged: (v) {
            if (v != null) onPrefsChanged(prefs.copyWith(highLatitude: v));
          },
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.hour24),
          value: prefs.use24h,
          onChanged: (v) => onPrefsChanged(prefs.copyWith(use24h: v)),
        ),
      ],
    );
  }
}

class _SettingsDropdown<T> extends StatelessWidget {
  const _SettingsDropdown({
    required this.label,
    required this.value,
    required this.values,
    required this.toText,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> values;
  final String Function(T) toText;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            items: [
              for (final v in values)
                DropdownMenuItem<T>(value: v, child: Text(toText(v))),
            ],
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
