import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Song {
  final Source source;
  final String title;
  final String artist;
  final String? album = null;
  final String genre;
  final DateTime releaseDate;
  final String duration;
  final Image albumArt;
  final String lyrics;
  const Song(this.title, this.artist, this.genre, this.releaseDate,
      this.duration, this.albumArt, this.lyrics, this.source);
}

class SampleSong extends Song {
  SampleSong()
      : super(
          'Positive Thinking',
          'Vlad Gluschenko',
          'Pop',
          DateTime(2023, 11, 9),
          '3:00',
          // Photo by Adam Davis on Unsplash
          Image.asset(
            'assets/images/positive_thinking.jpg',
            fit: BoxFit.fill,
          ),
          'Sample Lyrics',
          AssetSource('positive_thinking.wav'),
        );
}
