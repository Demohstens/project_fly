import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class FlyAudioPlayer extends BaseAudioHandler with QueueHandler, SeekHandler {
  final _player = AudioPlayer();

  FlyAudioPlayer() {
    _player
        .setAudioSource(AudioSource.asset('assets/positive_thinking.mp3'))
        .catchError((e) {
      print('Error setting audio source: $e');
    });
  }

  @override
  Future<void> play() async {
    try {
      await _player.play();
      print("Playing");
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> pause() => _player.pause();
  Future<void> stop() => _player.stop();
  Future<void> seek(Duration position) => _player.seek(position);
  Future<void> skipToQueueItem(int i) => _player.seek(Duration.zero, index: i);
}

class FlyAudioProvier extends ChangeNotifier {
  FlyAudioPlayer _audioHandler;
  FlyAudioProvier(this._audioHandler);

  FlyAudioPlayer get audioHandler => _audioHandler;
}
