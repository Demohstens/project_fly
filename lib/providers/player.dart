import 'dart:developer' as dev;
import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_fly/providers/library.dart';
import 'package:project_fly/models/song.dart';
import 'package:rxdart/src/subjects/behavior_subject.dart';

class FlyAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler, ChangeNotifier {
  final MusicLibrary musicLibrary;
  final _player = AudioPlayer();
  double _volume = 0.2;
  double playbackSpeed = 1.0;
  RenderedSong? _currentSong;
  Duration _currentDuration = Duration.zero;
  BehaviorSubject<PlaybackState> _playbackStateSubject =
      BehaviorSubject<PlaybackState>.seeded(PlaybackState());

  BehaviorSubject<PlaybackState> get playbackState => _playbackStateSubject;

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

  void registerPlayerStateListener(Function(PlayerState?) func) {
    _player.onPlayerStateChanged.listen(func);
  }

  void _onPlayerStateChanged(PlayerState state) {
    if (state == PlayerState.stopped || state == PlayerState.disposed) {
      stop();
    }
  }

  @override
  Future<void> skipToNext() async {
    dev.log('Skipping to next $queue');

    super.skipToNext();
    //TODO: Implement skipToNext
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) {
    dev.log('Adding item to queue', name: 'FlyAudioHandler');
    return super.addQueueItem(mediaItem);
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    super.addQueueItems(mediaItems);
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
    dev.log("Toggling playing");
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

  void playSong(RenderedSong song) async {
    MediaItem mItem = await song.toMediaItem();
    return playMediaItem(mItem);
  }

  Future<void> playMediaItem(MediaItem mediaItem) async {
    // addQueueItem(mediaItem);
    await playFromMediaId(mediaItem.id);
  }

  void playErrorSound() {
    _player.play(AssetSource('error.mp3'));
  }

  Future<void> play() async {
    _currentDuration = Duration.zero;
    if (currentSong != null) {
      await _player.play(DeviceFileSource(currentSong!.path));
    } else {
      await _player.play(AssetSource('error.mp3'));
    }
    List<MediaItem> queueItems = musicLibrary.songs;
    _playbackStateSubject.add(PlaybackState(playing: true));
    await addQueueItems(queueItems);
    notifyListeners();
  }

  Future<void> pause() async {
    await _player.pause();
    _playbackStateSubject.add(PlaybackState(playing: false));

    notifyListeners();
  }

  Future<void> stop() async {
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
}
