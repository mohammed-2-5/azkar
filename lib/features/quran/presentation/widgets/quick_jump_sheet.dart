import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../data/quran_storage.dart';
import '../cubit/quran_cubit.dart';

class QuickJumpSheet extends StatefulWidget {
  const QuickJumpSheet({super.key});

  @override
  State<QuickJumpSheet> createState() => _QuickJumpSheetState();
}

class _QuickJumpSheetState extends State<QuickJumpSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 2, vsync: this);
  final ayahCtrl = TextEditingController();
  List<Map<String, dynamic>> _recents = [];

  @override
  void initState() {
    super.initState();
    _loadRecents();
  }

  @override
  void dispose() {
    _tab.dispose();
    ayahCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadRecents() async {
    final storage = context.read<QuranStorage>();
    final list = await storage.getRecents();
    if (mounted) setState(() => _recents = list);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<QuranCubit>().state;
    final surahs = state.surahList;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          const _Grabber(),
          const SizedBox(height: 8),
          TabBar(
            controller: _tab,
            tabs: [
              Tab(text: 'Surah'),
              Tab(text: 'Recent'),
            ],
          ),
          SizedBox(
            height: 420,
            child: TabBarView(
              controller: _tab,
              children: [
                // Surah tab
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: ayahCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Ayah (optional)',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: surahs.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (ctx, i) {
                          final s = surahs[i];
                          return ListTile(
                            title: Text(s.transliteration),
                            subtitle: Text(s.translation ?? ''),
                            trailing: Text('${s.totalVerses}'),
                            onTap: () {
                              final ay = int.tryParse(ayahCtrl.text);
                              if (ay != null && ay > 0) {
                                context.push('/quran/${s.id}?ayah=$ay');
                              } else {
                                context.push('/quran/${s.id}');
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                // Recent tab
                ListView.separated(
                  itemCount: _recents.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final r = _recents[i];
                    final s = r['s'] as int;
                    final a = r['a'] as int;
                    return ListTile(
                      leading: const Icon(Icons.history),
                      title: Text('Surah $s'),
                      subtitle: Text('Ayah $a'),
                      onTap: () => context.push('/quran/$s?ayah=$a'),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Grabber extends StatelessWidget {
  const _Grabber();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 6,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
