import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_fly/main.dart';
import 'package:project_fly/models/song.dart';

class FlyAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler, ChangeNotifier {
  final _player = AudioPlayer();
  Source? _currentSource;
  double _volume = 0.2;
  double playbackSpeed = 1.0;
  Song? _currentSong;
  bool _isPlaying = false;
  Duration? _currentDuration;
  @override
  FlyAudioHandler() {
    _player.setVolume(volume);

    _player.onPositionChanged.listen((state) {
      _onPositionChanged(state);
    });
  }

  // * Getters * //
  get volume => _volume;
  get currentSong => _currentSong;
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
    //TODO: Implement skipToNext
    return;
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

  void playSong(Song song) {
    _currentSong = song;
    setSource(song.source);
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
    notifyListeners();
  }

  /// Change the volume of the player from 0-1.
  void changeVolume(double volume) async {
    await _player.setVolume(volume);
    _volume = volume;
    notifyListeners();
  }

  List<Song> _songs = [];

  List<Song> get songs => _songs;

  void addSong(Song song) {
    _songs.add(song);
    if (user != null) {
      if (user!.id.isNotEmpty) {
        if (user!.songs.contains(song.path)) {
          print("Song already in user's library");
        } else {
          user!.songs.add({
            'path': song.path,
            'title': song.title,
            'artist': song.artist,
            'album': song.album,
            'duration': song.duration.toString(),
          });
          db.collection("users").doc(user!.id).update({'songs': user!.songs});
        }
      } else {
        print("User id is empty");
      }
    }

    print("Added song ${song.title}");
    notifyListeners();
  }

  void updateSongList(Directory? dir) {
    print("Updating song list");
    _songs = [];
    if (dir == null) {
      print("Cant update song list, dir is null");
      return;
    }
    depthSearchFolder(dir);
    notifyListeners();
  }

  Future<void> depthSearchFolder(Directory dir) async {
    print("Searching folder: ${dir.path}");
    await for (FileSystemEntity entity
        in dir.list(recursive: true, followLinks: false)) {
      print(entity);
      if (entity is File) {
        String ext = entity.path.split('.').last;
        if (ext == 'mp3' || ext == 'm4a' || ext == 'flac' || ext == 'mp4') {
          var v = await songFromFile(entity);
          addSong(v);
        } else {
          print("Skipping file ${entity.path}. Format not supported");
        }
      } else if (entity is Directory) {
        // Optional: Uncomment if you want to recurse into directories as they are found
        // await depthSearchFolder(entity);
      }
    }
    notifyListeners();
  }

  void removeSong(Song song) {
    _songs.remove(song);
    notifyListeners();
  }
}
