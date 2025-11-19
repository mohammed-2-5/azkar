import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class QuranDiagnostics {
  static Future<QuranDiagResult> preflight() async {
    if (kReleaseMode) return const QuranDiagResult();
    int missingAr = 0;
    int missingEn = 0;
    for (int i = 1; i <= 114; i++) {
      final arKey = 'assets/quran/chapters/ar/$i.json';
      final enKey = 'assets/quran/chapters/en/$i.json';
      if (!await _exists(arKey)) missingAr++;
      if (!await _exists(enKey)) missingEn++;
    }
    dev.log(
      'Quran preflight: missing AR: $missingAr, missing EN: $missingEn',
      name: 'quran.diag',
    );
    return QuranDiagResult(missingAr: missingAr, missingEn: missingEn);
  }

  static Future<bool> _exists(String key) async {
    try {
      await rootBundle.loadString(key);
      return true;
    } catch (_) {
      return false;
    }
  }
}

class QuranDiagResult {
  final int missingAr;
  final int missingEn;
  const QuranDiagResult({this.missingAr = 0, this.missingEn = 0});
}
