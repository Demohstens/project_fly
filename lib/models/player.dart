import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class FlyAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler, ChangeNotifier {
  final _player = AudioPlayer();
  Source? _currentSource;

  @override
  Future<void> play() async {
    if (_currentSource != null) {
      await _player.play(_currentSource!);
    } else {
      await _player.play(AssetSource('error.mp3'));
    }
  }

  Future<void> pause() => _player.pause();
  Future<void> stop() => _player.stop();
  Future<void> seek(Duration position) => _player.seek(position);

  void setSource(Source source) {
    _currentSource = source;
    // play();
    notifyListeners();
  }

  /// Change the volume of the player from 0-1.
  void changeVolume(double volume) {
    _player.setVolume(volume);
    notifyListeners();
  }
}
