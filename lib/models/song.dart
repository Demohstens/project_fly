import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audiotags/audiotags.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

Future<MediaItem?> songFromFile(File f) async {
  Tag? metadata;
  try {
    metadata = await AudioTags.read(f.path);
  } catch (e) {
    print("CANNOT LOAD METADATA $e");
    return null;
  }

  if (metadata == null) {
    return null;
  }

  var title = (metadata.title == null || metadata.title == ""
          ? path.basenameWithoutExtension(f.path)
          : metadata.title) ??
      "unable to load name";
  var artist = metadata.trackArtist;
  var genre = metadata.genre;
  DateTime? releaseDate;
  try {
    releaseDate = metadata.year == null ? null : DateTime(metadata.year!);
  } catch (e) {
    releaseDate = null;
  }
  var album = metadata.album;
  Duration duration =
      Duration(milliseconds: metadata.duration! * 1000); // TODO test
  // print(duration);
  // var albumArt = metadata.pictures.isEmpty
  //     ? Image.asset('assets/images/placeholder_album_art.png')
  //     : Image.memory(metadata.pictures.first.bytes);
  // var lyrics = 'Lyrics not implemented yet :c'; // TODO Implement lyrics
  // var source = DeviceFileSource(f.path);
  var releaseDateYear = releaseDate == null ? null : releaseDate.year;
  return MediaItem(
    title: title,
    artist: artist,
    genre: genre,
    duration: duration,
    album: album,
    id: const Uuid().v4(),
    extras: {'path': f.path, "year": releaseDateYear},
    // albumArt: albumArt,
    // lyrics: lyrics,
    // source: source,
  );
}

class RenderedSong {
  final Image? albumArt;
  final String? lyrics;
  final AudioSource source;

  final String id = const Uuid().v4();
  final String path;
  final String title;
  final String? artist;
  final String? album = null;
  final String? genre;
  final int? releaseDateYear;
  final Duration duration;
  RenderedSong({
    required this.path,
    required this.title,
    required this.duration,
    required this.source,
    this.artist,
    this.genre,
    this.releaseDateYear,
    this.albumArt,
    this.lyrics,
  });

  factory RenderedSong.fromMediaItem(MediaItem item) {
    String path = item.extras!['path'] as String;
    return RenderedSong(
      path: path,
      title: item.title,
      duration: item.duration!, // TODO write proper handling of no duration
      source: AudioSource.file(path),
      artist: item.artist,
      genre: item.genre,
      releaseDateYear: item.extras!['year'],
      albumArt: null,
      lyrics: null,
    );
  }

  MediaItem toMediaItem() {
    return MediaItem(
      id: id,
      album: album,
      title: title,
      artist: artist,
      genre: genre,
      duration: duration,
    );
  }
}
