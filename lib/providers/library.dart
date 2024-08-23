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

  void addSong(MediaItem song) {
    _songsTemp.add(song);
  }
}
