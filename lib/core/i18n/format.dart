import 'package:flutter/material.dart';

String _toArabicDigits(String input) {
  const western = ['0','1','2','3','4','5','6','7','8','9'];
  const eastern = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
  var out = StringBuffer();
  for (final ch in input.runes) {
    final s = String.fromCharCode(ch);
    final idx = western.indexOf(s);
    out.write(idx >= 0 ? eastern[idx] : s);
  }
  return out.toString();
}

String localizedDigits(BuildContext context, String input) {
  final isAr = Localizations.localeOf(context).languageCode == 'ar';
  return isAr ? _toArabicDigits(input) : input;
}

