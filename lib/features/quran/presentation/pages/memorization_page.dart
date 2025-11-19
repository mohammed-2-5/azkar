import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/memorization_entry.dart';
import '../../data/models/memorization_profile.dart';
import '../../data/memorization_repository.dart';
import '../cubit/memorization_cubit.dart';
import '../cubit/memorization_state.dart';

class MemorizationPage extends StatelessWidget {
  const MemorizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemorizationCubit, MemorizationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Memorization'),
            actions: [
              IconButton(
                tooltip: 'Reload deck',
                onPressed: () => context.read<MemorizationCubit>().load(),
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: state.loading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (state.error != null) ...[
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            state.error!,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                      _StatsCard(profile: state.profile),
                      const SizedBox(height: 12),
                      _DeckActions(state: state),
                      if (state.hasSession) ...[
                        const SizedBox(height: 16),
                        Expanded(child: _PracticePanel(state: state)),
                      ] else ...[
                        const SizedBox(height: 16),
                        Expanded(child: _DeckList(entries: state.deck)),
                      ],
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.profile});
  final MemorizationProfile profile;

  @override
  Widget build(BuildContext context) {
    final progress = profile.dailyTarget == 0
        ? 0.0
        : (profile.todayReviewed / profile.dailyTarget).clamp(0.0, 1.0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daily goal',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                DropdownButton<int>(
                  value: profile.dailyTarget,
                  onChanged: (v) {
                    if (v != null) {
                      context.read<MemorizationCubit>().setDailyTarget(v);
                    }
                  },
                  items: const [3, 5, 10, 15, 20]
                      .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 4),
            Text(
              'Reviewed today: ${profile.todayReviewed} • Streak: ${profile.streak} days',
            ),
          ],
        ),
      ),
    );
  }
}

class _DeckActions extends StatelessWidget {
  const _DeckActions({required this.state});
  final MemorizationState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MemorizationCubit>();
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: state.deck.isEmpty ? null : () => cubit.startSession(),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start practice'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: state.hasSession ? () => cubit.stopSession() : null,
            icon: const Icon(Icons.stop_circle_outlined),
            label: const Text('Stop'),
          ),
        ),
      ],
    );
  }
}

class _DeckList extends StatelessWidget {
  const _DeckList({required this.entries});
  final List<MemorizationEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Center(
        child: Text(
          'No ayat added yet. Use the flag icon in the reader to start.',
        ),
      );
    }
    return ListView.separated(
      itemCount: entries.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final entry = entries[index];
        final due = entry.dueOn;
        final diff = due.difference(DateTime.now());
        final dueLabel = diff.inDays <= 0
            ? 'Due now'
            : 'Due in ${diff.inDays}d';
        return ListTile(
          title: Text('Surah ${entry.surah} • Ayah ${entry.ayah}'),
          subtitle: Text('$dueLabel • streak ${entry.streak}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () =>
                context.read<MemorizationCubit>().removeEntry(entry),
          ),
        );
      },
    );
  }
}

class _PracticePanel extends StatefulWidget {
  const _PracticePanel({required this.state});

  final MemorizationState state;

  @override
  State<_PracticePanel> createState() => _PracticePanelState();
}

class _PracticePanelState extends State<_PracticePanel> {
  List<bool> revealed = [];
  MemorizationCard? lastCard;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  @override
  void didUpdateWidget(covariant _PracticePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.currentCard != lastCard) {
      _reset();
    }
  }

  void _reset() {
    final card = widget.state.currentCard;
    lastCard = card;
    if (card == null) {
      revealed = [];
      return;
    }
    final words = _split(card.ayah.textAr);
    revealed = List<bool>.filled(words.length, false);
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.state.currentCard;
    if (card == null) {
      return const Center(child: Text('Session empty.'));
    }
    final words = _split(card.ayah.textAr);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Practicing Surah ${card.entry.surah}:${card.entry.ayah}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _MaskedText(words: words, revealed: revealed),
                const SizedBox(height: 12),
                if (card.ayah.translationEn != null)
                  Text(
                    card.ayah.translationEn!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  children: [
                    ElevatedButton(
                      onPressed: () => setState(() => _revealNext()),
                      child: const Text('Reveal word'),
                    ),
                    OutlinedButton(
                      onPressed: () => setState(() => _revealAll()),
                      child: const Text('Reveal all'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _gradeButton(
                      context,
                      'Again',
                      Colors.redAccent,
                      ReviewGrade.again,
                    ),
                    _gradeButton(
                      context,
                      'Hard',
                      Colors.orange,
                      ReviewGrade.hard,
                    ),
                    _gradeButton(
                      context,
                      'Good',
                      Colors.green,
                      ReviewGrade.good,
                    ),
                    _gradeButton(
                      context,
                      'Easy',
                      Colors.blue,
                      ReviewGrade.easy,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _gradeButton(
    BuildContext context,
    String label,
    Color color,
    ReviewGrade grade,
  ) {
    return FilledButton(
      style: FilledButton.styleFrom(backgroundColor: color),
      onPressed: () => context.read<MemorizationCubit>().gradeCurrent(grade),
      child: Text(label),
    );
  }

  void _revealNext() {
    final idx = revealed.indexWhere((element) => !element);
    if (idx >= 0) revealed[idx] = true;
  }

  void _revealAll() {
    for (var i = 0; i < revealed.length; i++) {
      revealed[i] = true;
    }
  }

  List<String> _split(String text) {
    return text.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
  }
}

class _MaskedText extends StatelessWidget {
  const _MaskedText({required this.words, required this.revealed});
  final List<String> words;
  final List<bool> revealed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      textDirection: TextDirection.rtl,
      children: List.generate(words.length, (index) {
        final show = index < revealed.length ? revealed[index] : false;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            show ? words[index] : 'ـــ',
            textDirection: TextDirection.rtl,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        );
      }),
    );
  }
}
