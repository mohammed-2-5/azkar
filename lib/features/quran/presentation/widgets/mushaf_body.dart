import 'package:flutter/material.dart';

import '../../data/models/ayah.dart';
import 'islamic_medallion.dart';

const _bismillahText = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';

class MushafPagerController {
  _MushafBodyState? _state;

  Future<void> jumpToAyah(int ayahId) async {
    await _state?.jumpToAyah(ayahId);
  }

  void _attach(_MushafBodyState state) {
    _state = state;
  }

  void _detach(_MushafBodyState state) {
    if (_state == state) _state = null;
  }
}

class MushafBody extends StatefulWidget {
  const MushafBody({
    super.key,
    required this.ayat,
    required this.fontScale,
    required this.showBismillah,
    required this.surahId,
    this.controller,
  });

  final List<Ayah> ayat;
  final double fontScale;
  final bool showBismillah;
  final int surahId;
  final MushafPagerController? controller;

  @override
  State<MushafBody> createState() => _MushafBodyState();
}

class _MushafBodyState extends State<MushafBody> {
  late final PageController _pageController;
  late List<List<Ayah>> _pages;
  late Map<int, int> _ayahToPage;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _rebuildPages();
    widget.controller?._attach(this);
  }

  @override
  void didUpdateWidget(covariant MushafBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ayat != oldWidget.ayat) {
      final prevIndex = _currentPage;
      _rebuildPages();
      if (prevIndex < _pages.length) {
        _pageController.jumpToPage(prevIndex);
      }
    }
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach(this);
      widget.controller?._attach(this);
    }
  }

  void _rebuildPages() {
    final result = _paginate(widget.ayat);
    _pages = result.$1;
    _ayahToPage = result.$2;
    _currentPage = 0;
  }

  Future<void> jumpToAyah(int ayahId) async {
    final page = _ayahToPage[ayahId];
    if (page == null) return;
    await _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    widget.controller?._detach(this);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_pages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    final total = _pages.length;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Page ${_currentPage + 1} / $total',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: total,
            onPageChanged: (value) {
              setState(() => _currentPage = value);
            },
            itemBuilder: (context, index) {
              final chunk = _pages[index];
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Text.rich(
                  TextSpan(
                    children: _buildSpans(
                      context,
                      chunk,
                      showBismillah: widget.showBismillah && index == 0,
                    ),
                  ),
                  textAlign: TextAlign.justify,
                  textDirection: TextDirection.rtl,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  List<InlineSpan> _buildSpans(
    BuildContext context,
    List<Ayah> ayat, {
    required bool showBismillah,
  }) {
    final spans = <InlineSpan>[];
    final theme = Theme.of(context);
    if (showBismillah) {
      spans.add(
        TextSpan(
          text: '$_bismillahText\n\n',
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 22 * widget.fontScale,
            height: 1.6,
          ),
        ),
      );
    }
    for (final a in ayat) {
      spans.add(
        TextSpan(
          text: '${a.textAr} ',
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 22 * widget.fontScale,
            height: 1.8,
          ),
        ),
      );
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 6, end: 10),
            child: IslamicMedallion(number: a.id, size: 26),
          ),
        ),
      );
    }
    return spans;
  }

  (List<List<Ayah>>, Map<int, int>) _paginate(List<Ayah> items) {
    const maxChars = 900;
    final pages = <List<Ayah>>[];
    final map = <int, int>{};
    var buffer = <Ayah>[];
    var charCount = 0;
    var pageIndex = 0;

    void pushBuffer() {
      if (buffer.isEmpty) return;
      pages.add(buffer);
      for (final ayah in buffer) {
        map[ayah.id] = pageIndex;
      }
      pageIndex++;
      buffer = <Ayah>[];
      charCount = 0;
    }

    for (final ayah in items) {
      final len = ayah.textAr.length;
      if (buffer.isNotEmpty && charCount + len > maxChars) {
        pushBuffer();
      }
      buffer.add(ayah);
      charCount += len;
    }
    pushBuffer();
    if (pages.isEmpty) {
      pages.add(const <Ayah>[]);
    }
    return (pages, map);
  }
}
