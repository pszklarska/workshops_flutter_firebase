import 'package:audioplayers/audio_cache.dart';

class Player {
  final AudioCache _audioCache = AudioCache();

  void playSound() async {
    await _audioCache.play('yo_sound.mp3');
  }
}
