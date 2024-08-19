import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:audiotags/audiotags.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class Song {
  final Source source;
  final String path;
  final String title;
  final String? artist;
  final String? album = null;
  final String? genre;
  final DateTime? releaseDate;
  final Duration duration;
  final Image? albumArt;
  final String? lyrics;
  const Song(
      {required this.title,
      required this.source,
      required this.duration,
      this.albumArt,
      required this.path,
      this.lyrics,
      this.artist,
      this.genre,
      this.releaseDate});
}

Future<Song> songFromFile(File f) async {
  Tag? metadata;
  try {
    metadata = await AudioTags.read(f.path);
  } catch (e) {
    print("CANNOT LOAD METADATA $e");
    return SampleSong();
  }

  if (metadata == null) {
    return SampleSong();
  }
  var title = (metadata.title == null || metadata.title == ""
          ? path.basenameWithoutExtension(f.path)
          : metadata.title) ??
      "unable to load name";
  var artist = metadata.trackArtist;
  var genre = metadata.genre;
  var releaseDate;
  try {
    releaseDate = metadata.year == null ? null : DateTime(metadata.year!);
  } catch (e) {
    releaseDate = null;
  }
  Duration duration = Duration(milliseconds: metadata.duration! * 1000);
  print(duration);
  var albumArt = metadata.pictures.isEmpty
      ? Image.asset('assets/images/placeholder_album_art.png')
      : Image.memory(metadata.pictures.first.bytes);
  var lyrics = 'Lyrics not implemented yet :c'; // TODO Implement lyrics
  var source = DeviceFileSource(f.path);
  return Song(
    path: f.path,
    title: title,
    artist: artist,
    genre: genre,
    releaseDate: releaseDate,
    duration: duration,
    albumArt: albumArt,
    lyrics: lyrics,
    source: source,
  );
}

class SampleSong extends Song {
  SampleSong()
      : super(
          path: "assets/songs/positive_thinking.wav",
          title: 'Positive Thinking',
          artist: 'Vlad Gluschenko',
          genre: 'Pop',
          releaseDate: DateTime(2023, 11, 9),
          duration: Duration(minutes: 3),
          albumArt: Image.asset(
            'assets/images/positive_thinking.jpg',
            fit: BoxFit.fill,
          ),
          lyrics: 'Sample Lyrics',
          source: AssetSource('positive_thinking.wav'),
        );
}
