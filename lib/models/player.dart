import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_fly/models/song.dart';

class FlyAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler, ChangeNotifier {
  final _player = AudioPlayer();
  Source? _currentSource;
  double _volume = 0.5;
  double playbackSpeed = 1.0;
  Song? _currentSong;

  // * Getters * //
  get volume => _volume;
  get currentSong => _currentSong;
  // get isPlaying => !playbackState.isPaused;
  get isPlaying => _player.state == PlayerState.playing;

  void getSongs() async {
    Directory d = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> files = d.listSync();
    notifyListeners();
  }

  void _onPlayerStateChanged(PlayerState state) {
    if (state == PlayerState.stopped || state == PlayerState.disposed) {
      stop();
    }
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

  @override
  Future<void> play() async {
    if (_currentSource != null) {
      await _player.play(_currentSource!);
    } else {
      await _player.play(AssetSource('error.mp3'));
    }
  }

  Future<void> pause() => _player.pause();
  Future<void> stop() {
    _currentSong = null;
    // _currentSource = null;
    return _player.stop();
  }

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

  List<Song> _songs = [];

  List<Song> get songs => _songs;

  void addSong(Song song) {
    _songs.add(song);
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
    await for (FileSystemEntity entity
        in dir.list(recursive: true, followLinks: false)) {
      print(entity);
      if (entity is File) {
        var v = await songFromFile(entity);
        addSong(v);
      } else if (entity is Directory) {
        // Optional: Uncomment if you want to recurse into directories as they are found
        // await depthSearchFolder(entity);
      }
    }
  }

  void removeSong(Song song) {
    _songs.remove(song);
    notifyListeners();
  }
}
