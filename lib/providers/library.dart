import 'dart:developer' as dev;
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:project_fly/main.dart';
import 'package:project_fly/models/song.dart';

class MusicLibrary {
  List<MediaItem> get songs => userData.songs;
  List<MediaItem> _songsTemp = [];

  MusicLibrary() {
    dev.log("MusicLibrary initialized");
  }

  MediaItem findSongById(String id) {
    dev.log("Finding song by id: $id");
    return songs.firstWhere((element) => element.id == id);
  }

  void updateSongList(Directory? dir) {
    print("Updating song list");
    _songsTemp = [];
    if (dir == null) {
      dev.log("Cant update song list, dir is null");
      return;
    }
    depthSearchFolder(dir);
    userData.songs = _songsTemp;
    userData.saveData();
  }

  Future<void> depthSearchFolder(Directory dir) async {
    dev.log("Searching folder: ${dir.path}");
    await for (FileSystemEntity entity
        in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        String ext = entity.path.split('.').last;
        if (ext == 'mp3' || ext == 'm4a' || ext == 'flac' || ext == 'mp4') {
          MediaItem? song = await songFromFile(entity);
          if (song != null) {
            addSong(song);
          }
        } else {}
      } else if (entity is Directory) {
        // Optional: Uncomment if you want to recurse into directories as they are found
        // await depthSearchFolder(entity);
      }
    }
  }

  void addSong(MediaItem song) {
    _songsTemp.add(song);
  }
}
