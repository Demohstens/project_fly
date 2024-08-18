import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class FlyAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler, ChangeNotifier {
  final _player = AudioPlayer();
  Source? _currentSource;
  double _volume = 0.5;
  double playbackSpeed = 1.0;

  // * Getters * //
  get volume => _volume;
  // get isPlaying => !playbackState.isPaused;
  get isPlaying => _player.state == PlayerState.playing;

  /// Defines behavior of the player when the playback is stopped.
  void setReleaseMode(ReleaseMode releaseMode) {
    _player.setReleaseMode(releaseMode);
    notifyListeners();
  }

  void togglePlaying() {
    if (isPlaying) {
      pause();
    } else {
      play();
    }
  }

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
  void changeVolume(double volume) async {
    await _player.setVolume(volume);
    _volume = volume;
    notifyListeners();
  }
}
