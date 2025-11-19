import 'dart:developer' as dev;
import 'package:just_audio/just_audio.dart';

/// Service to manually play adhan sounds when notifications fire
/// This is a fallback mechanism when Android notification sounds fail
class SoundPlayerService {
  static final SoundPlayerService _instance = SoundPlayerService._internal();
  factory SoundPlayerService() => _instance;
  SoundPlayerService._internal();

  final AudioPlayer _player = AudioPlayer();

  /// Play an adhan sound by voice ID
  Future<void> playAdhan(String voiceId) async {
    try {
      final assetPath = _getAssetPath(voiceId);
      if (assetPath == null) {
        dev.log('No asset for voice: $voiceId', name: 'sound_player');
        return;
      }

      dev.log('Playing adhan: $assetPath', name: 'sound_player');
      await _player.stop();
      await _player.setAsset(assetPath);
      await _player.setVolume(1.0); // Max volume
      await _player.play();
      dev.log('Adhan playback started', name: 'sound_player');
    } catch (e) {
      dev.log('Failed to play adhan: $e', name: 'sound_player', level: 1000);
    }
  }

  String? _getAssetPath(String voiceId) {
    switch (voiceId) {
      case 'adhan1':
        return 'assets/audio/adhan1.mp3';
      case 'adhan2':
        return 'assets/audio/adhan2.mp3';
      default:
        return null;
    }
  }

  Future<void> stop() async {
    await _player.stop();
  }

  void dispose() {
    _player.dispose();
  }
}
