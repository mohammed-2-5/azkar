import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:azkar/core/telemetry/telemetry_cubit.dart';
import 'package:azkar/l10n/app_localizations.dart';

import '../../core/theme/locale_cubit.dart';
import '../../core/theme/locale_state.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.language)),
      body: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, state) {
          final current = state.locale?.languageCode ?? 'system';
          return ListView(
            children: [
              RadioListTile<String?>(
                title: const Text('العربية (افتراضي)'),
                value: 'ar',
                groupValue: current,
                onChanged: (_) {
                  context.read<LocaleCubit>().setLocale(const Locale('ar'));
                  context.read<TelemetryCubit>().logEvent('language_change', {
                    'language': 'ar',
                  });
                },
              ),
              RadioListTile<String?>(
                title: const Text('English'),
                value: 'en',
                groupValue: current,
                onChanged: (_) {
                  context.read<LocaleCubit>().setLocale(const Locale('en'));
                  context.read<TelemetryCubit>().logEvent('language_change', {
                    'language': 'en',
                  });
                },
              ),
              RadioListTile<String?>(
                title: const Text('استخدام لغة النظام'),
                value: 'system',
                groupValue: current,
                onChanged: (_) {
                  context.read<LocaleCubit>().setLocale(null);
                  context.read<TelemetryCubit>().logEvent('language_change', {
                    'language': 'system',
                  });
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
