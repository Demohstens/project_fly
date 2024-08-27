import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:project_fly/main.dart';
import 'package:project_fly/models/song.dart';

class SongProvier extends ChangeNotifier {
  // * ATTRIBUTES * //

  RenderedSong? _currentSong;
  Duration? _currentPosition;
  Duration? _totalDuration;
  bool _playing = false;

  // * Constructor * //

  SongProvier() {
    _initiateListeners();
  }

  // * GETTERS * //

  RenderedSong? get currentSong => _currentSong;
  Duration? get currentPosition => _currentPosition;
  Duration? get totalDuration => _totalDuration;
  bool get isPlaying => _playing;

  // * SETTERS * //

  // * METHODS * //

  _initiateListeners() {
    // Listen to the current song
    audioHandler.currentSong.listen((song) {
      log("SongProvider: Current Song changed: ${song?.title}");
      _currentSong = song;
      notifyListeners();
    });

    // Listen to the current position
    // audioHandler.player.positionStream.listen((position) {
    //   _currentPosition = position;
    //   notifyListeners();
    // });

    // Listen to the total duration
    // audioHandler.player.durationStream.listen((duration) {
    //   _totalDuration = duration;
    //   notifyListeners();
    // });

    // Listen to the player state
    audioHandler.playbackState.listen((state) {
      _playing = state.playing;

      notifyListeners();
    });
  }
}
