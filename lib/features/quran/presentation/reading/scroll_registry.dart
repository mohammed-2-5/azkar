import 'package:flutter/material.dart';

import 'ayah_ref.dart';

class QuranScrollRegistry {
  final Map<AyahRef, GlobalKey> _keys = {};

  GlobalKey keyFor(AyahRef ref) => _keys.putIfAbsent(ref, () => GlobalKey());

  Future<void> scrollTo(
    AyahRef ref, {
    Duration duration = const Duration(milliseconds: 350),
    double alignment = 0.1,
  }) async {
    final key = _keys[ref];
    if (key == null) return;
    final ctx = key.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx,
      duration: duration,
      alignment: alignment,
      curve: Curves.easeOut,
    );
  }

  void clear() => _keys.clear();
}
