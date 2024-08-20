import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_fly/main.dart';
import 'package:project_fly/models/queue.dart';
import 'package:project_fly/models/song.dart';
import 'package:rxdart/src/subjects/behavior_subject.dart';

class FlyAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler, ChangeNotifier {
  final _player = AudioPlayer();
  Source? _currentSource;
  double _volume = 0.2;
  double playbackSpeed = 1.0;
  RenderedSong? _currentSong;
  bool _isPlaying = false;
  Duration _currentDuration = Duration.zero;
  @override
  FlyAudioHandler() {
    _player.setVolume(volume);

    _player.onPositionChanged.listen((state) {
      _onPositionChanged(state);
    });
  }

  // * Getters * //
  get volume => _volume;
  RenderedSong? get currentSong => _currentSong;
  get isPlaying => _isPlaying;
  Duration? get currentDuration => _currentDuration;

  // void getSongs() async {
  //   Directory d = await getApplicationDocumentsDirectory();
  //   List<FileSystemEntity> files = d.listSync();
  //   notifyListeners();
  // }
  void _onPositionChanged(Duration position) {
    _currentDuration = position;
    notifyListeners();
  }

  void _onPlayerStateChanged(PlayerState state) {
    if (state == PlayerState.stopped || state == PlayerState.disposed) {
      stop();
    }
  }

  @override
  Future<void> skipToNext() async {
    super.skipToNext();
    //TODO: Implement skipToNext
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) {
    // TODO: implement addQueueItem
    return super.addQueueItem(mediaItem);
  }

  @override
  Future<void> skipToPrevious() async {
    super.skipToPrevious();
  }

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

  void playSong(Song song) async {
    _currentSong = await song.render();
    setSource(_currentSong!.source);
    play();
  }

  Future<void> play() async {
    if (_currentSource != null) {
      await _player.play(_currentSource!);
      _isPlaying = true;
    } else {
      await _player.play(AssetSource('error.mp3'));
    }
    notifyListeners();
  }

  Future<void> pause() {
    _isPlaying = false;
    notifyListeners();

    return _player.pause();
  }

  Future<void> stop() {
    _isPlaying = false;
    _currentSong = null;
    notifyListeners();

    // _currentSource = null;
    return _player.stop();
  }

  Future<void> seekTo(Duration position) => _player.seek(position);

  void setSource(Source source) {
    _currentSource = source;
    // play();
    // notifyListeners();
  }

  /// Change the volume of the player from 0-1.
  void changeVolume(double volume) async {
    await _player.setVolume(volume);
    _volume = volume;
    notifyListeners();
  }

  List<Song> _songs = [];

  List<Song> get songs => _songs;

  void removeSong(Song song) {
    _songs.remove(song);
    notifyListeners();
  }

  @override
  // TODO: implement playbackState
  BehaviorSubject<PlaybackState> get playbackState {
    super.playbackState.add(PlaybackState(
          // Which buttons should appear in the notification now
          controls: [
            MediaControl.skipToPrevious,
            MediaControl.pause,
            isPlaying ? MediaControl.pause : MediaControl.play,
            MediaControl.skipToNext,
          ],
          // Which other actions should be enabled in the notification
          systemActions: const {
            MediaAction.seek,
          },
          // Which controls to show in Android's compact view.
          androidCompactActionIndices: const [0, 1, 3],
          // Whether audio is ready, buffering, ...
          processingState: AudioProcessingState.ready,
          // Whether audio is playing
          playing: isPlaying,
          // The current position as of this update. You should not broadcast
          // position changes continuously because listeners will be able to
          // project the current position after any elapsed time based on the
          // current speed and whether audio is playing and ready. Instead, only
          // broadcast position updates when they are different from expected (e.g.
          // buffering, or seeking).
          updatePosition: Duration.zero,
          // The current speed
          speed: playbackSpeed,
          // The current queue position
          queueIndex: 0,
        ));
    return super.playbackState;
  }
}
