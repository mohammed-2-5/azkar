String normalizeArabic(String input) {
  var s = input;
  // Remove harakat and annotation marks
  final diacritics = RegExp('[\u064B-\u0652\u0670\u06D6-\u06ED]');
  s = s.replaceAll(diacritics, '');
  // Remove tatweel
  s = s.replaceAll('\u0640', '');
  // Unify alef forms
  s = s
      .replaceAll('أ', 'ا')
      .replaceAll('إ', 'ا')
      .replaceAll('آ', 'ا');
  // Unify ya/aleph maqsurah
  s = s.replaceAll('ى', 'ي');
  // Optional: unify ta marbuta to ه or ة; choose ة for readability
  // No change needed for matching; map to ه can be used if wanted.
  return s;
}

String normalizeLatin(String input) => input.toLowerCase();

