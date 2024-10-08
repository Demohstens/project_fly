import 'dart:developer';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audiotags/audiotags.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as path;
import 'package:project_fly/providers/database_provider.dart';
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
  var releaseDateYear = releaseDate?.year;
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
  late Image? albumArt;
  final String? lyrics;
  final AudioSource source;

  final int id;
  final String path;
  final String title;
  final String? artist;
  final String? album = null;
  final String? genre;
  final int? releaseDateYear;
  final Duration duration;
  RenderedSong({
    required this.id,
    required this.path,
    required this.title,
    required this.duration,
    required this.source,
    this.artist,
    this.genre,
    this.releaseDateYear,
    this.albumArt,
    this.lyrics,
  }) {
    if (File(path).existsSync()) {
      Tag? tag;
      AudioTags.read(path).then((e) => tag = e);
      if (tag != null) {
        if (tag!.pictures.isNotEmpty) {
          albumArt = Image.memory(tag!.pictures.first.bytes);
        } else {
          albumArt = Image.asset("assets/images/placeholder_album_art.png");
        }
      } else {
        albumArt = Image.asset("assets/images/placeholder_album_art.png");
      }
    } else {
      log("File does not exist at path $path. Cannot load album art");
      albumArt = Image.asset("assets/images/placeholder_album_art.png");
    }
  }
  factory RenderedSong.fromSongData(Map<String, dynamic> songData) {
    return RenderedSong(
      id: songData['id'],
      path: songData['path'],
      title: songData['title'] as String,
      duration: Duration(milliseconds: (songData['duration']) ?? 0),
      source: AudioSource.file(songData['path'] as String),
      artist: songData['artist'] as String?,
      genre: songData['genre'] as String?,
      releaseDateYear: songData['year'] as int?,
      lyrics: songData['lyrics'] as String?,
    );
  }

  // factory RenderedSong.fromMediaItem(MediaItem item, DatabaseProvider db) {
  //   db.getSongPath(int.parse(item.id)).then(
  //     (itemPath) {
  //       log(itemPath.toString());
  //       if (itemPath == null) {
  //         return RenderedSong.empty();
  //       }
  //       return RenderedSong(
  //         id: int.parse(item.id),
  //         path: itemPath,
  //         title: item.title,
  //         duration: item.duration!, // TODO write proper handling of no duration
  //         source: AudioSource.file(itemPath),
  //         artist: item.artist,
  //         genre: item.genre,
  //         releaseDateYear: item.extras!['year'],
  //         lyrics: null,
  //       );
  //     },
  //   );
  //   log("Failed to get song path for song with id ${item.id} line 134 song.dart");
  // }

  // factory RenderedSong.empty() {
  //   return RenderedSong(
  //     id: 0,
  //     path: '',
  //     title: '',
  //     duration: Duration.zero,
  //     source: AudioSource.uri(Uri()),
  //   );
  // }

  MediaItem toMediaItem() {
    return MediaItem(
      id: id.toString(),
      album: album,
      title: title,
      artist: artist,
      genre: genre,
      duration: duration,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'artist': artist,
      'album': album,
      'genre': genre,
      'year': releaseDateYear,
      'duration': duration.inMilliseconds,
      'path': path,
    };
  }
}
