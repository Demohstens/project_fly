import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';

class Song {
  final Source source;
  final String title;
  final String? artist;
  final String? album = null;
  final String? genre;
  final DateTime? releaseDate;
  final Duration duration;
  final Image albumArt;
  final String? lyrics;
  const Song(
      {required this.title,
      required this.source,
      required this.duration,
      required this.albumArt,
      this.lyrics,
      this.artist,
      this.genre,
      this.releaseDate});
}

Future<Song> songFromFile(File f) async {
  final metadata = await MetadataRetriever.fromFile(f);
  var title = (metadata.trackName == null || metadata.trackName == ""
          ? basenameWithoutExtension(f.path)
          : metadata.trackName) ??
      "unable to load name";
  var artist = (metadata.trackArtistNames) == null
      ? null
      : metadata.trackArtistNames!.join(', ');
  var genre = metadata.genre;
  var releaseDate;
  try {
    releaseDate = metadata.year == null ? null : DateTime(metadata.year!);
  } catch (e) {
    releaseDate = null;
  }
  Duration duration = Duration(milliseconds: metadata.trackDuration ?? 0);
  var albumArt = metadata.albumArt == null
      ? Image.asset('assets/images/placeholder_album_art.png')
      : Image.memory(metadata.albumArt!);
  var lyrics = 'Lyrics not implemented yet :c'; // TODO Implement lyrics
  var source = DeviceFileSource(f.path);
  return Song(
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
