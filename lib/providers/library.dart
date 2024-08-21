import 'dart:developer' as dev;
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:project_fly/models/song.dart';

class MusicLibrary extends ChangeNotifier {
  List<MediaItem> _mediaItems = [];
  List<MediaItem> get songs => _mediaItems;

  MediaItem findSongById(String id) {
    dev.log("Finding song by id: $id");
    return _mediaItems.firstWhere((element) => element.id == id);
  }

  void updateSongList(Directory? dir) {
    print("Updating song list");
    _mediaItems = [];
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
          MediaItem? song = await songFromFile(entity);
          if (song != null) {
            addSong(song);
          }
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

  void addSong(MediaItem song) {
    _mediaItems.add(song);
    print("Added song ${song.title}");
    notifyListeners();
  }
}
