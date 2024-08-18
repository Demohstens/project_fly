import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_fly/models/song.dart';

class Songs extends ChangeNotifier {
  List<Song> _songs = [];

  List<Song> get songs => _songs;

  void addSong(Song song) {
    _songs.add(song);
    notifyListeners();
  }

  void updateSongList() {
    songFromFile(File(
            "C:\\Users\\demoh\\Documents\\Code\\Dart\\project_fly\\assets\\positive_thinking.wav"))
        .then((Song song) {
      addSong(song);
    });
  }

  void removeSong(Song song) {
    _songs.remove(song);
    notifyListeners();
  }
}
