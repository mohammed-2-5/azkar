import 'package:flutter/material.dart';

import '../../data/models/ayah.dart';

class WordByWordSheet extends StatefulWidget {
  const WordByWordSheet({super.key, required this.ayah});

  final Ayah ayah;

  @override
  State<WordByWordSheet> createState() => _WordByWordSheetState();
}

class _WordByWordSheetState extends State<WordByWordSheet> {
  late final List<_WordChunk> _chunks = _buildChunks(widget.ayah);
  late final List<bool> _revealed = List<bool>.filled(_chunks.length, false);
  bool _compact = true;

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
                    'Word-by-word ${widget.ayah.id}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: _compact ? 'Expand all' : 'Collapse all',
                  onPressed: () {
                    setState(() {
                      for (var i = 0; i < _revealed.length; i++) {
                        _revealed[i] = !_compact;
                      }
                      _compact = !_compact;
                    });
                  },
                  icon: Icon(_compact ? Icons.unfold_more : Icons.unfold_less),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 360,
              child: ListView.builder(
                itemCount: _chunks.length,
                itemBuilder: (context, index) {
                  final chunk = _chunks[index];
                  final shown = _revealed[index];
                  return Card(
                    child: ListTile(
                      onTap: () => setState(() => _revealed[index] = !shown),
                      title: Text(
                        chunk.arabic,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (chunk.transliteration != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                chunk.transliteration!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              shown
                                  ? (chunk.translation ?? '—')
                                  : 'Tap to reveal meaning',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    fontWeight: shown ? null : FontWeight.w500,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(
                        shown ? Icons.visibility : Icons.visibility_off,
                      ),
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

  List<_WordChunk> _buildChunks(Ayah ayah) {
    final arWords = _split(ayah.textAr);
    final translitWords = ayah.transliteration == null
        ? const <String>[]
        : _split(ayah.transliteration!);
    final translationWords = ayah.translationEn == null
        ? const <String>[]
        : _split(ayah.translationEn!);
    final result = <_WordChunk>[];
    for (var i = 0; i < arWords.length; i++) {
      result.add(
        _WordChunk(
          arabic: arWords[i],
          transliteration: i < translitWords.length ? translitWords[i] : null,
          translation: i < translationWords.length ? translationWords[i] : null,
        ),
      );
    }
    return result;
  }

  List<String> _split(String text) {
    return text
        .split(RegExp(r'\s+'))
        .where((element) => element.trim().isNotEmpty)
        .toList();
  }
}

class _WordChunk {
  final String arabic;
  final String? transliteration;
  final String? translation;

  const _WordChunk({
    required this.arabic,
    this.transliteration,
    this.translation,
  });
}
