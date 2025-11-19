import 'dart:ui';

import 'package:azkar/features/settings/telemetry_logs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:azkar/l10n/app_localizations.dart';

import '../../core/theme/theme_cubit.dart';
import '../../core/theme/theme_state.dart';
import '../../core/theme/theme_tokens.dart';
import '../../core/telemetry/telemetry_cubit.dart';

class AppearancePage extends StatelessWidget {
  const AppearancePage({super.key});

  static const double _minTextScale = 0.8;
  static const double _maxTextScale = 1.3;

  static final _choices = <_ColorChoice>[
    _ColorChoice(
      analyticsLabel: 'Dark Grey',
      color: Colors.blueGrey,
      labelBuilder: (l10n) => l10n.appearanceColorDarkGrey,
    ),
    _ColorChoice(
      analyticsLabel: 'Emerald',
      color: Colors.green,
      labelBuilder: (l10n) => l10n.appearanceColorEmerald,
    ),
    _ColorChoice(
      analyticsLabel: 'Teal',
      color: Colors.teal,
      labelBuilder: (l10n) => l10n.appearanceColorTeal,
    ),
    _ColorChoice(
      analyticsLabel: 'Indigo',
      color: Colors.indigo,
      labelBuilder: (l10n) => l10n.appearanceColorIndigo,
    ),
    _ColorChoice(
      analyticsLabel: 'Purple',
      color: Colors.deepPurple,
      labelBuilder: (l10n) => l10n.appearanceColorPurple,
    ),
    _ColorChoice(
      analyticsLabel: 'Amber',
      color: Colors.amber,
      labelBuilder: (l10n) => l10n.appearanceColorAmber,
    ),
    _ColorChoice(
      analyticsLabel: 'Pink',
      color: Colors.pink,
      labelBuilder: (l10n) => l10n.appearanceColorPink,
    ),
    _ColorChoice(
      analyticsLabel: 'Brown',
      color: Colors.brown,
      labelBuilder: (l10n) => l10n.appearanceColorBrown,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appearanceTitle)),
      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.appearanceThemeMode,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        children: [
                          _ModeChip(
                            label: l10n.appearanceModeSystem,
                            icon: Icons.brightness_auto,
                            selected: state.mode == ThemeMode.system,
                            onTap: () {
                              context.read<ThemeCubit>().setMode(
                                ThemeMode.system,
                              );
                              context.read<TelemetryCubit>().logEvent(
                                'theme_mode_change',
                                {'mode': 'system'},
                              );
                            },
                          ),
                          _ModeChip(
                            label: l10n.appearanceModeLight,
                            icon: Icons.wb_sunny_outlined,
                            selected: state.mode == ThemeMode.light,
                            onTap: () {
                              context.read<ThemeCubit>().setMode(
                                ThemeMode.light,
                              );
                              context.read<TelemetryCubit>().logEvent(
                                'theme_mode_change',
                                {'mode': 'light'},
                              );
                            },
                          ),
                          _ModeChip(
                            label: l10n.appearanceModeDark,
                            icon: Icons.nights_stay_outlined,
                            selected: state.mode == ThemeMode.dark,
                            onTap: () {
                              context.read<ThemeCubit>().setMode(
                                ThemeMode.dark,
                              );
                              context.read<TelemetryCubit>().logEvent(
                                'theme_mode_change',
                                {'mode': 'dark'},
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.primaryColor,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          for (final c in _choices)
                            _ColorTile(
                              choice: c,
                              selected: state.seedColor.value == c.color.value,
                              onTap: () {
                                context.read<ThemeCubit>().setSeed(c.color);
                                context.read<TelemetryCubit>().logEvent(
                                  'theme_seed_change',
                                  {'color': c.analyticsLabel},
                                );
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.appearanceTextScale,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.appearanceTextScaleDescription,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 12),
                      Slider(
                        min: _minTextScale,
                        max: _maxTextScale,
                        divisions: 10,
                        label: '${(state.textScale * 100).round()}%',
                        value: state.textScale.clamp(
                          _minTextScale,
                          _maxTextScale,
                        ),
                        onChanged: (value) {
                          context.read<ThemeCubit>().setTextScale(value);
                          context.read<TelemetryCubit>().logEvent(
                            'text_scale_changed',
                            {'scale': value.toStringAsFixed(2)},
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'A',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            '${(state.textScale * 100).round()}%',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: Colors.white),
                          ),
                          Text(
                            'A',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _TextPreview(scale: state.textScale),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _GlassCard(
                  child: ListTile(
                    leading: const Icon(Icons.language, color: Colors.white),
                    title: Text(
                      l10n.language,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.white),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.white70,
                    ),
                    onTap: () => context.go('/language'),
                  ),
                ),
                const SizedBox(height: 20),
                _GlassCard(
                  child: BlocBuilder<TelemetryCubit, bool>(
                    builder: (context, enabled) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            value: enabled,
                            onChanged: (value) =>
                                _handleTelemetryToggle(context, value),
                            title: Text(
                              l10n.appearanceTelemetryCardTitle,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                            subtitle: Text(
                              l10n.appearanceTelemetryBody,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.white70),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const TelemetryLogsPage(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.list_alt),
                              label: Text(l10n.appearanceTelemetryViewLogs),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleTelemetryToggle(BuildContext context, bool value) async {
    final telemetryCubit = context.read<TelemetryCubit>();
    final l10n = AppLocalizations.of(context)!;
    if (value && !telemetryCubit.isEnabled) {
      final accepted =
          await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(l10n.telemetryEnableTitle),
              content: Text(l10n.telemetryEnableBody),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(l10n.telemetryEnableDecline),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(l10n.telemetryEnableAccept),
                ),
              ],
            ),
          ) ??
          false;
      if (!accepted) return;
    }
    await telemetryCubit.setEnabled(value);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value ? l10n.telemetryEnabled : l10n.telemetryDisabled),
      ),
    );
  }
}

class _ColorChoice {
  const _ColorChoice({
    required this.analyticsLabel,
    required this.labelBuilder,
    required this.color,
  });

  final String analyticsLabel;
  final String Function(AppLocalizations) labelBuilder;
  final Color color;

  String label(AppLocalizations l10n) => labelBuilder(l10n);
}

class _ColorTile extends StatelessWidget {
  const _ColorTile({
    required this.choice,
    required this.selected,
    required this.onTap,
  });
  final _ColorChoice choice;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.08),
          border: Border.all(
            color: selected ? choice.color : Colors.white24,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: choice.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                choice.label(AppLocalizations.of(context)!),
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: Colors.white),
              ),
            ),
            if (selected) const Icon(Icons.check, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: selected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 16), const SizedBox(width: 6), Text(label)],
      ),
      onSelected: (_) => onTap(),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
        gradient: ThemeTokens.glassGradient,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    );
  }
}

class _TextPreview extends StatelessWidget {
  const _TextPreview({required this.scale});
  final double scale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final media = MediaQuery.of(context);
    return MediaQuery(
      data: media.copyWith(textScaleFactor: scale),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.appearancePreviewTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.appearancePreviewBody,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
