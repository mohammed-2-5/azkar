class AyahRef {
  final int surah;
  final int ayah;
  const AyahRef(this.surah, this.ayah);

  @override
  bool operator ==(Object other) =>
      other is AyahRef && other.surah == surah && other.ayah == ayah;

  @override
  int get hashCode => Object.hash(surah, ayah);

  @override
  String toString() => 'AyahRef($surah:$ayah)';
}
