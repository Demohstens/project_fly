import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audiotags/audiotags.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class Song {
  // final Source source;
  final String id = const Uuid().v4();
  final String path;
  final String title;
  final String? artist;
  final String? album = null;
  final String? genre;
  final DateTime? releaseDate;
  final Duration duration;
  // final Image? albumArt;
  // final String? lyrics;
  @Deprecated("Use RenderedSong instead")
  Song(
      {required this.title,
      // required this.source,
      required this.duration,
      // this.albumArt,
      required this.path,
      // this.lyrics,
      album,
      this.artist,
      this.genre,
      this.releaseDate});
  MediaItem toMediaItem() {
    return MediaItem(
        id: id,
        album: album,
        title: title,
        artist: artist,
        genre: genre,
        duration: duration,
        playable: true,
        extras: {'path': path});
  }

  Future<RenderedSong> render() async {
    var tag = await AudioTags.read(path);
    if (tag == null) {
      return RenderedSong(
          song: this,
          albumArt: Image.asset('assets/images/placeholder_album_art.png'),
          lyrics: 'Lyrics not implemented yet :c',
          source: DeviceFileSource(path));
    } else {
      return RenderedSong(
          song: this,
          albumArt: tag.pictures.isEmpty
              ? Image.asset('assets/images/placeholder_album_art.png')
              : Image.memory(tag.pictures.first.bytes),
          lyrics: 'Lyrics not implemented yet :c', // TODO Implement lyrics
          source: DeviceFileSource(path));
    }
  }
}

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

class RenderedSong extends Song {
  final Image? albumArt;
  final String? lyrics;
  final Source source;
  RenderedSong(
      {required Song song, this.albumArt, this.lyrics, required this.source})
      : super(
          path: song.path,
          title: song.title,
          artist: song.artist,
          album: song.album,
          genre: song.genre,
          releaseDate: song.releaseDate,
          duration: song.duration,
        );

  factory RenderedSong.fromMediaItem(MediaItem item) {
    String path = item.extras!['path'] as String;
    return RenderedSong(
        source: DeviceFileSource(path),
        song: Song(
            path: path,
            title: item.title,
            artist: item.artist,
            album: item.album,
            genre: item.genre,
            duration: item.duration!));
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
