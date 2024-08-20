import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_fly/models/song.dart';

class MusicLibrary extends ChangeNotifier {
  List<Song> _songs = [];
  List<Song> get songs => _songs;

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

  void addSong(Song song) {
    _songs.add(song);

    print("Added song ${song.title}");
    notifyListeners();
  }
}
