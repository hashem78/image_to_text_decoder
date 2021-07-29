import 'package:dart_vlc/dart_vlc.dart';

class SoundPlayingService {
  static final Player _player = Player(id: 69420);
  static void playSucess() {
    Media media = Media.asset('assets/sounds/success.mp3');
    _player.stop();
    _player.open(media);
  }

  static void playFailure() {
    Media media = Media.asset('assets/sounds/failure.mp3');
    _player.stop();
    _player.open(media);
  }
}
