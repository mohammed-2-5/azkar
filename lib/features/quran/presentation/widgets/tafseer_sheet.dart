import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/quran_cubit.dart';
import '../cubit/quran_state.dart';
import '../reading/ayah_ref.dart';

class TafseerSheet extends StatelessWidget {
  const TafseerSheet({super.key, required this.ref, required this.title});

  final AyahRef ref;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$title • ${ref.surah}:${ref.ayah}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'Reload',
                  onPressed: () => context.read<QuranCubit>().loadTafsir(
                    ref.surah,
                    ref.ayah,
                  ),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 360,
              child: BlocBuilder<QuranCubit, QuranState>(
                builder: (context, state) {
                  final loading = state.tafsirLoading && state.tafsirRef == ref;
                  if (loading) {
                    return const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state.tafsirError != null && state.tafsirRef == ref) {
                    return Text(
                      state.tafsirError!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                  final entry = state.tafsirRef == ref
                      ? state.tafsirEntry
                      : null;
                  if (entry == null) {
                    return const Text('Tafsir not available for this ayah.');
                  }
                  return SingleChildScrollView(
                    child: Text(
                      entry.text,
                      textDirection: TextDirection.rtl,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(height: 1.6),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
