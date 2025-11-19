import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../data/quran_repository.dart';
import '../../data/quran_storage.dart';
import '../../data/quran_diagnostics.dart';
import '../../data/tafseer_repository.dart';
import '../../data/memorization_repository.dart';
import 'package:flutter/foundation.dart';
import '../cubit/quran_cubit.dart';
import '../cubit/quran_state.dart';
import '../cubit/memorization_cubit.dart';
import 'memorization_page.dart';
import '../../../../core/theme/theme_tokens.dart';

class QuranPage extends StatelessWidget {
  const QuranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => QuranRepository()),
        RepositoryProvider(create: (_) => QuranStorage()),
        RepositoryProvider(create: (_) => TafseerRepository()),
        RepositoryProvider(
          create: (ctx) => MemorizationRepository(ctx.read<QuranStorage>()),
        ),
      ],
      child: BlocProvider(
        create: (ctx) => QuranCubit(
          ctx.read<QuranRepository>(),
          ctx.read<QuranStorage>(),
          ctx.read<TafseerRepository>(),
          ctx.read<MemorizationRepository>(),
        )..loadIndex(),
        child: const _QuranView(),
      ),
    );
  }
}

class _QuranView extends StatelessWidget {
  const _QuranView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navQuran),
        actions: [
          if (kDebugMode)
            IconButton(
              tooltip: 'Diagnostics',
              icon: const Icon(Icons.bug_report_outlined),
              onPressed: () async {
                final res = await QuranDiagnostics.preflight();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Assets OK. Missing AR:${res.missingAr} EN:${res.missingEn}',
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: BlocBuilder<QuranCubit, QuranState>(
        builder: (context, state) {
          if (state.loading && state.surahList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text(state.error!));
          }
          final filtered = state.query.isEmpty
              ? state.surahList
              : state.surahList.where((s) {
                  final q = state.query.toLowerCase();
                  return s.transliteration.toLowerCase().contains(q) ||
                      (s.translation ?? '').toLowerCase().contains(q);
                }).toList();
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (state.lastSurahId != null && state.lastAyah != null)
                        _ContinueReadingCard(
                          onTap: () =>
                              context.push('/quran/${state.lastSurahId}'),
                          subtitle: '#${state.lastAyah}',
                        ),
                      _SearchField(
                        hint: l10n.search,
                        onChanged: (v) =>
                            context.read<QuranCubit>().setQuery(v),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.tonalIcon(
                        onPressed: () => _openMemorization(context),
                        icon: const Icon(Icons.flag),
                        label: const Text('Memorization tools'),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final s = filtered[index];
                  return ListTile(
                    title: Text(s.transliteration),
                    subtitle: Text('${s.translation ?? ''} • ${s.totalVerses}'),
                    leading: CircleAvatar(child: Text('${s.id}')),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/quran/${s.id}'),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _openMemorization(BuildContext context) {
    final quranRepo = context.read<QuranRepository>();
    final memRepo = context.read<MemorizationRepository>();
    final quranCubit = context.read<QuranCubit>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: quranRepo),
            RepositoryProvider.value(value: memRepo),
          ],
          child: BlocProvider(
            create: (ctx) => MemorizationCubit(
              ctx.read<MemorizationRepository>(),
              ctx.read<QuranRepository>(),
              quranCubit,
            )..load(),
            child: const MemorizationPage(),
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.hint, required this.onChanged});
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: onChanged,
    );
  }
}

class _ContinueReadingCard extends StatelessWidget {
  const _ContinueReadingCard({required this.onTap, required this.subtitle});
  final VoidCallback onTap;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: ThemeTokens.heroGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: ThemeTokens.elevatedShadow,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
                child: const Icon(Icons.play_arrow_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.continueReading,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
              ),
              Text(subtitle, style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}
