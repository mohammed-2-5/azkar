import 'package:flutter/material.dart';

import '../../../../core/i18n/format.dart';

String formatTimeOfDay(
  BuildContext context,
  DateTime dt, {
  required bool use24h,
}) {
  final base = use24h
      ? '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}'
      : TimeOfDay.fromDateTime(dt).format(context);
  return localizedDigits(context, base);
}

String humanizeDuration(Duration d) {
  final negative = d.isNegative;
  final s = d.inSeconds.abs();
  final h = s ~/ 3600;
  final m = (s % 3600) ~/ 60;
  final sec = s % 60;
  final parts = <String>[];
  if (h > 0) parts.add('${h}h');
  if (m > 0 || h > 0) parts.add('${m}m');
  parts.add('${sec}s');
  final text = parts.join(' ');
  return negative ? '-$text' : text;
}

String relativeFromNow(DateTime dt) {
  final now = DateTime.now();
  final diff = dt.difference(now);
  final abs = diff.abs();
  final h = abs.inHours;
  final m = abs.inMinutes.remainder(60);
  if (diff.isNegative) {
    if (h == 0 && m == 0) return 'just now';
    final hh = h > 0 ? '${h}h ' : '';
    final mm =
        '$m'
        'm';
    return 'passed $hh$mm';
  } else {
    final hh = h > 0 ? '${h}h ' : '';
    final mm =
        '$m'
        'm';
    return 'in $hh$mm';
  }
}
