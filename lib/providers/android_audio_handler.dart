import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:project_fly/main.dart';
import 'package:project_fly/models/song.dart';
import 'package:rxdart/rxdart.dart';

class AndroidAudioHandler extends BaseAudioHandler {
  // * ATTRIBUTES * //

  final _player = AudioPlayer();

  bool _readyToPlay = false;

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
    await _player.setAudioSource(source);
    currentSong.add(RenderedSong.fromMediaItem(mediaItem));

    // Handles the creation of the queue
    // TODO: Implement queue
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
    if (_readyToPlay == false) {
      log("Attempted to play before ready");
      return;
    }
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
    await _player.play();
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
    currentSong = RenderedSong.fromMediaItem(queue.value[queueIndex + 1])
        as BehaviorSubject<RenderedSong?>;
    _player.setAudioSource(currentSong.value!.source);
    queueIndex++;
    play();
  }

  @override
  Future<void> skipToPrevious() async {
    await _player.seekToPrevious();
  }

  Future<void> cycleRepeatMode() {
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
    return setLoopMode(nextMode);
  }

  Future<void> setLoopMode(LoopMode repeatMode) async {
    _player.setLoopMode(repeatMode);
  }

  /* Methods Responsible for managing the Queue */

  void generateQueue() {
    if (!Platform.isAndroid) {
      if (queue.value.isEmpty) {
        addQueueItems(musicLibrary.songs);
      }
    } else {
      List<AudioSource> sources = [];
      for (MediaItem item in musicLibrary.songs) {
        sources.add(AudioSource.file(item.extras!['path']));
      }
      _player.setAudioSource(ConcatenatingAudioSource(children: sources));
    }
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    if (Platform.isAndroid) {
      List<AudioSource> sources = [];
      for (MediaItem item in mediaItems) {
        sources.add(AudioSource.file(item.extras!['path']));
      }
      await _player.setAudioSource(ConcatenatingAudioSource(children: sources));
    } else {
      queue.add(mediaItems);
    }
  }

  void clearQueue() {
    queue.value.clear();
  }

  // * LISTENERS * //
  void _registerListeners() {
    // _player.playerStateStream.listen((event) {
    //   if (event.playing) {
    //     playbackState.add(playbackState.value.copyWith(playing: true));
    //   } else {
    //     playbackState.add(playbackState.value.copyWith(playing: false));
    //   }
    // });
    _player.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.ready) {
        if (_readyToPlay == false) {
          log("Ready to play");
          _readyToPlay = true;
          play();
        }
      } else {
        _readyToPlay = false;
      }
    });
  }

  void addPlayStateListener(Function(PlaybackState) func) {
    playbackState.listen((event) {
      func(event);
    });
  }

  StreamSubscription addPositionListener(Function(Duration) func) {
    return _player.positionStream.listen((event) {
      func(event);
    });
  }

  void dispose() {
    _player.dispose();
  }
}