class AzanVoice {
  final String id;
  final String label;
  final String? assetPath;
  final String description;
  const AzanVoice({
    required this.id,
    required this.label,
    required this.description,
    this.assetPath,
  });

  static const AzanVoice systemDefault = AzanVoice(
    id: 'default',
    label: 'System Default',
    description: 'Use the device notification sound.',
    assetPath: null,
  );

  static const AzanVoice classic = AzanVoice(
    id: 'adhan1',
    label: 'Adhan Classic',
    description: 'Full takbir with strong cadence.',
    assetPath: 'assets/audio/adhan1.mp3',
  );

  static const AzanVoice calm = AzanVoice(
    id: 'adhan2',
    label: 'Adhan Calm',
    description: 'Softer rendition ideal for night reminders.',
    assetPath: 'assets/audio/adhan2.mp3',
  );

  static const List<AzanVoice> all = [systemDefault, classic, calm];

  static AzanVoice byId(String id) {
    return all.firstWhere((v) => v.id == id, orElse: () => systemDefault);
  }
}
