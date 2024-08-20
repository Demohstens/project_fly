import 'dart:developer';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_fly/providers/library.dart';
import 'package:project_fly/models/queue.dart';

import 'package:project_fly/models/song.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/src/subjects/behavior_subject.dart';

class FlyAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler, ChangeNotifier {
  final MusicLibrary musicLibrary;
  final _player = AudioPlayer();
  double _volume = 0.2;
  double playbackSpeed = 1.0;
  RenderedSong? _currentSong;
  bool _isPlaying = false;
  Duration _currentDuration = Duration.zero;
  @override
  FlyAudioHandler({required this.musicLibrary}) {
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
    log('Skipping to next $queue');

    super.skipToNext();
    //TODO: Implement skipToNext
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) {
    log('Adding item to queue', name: 'FlyAudioHandler');
    return super.addQueueItem(mediaItem);
  }

  @override
  Future<void> addQueueItems(List<MediaItem> items) async {
    super.addQueueItems(items);
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
    if (playbackState.value.playing) {
      pause();
    } else {
      play();
    }
  }

  Future<void> onPlayFromMediaId(String mediaId,
      [Map<String, dynamic>? extras]) async {
    // 1. Find the song in your song library
    MediaItem? song = musicLibrary.findSongById(
        mediaId); // Assuming you have a musicLibrary instance available

    RenderedSong renderedSong = await RenderedSong.fromMediaItem(song);
    _player.setSource(
        renderedSong.source); // Assuming your player has a setSource method

    // 4. Start playback
    await _player
        .play(renderedSong.source); // or _player.play() if not already playing

    _isPlaying = true;
    _currentSong = renderedSong;
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.ready,
      playing: true,
    )); // Assuming playbackState is a BehaviorSubject
    // Update the queue and queueIndex
    List<MediaItem> queueItems = musicLibrary.songs;
    await addQueueItems(queueItems);
    playbackState.add(playbackState.value.copyWith(
      queueIndex: 0, // Set the initial queueIndex to 0
    ));

    notifyListeners();
  }

  @override
  Future<void> playFromMediaId(String mediaId, [Map<String, dynamic>? extras]) {
    // TODO: implement playFromMediaId
    return onPlayFromMediaId(mediaId, extras);
  }

  void playSong(Song song) async {
    MediaItem mItem = await song.toMediaItem();
    return playMediaItem(mItem);
  }

  Future<void> playMediaItem(MediaItem mediaItem) async {
    addQueueItem(mediaItem);
    await playFromMediaId(mediaItem.id);
  }

  void playErrorSound() {
    _player.play(AssetSource('error.mp3'));
  }

  Future<void> play() async {
    _currentDuration = Duration.zero;
    if (currentSong != null) {
      await _player.play(DeviceFileSource(currentSong!.path));
      _isPlaying = true;
    } else {
      await _player.play(AssetSource('error.mp3'));
    }
    List<MediaItem> queueItems = musicLibrary.songs;

    await addQueueItems(queueItems);
    notifyListeners();
  }

  Future<void> pause() async {
    _isPlaying = false;
    await _player.pause();
    notifyListeners();
  }

  Future<void> stop() async {
    _isPlaying = false;
    _currentSong = null;
    _player.stop();

    notifyListeners();
  }

  Future<void> seekTo(Duration position) => _player.seek(position);

  /// Change the volume of the player from 0-1.
  void changeVolume(double volume) async {
    await _player.setVolume(volume);
    _volume = volume;
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
