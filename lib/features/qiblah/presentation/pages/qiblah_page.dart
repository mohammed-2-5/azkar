import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:azkar/l10n/app_localizations.dart';

import '../../../../core/telemetry/telemetry_cubit.dart';
import '../../../../ui/widgets/decorated_header.dart';
import '../cubit/qiblah_cubit.dart';
import '../cubit/qiblah_state.dart';
import '../widgets/compass.dart';

class QiblahPage extends StatefulWidget {
  const QiblahPage({super.key});

  @override
  State<QiblahPage> createState() => _QiblahPageState();
}

class _QiblahPageState extends State<QiblahPage> {
  @override
  void initState() {
    super.initState();
    context.read<QiblahCubit>().start();
    context.read<TelemetryCubit>().logEvent('screen_qiblah');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const DecoratedBackgroundFill(),
          BlocBuilder<QiblahCubit, QiblahState>(
            builder: (context, state) {
              if (state.status == QiblahStatus.error) {
                return Center(child: Text(state.error ?? 'Error'));
              }
              if (state.status == QiblahStatus.loading ||
                  state.status == QiblahStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              }
              final l10n = AppLocalizations.of(context)!;
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: DecoratedHeader(
                      height: 220,
                      title: l10n.qiblahTitle,
                      subtitle: l10n.qiblahSubtitle,
                    ),
                  ),
                  if (state.hasSensor == false)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                        child: Card(
                          child: ListTile(
                            leading: const Icon(Icons.sensors_off),
                            title: const Text('Compass sensor unavailable'),
                            subtitle: const Text(
                              'Please calibrate your device or rely on map direction.',
                            ),
                          ),
                        ),
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: StreamBuilder<CompassEvent>(
                      stream: FlutterCompass.events,
                      builder: (context, snapshot) {
                        if (state.bearing == null) {
                          return const Padding(
                            padding: EdgeInsets.all(24),
                            child: Text('Set your location to compute Qiblah.'),
                          );
                        }
                        final heading = snapshot.data?.heading;
                        if (heading == null) {
                          return const Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 30,
                                      offset: const Offset(0, 18),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(28),
                                    child: QiblahCompass(
                                      heading: heading,
                                      qiblah: state.bearing!,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                '${l10n.qiblahTitle}: ${state.bearing!.toStringAsFixed(1)}\u00B0',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                              Text(
                                'Heading ${heading.toStringAsFixed(1)}\u00B0',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.white70),
                              ),
                              const SizedBox(height: 16),
                              _AlignmentCard(
                                diff: _normalizedDelta(state.bearing!, heading),
                              ),
                              const SizedBox(height: 12),
                              const _CalibrationCard(),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

double _normalizedDelta(double target, double heading) {
  final delta = (target - heading + 360) % 360;
  return delta > 180 ? delta - 360 : delta;
}

class _AlignmentCard extends StatelessWidget {
  const _AlignmentCard({required this.diff});
  final double diff;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final absDiff = diff.abs();
    final aligned = absDiff < 5;
    final instruction = aligned
        ? l10n.qiblahAligned
        : (diff > 0
            ? l10n.qiblahRotateRight(absDiff.toStringAsFixed(1))
            : l10n.qiblahRotateLeft(absDiff.toStringAsFixed(1)));
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.08),
        border: Border.all(
          color: aligned ? Colors.greenAccent : Colors.orangeAccent,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.qiblahAlignmentStatus,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            instruction,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _CalibrationCard extends StatelessWidget {
  const _CalibrationCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          const Icon(Icons.refresh, color: Colors.white70),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.qiblahCalibrationTips,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.qiblahCalibrationBody,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
