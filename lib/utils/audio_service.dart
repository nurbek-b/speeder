/* External dependencies */
import 'package:audioplayers/audioplayers.dart';

class Audio {
  final AudioCache _audioCache = AudioCache(
    prefix: 'assets/audio/',
    fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP),
  );

  Future<void> playAudio() {
    return _audioCache.play('overspeed_notification.mp3');
  }
}
