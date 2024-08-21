// import 'dart:developer' as dev;
// import 'package:audio_service/audio_service.dart';
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:project_fly/providers/library.dart';
// import 'package:project_fly/models/song.dart';
// import 'package:rxdart/src/subjects/behavior_subject.dart';

// class FlyAudioHandler extends BaseAudioHandler
//     with QueueHandler, SeekHandler, ChangeNotifier {
//   final MusicLibrary musicLibrary;
//   final _player = AudioPlayer();
//   double _volume = 0.07;
//   double playbackSpeed = 1.0;
//   int queueIndex = 0;
//   RenderedSong? _currentSong;
//   Duration _currentDuration = Duration.zero;
//   final BehaviorSubject<PlaybackState> _playbackStateSubject =
//       BehaviorSubject<PlaybackState>.seeded(PlaybackState());

//   @override
//   BehaviorSubject<PlaybackState> get playbackState => _playbackStateSubject;

//   @override
//   FlyAudioHandler({required this.musicLibrary}) {
//     _player.setVolume(volume);
//     _player.positionStream.listen((event) {
//       _currentDuration = event;

//       notifyListeners();
//     });
//     _player.playingStream.listen((event) {
//       _playbackStateSubject.add(PlaybackState(playing: event));
//       notifyListeners();
//     });
//   }

//   // * Getters * //
//   get volume => _volume;
//   RenderedSong? get currentSong => _currentSong;
//   Duration? get currentDuration => _currentDuration;
//   AudioPlayer get player => _player;
//   LoopMode get loopMode => _player.loopMode;

//   Future<void> cycleRepeatMode() {
//     LoopMode nextMode;
//     switch (_player.loopMode) {
//       case LoopMode.off:
//         nextMode = LoopMode.one;
//         break;
//       case LoopMode.one:
//         nextMode = LoopMode.all;
//         break;
//       case LoopMode.all:
//         nextMode = LoopMode.off;
//         break;
//     }
//     return setLoopMode(nextMode);
//   }

//   Future<void> setLoopMode(LoopMode repeatMode) async {
//     _player.setLoopMode(repeatMode);
//   }

//   @override
//   Future<void> skipToNext() async {
//     if (queueIndex + 1 >= queue.value.length) return;
//     _currentSong = RenderedSong.fromMediaItem(queue.value[queueIndex + 1]);
//     _player.setAudioSource(_currentSong!.source);
//     queueIndex++;
//     play();
//   }

//   @override
//   Future<void> addQueueItem(MediaItem mediaItem) {
//     dev.log('Adding item to queue', name: 'FlyAudioHandler');

//     return super.addQueueItem(mediaItem);
//   }

//   @override
//   Future<void> skipToQueueItem(int i) {
//     playbackState.add(PlaybackState(queueIndex: i));

//     return _player.seek(Duration.zero, index: i);
//   }

//   @override
//   Future<void> addQueueItems(List<MediaItem> mediaItems) async {
//     super.addQueueItems(mediaItems);
//   }

//   @override
//   Future<void> skipToPrevious() async {
//     super.skipToPrevious();
//   }

//   void togglePlaying() {
//     dev.log("Toggling playing");
//     if (playbackState.value.playing) {
//       pause();
//     } else {
//       play();
//     }
//   }

//   @override
//   Future<void> playFromMediaId(String mediaId,
//       [Map<String, dynamic>? extras]) async {
//     // TODO: implement playFromMediaId

//     // 1. Find the song in your song library
//     MediaItem? song = musicLibrary.findSongById(
//         mediaId); // Assuming you have a musicLibrary instance available

//     RenderedSong renderedSong = RenderedSong.fromMediaItem(song);
//     _player.setAudioSource(
//         renderedSong.source); // Assuming your player has a setSource method

//     // 4. Start playback
//     playbackState.add(PlaybackState(playing: true));

//     play(); // or _player.play() if not already playing

//     _currentSong = renderedSong;
//     playbackState.add(playbackState.value.copyWith(
//       processingState: AudioProcessingState.ready,
//       playing: true,
//     )); // Assuming playbackState is a BehaviorSubject
//     // Update the queue and queueIndex
//     List<MediaItem> queueItems = musicLibrary.songs;
//     await addQueueItems(queueItems);
//     playbackState.add(playbackState.value.copyWith(
//       queueIndex: 0, // Set the initial queueIndex to 0
//     ));

//     notifyListeners();
//   }

//   void playSong(RenderedSong song) async {
//     MediaItem mItem = await song.toMediaItem();
//     return playMediaItem(mItem);
//   }

//   Future<void> playMediaItem(MediaItem mediaItem) async {
//     RenderedSong renderedSong = RenderedSong.fromMediaItem(mediaItem);
//     _player.setAudioSource(renderedSong.source);

//     await play();

//     _currentSong = renderedSong;
//     playbackState.add(playbackState.value.copyWith(
//       processingState: AudioProcessingState.ready,
//       playing: true,
//     )); // Assuming playbackState is a BehaviorSubject
//     List<MediaItem> queueItems = musicLibrary.songs;
//     await addQueueItems(queueItems);
//     playbackState.add(playbackState.value.copyWith(
//       queueIndex: 0, // Set the initial queueIndex to 0
//     ));

//     notifyListeners();
//   }

//   void playErrorSound() {
//     _player.setAsset('assets/error.mp3');
//     _player.play();
//   }

//   @override
//   Future<void> play() async {
//     _currentDuration = Duration.zero;
//     if (currentSong != null) {
//       await _player.play();
//       playbackState.add(PlaybackState(playing: true));

//       List<MediaItem> queueItems = musicLibrary.songs;
//       await addQueueItems(queueItems);
//       notifyListeners();
//     } else {
//       playErrorSound();
//     }
//   }

//   Future<void> pause() async {
//     await _player.pause();
//     _playbackStateSubject.add(PlaybackState(playing: false));

//     notifyListeners();
//   }

//   Future<void> stop() async {
//     _currentSong = null;
//     await _player.stop();
//     _playbackStateSubject.add(PlaybackState(playing: false));

//     notifyListeners();
//   }

//   Future<void> seekTo(Duration position) => _player.seek(position);

//   /// Change the volume of the player from 0-1.
//   void changeVolume(double volume) async {
//     await _player.setVolume(volume);
//     _volume = volume;
//     notifyListeners();
//   }
// }
