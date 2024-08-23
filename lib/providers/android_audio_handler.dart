import 'dart:async';
import 'dart:developer';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:project_fly/main.dart';
import 'package:project_fly/models/song.dart';
import 'package:rxdart/rxdart.dart';

class AndroidAudioHandler extends BaseAudioHandler {
  // * ATTRIBUTES * //

  final _player = AudioPlayer();

  int queueIndex = 0;

  BehaviorSubject<RenderedSong?> currentSong = BehaviorSubject.seeded(null);

  // * Constructor * //
  AndroidAudioHandler() {
    _registerListeners();
    playbackState.add(playbackState.value.copyWith(
        controls: [MediaControl.play],
        processingState: AudioProcessingState.idle));
    _player.setVolume(0.15);
  }

  // * GETTERS * //
  AudioPlayer get player => _player;

  // * SETTERS * //
  set mediaItem(BehaviorSubject<MediaItem?> value) {
    playbackState.add(playbackState.value.copyWith(
        controls: [MediaControl.play],
        processingState: AudioProcessingState.idle));
    mediaItem = value;
  }

  void setVolume(double volume) {
    _player.setVolume(volume);
  }

  // * METHODS * //

  /* Methods Responsible for playing audio */
  @override
  Future<void> playMediaItem(MediaItem mediaItem) async {
    // Creates an audio source from the media item
    AudioSource source = AudioSource.file(mediaItem.extras!['path']);

    // Loads the audio source into the player
    _player.setAudioSource(source);

    play();
    currentSong.add(RenderedSong.fromMediaItem(mediaItem));
  }

  @override
  Future<void> click([MediaButton button = MediaButton.media]) async {
    switch (button) {
      case MediaButton.media:
        if (playbackState.value.playing == true) {
          await pause();
        } else {
          await play();
        }
        break;
      case MediaButton.next:
        await skipToNext();
        break;
      case MediaButton.previous:
        await skipToPrevious();
        break;
    }
  }

  @override
  Future<void> seek(Duration position) {
    return _player.seek(position);
  }

  void togglePlaying() {
    if (playbackState.value.playing == true) {
      pause();
    } else {
      play();
    }
  }

  @override
  Future<void> play() async {
    // Wait for the player to be ready. This is arbitrary.
    // However an await on setAudioSource does not work.
    await Future.delayed(
        const Duration(milliseconds: 100)); // Adjust delay as needed

    _player.play();
    playbackState.add(playbackState.value.copyWith(
        playing: true,
        controls: [
          MediaControl.skipToPrevious,
          MediaControl.pause,
          MediaControl.skipToNext,
        ],
        processingState: AudioProcessingState.ready,
        systemActions: {MediaAction.seek}));
    generateQueue();
  }

  @override
  Future<void> pause() async {
    playbackState.add(playbackState.value.copyWith(
        playing: false,
        controls: [
          MediaControl.skipToPrevious,
          MediaControl.play,
          MediaControl.skipToNext,
        ],
        processingState: AudioProcessingState.ready,
        systemActions: {MediaAction.seek}));

    await _player.pause();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    playbackState.add(playbackState.value.copyWith(
        playing: false,
        controls: [MediaControl.play],
        processingState: AudioProcessingState.idle));
  }

  @override
  Future<void> skipToNext() async {
    if (queueIndex + 1 >= queue.value.length) return;
    currentSong.add(RenderedSong.fromMediaItem(queue.value[queueIndex + 1]));
    _player.setAudioSource(currentSong.value!.source, preload: true);
    queueIndex++;
    await Future.delayed(
        const Duration(milliseconds: 200)); // Adjust delay as needed

    play();
  }

  @override
  Future<void> skipToPrevious() async {
    await _player.seekToPrevious();
  }

  LoopMode cycleRepeatMode() {
    LoopMode nextMode;
    switch (_player.loopMode) {
      case LoopMode.off:
        nextMode = LoopMode.one;
        break;
      case LoopMode.one:
        nextMode = LoopMode.all;
        break;
      case LoopMode.all:
        nextMode = LoopMode.off;
        break;
    }
    setLoopMode(nextMode);
    return nextMode;
  }

  Future<void> setLoopMode(LoopMode repeatMode) async {
    _player.setLoopMode(repeatMode);
  }

  /* Methods Responsible for managing the Queue */

  void generateQueue() {
    queue.add(userData.songs.sublist(1, userData.songs.length));
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    queue.add(mediaItems);
  }

  void clearQueue() {
    queue.value.clear();
  }

  // * LISTENERS * //
  void _registerListeners() {
    _player.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        skipToNext();
      }
    });
  }

  void addPlayStateListener(Function(PlaybackState) func) {}

  StreamSubscription addPositionListener(Function(Duration) func) {
    return _player.positionStream.listen((event) {
      func(event);
    });
  }

  void dispose() {
    _player.dispose();
  }
}
