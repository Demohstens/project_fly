import 'dart:developer';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audiotags/audiotags.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_fly/components/favorite_cards.dart';
import 'package:project_fly/main.dart';
import 'package:project_fly/models/song.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';

class Settings extends ChangeNotifier {
  // * SHARED PREFERENCES * //
  late SharedPreferences _settings;

  Settings() {
    SharedPreferences.getInstance().then((value) {
      _settings = value;
      _isDarkMode = _settings.getBool("isDarkMode") ?? false;
      _musicDirectories = _settings.getStringList("musicDirectories")?.map((e) {
            return Directory(e);
          }).toList() ??
          [];

      // _favoriteCard
      notifyListeners();
    });
  }

  // * SETTINGS * //
  List<Directory> _musicDirectories = [];
  bool _isDarkMode = false;
  final List<Widget> _favoriteCards = [
    const FavoriteCard(typeOfCard: FavoriteCards.currentSong),
    const FavoriteCard(typeOfCard: FavoriteCards.queue),
    const FavoriteCard(typeOfCard: FavoriteCards.playlists),
    const FavoriteCard(typeOfCard: FavoriteCards.settings),
  ];

  // * GETTERS AND SETTERS * //
  bool get isDarkMode => _isDarkMode;

  List get favoriteCards => _favoriteCards;
  // Directory? get musicDirectory => _musicDirectory;
  List<Directory> get musicDirectories => _musicDirectories;

  set isDarkMode(bool value) {
    _isDarkMode = value;
    _settings.setBool("isDarkMode", _isDarkMode);
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    _settings.setBool("isDarkMode", _isDarkMode);
    notifyListeners();
  }

  void removeDirectory(Directory dir) {
    _musicDirectories.remove(dir);
    _settings.setStringList(
        "musicDirectories", _musicDirectories.map((e) => e.path).toList());
    notifyListeners();
  }

  void addMusicDirectory(Directory? directory) async {
    Directory _musicDirectory =
        directory ?? await getApplicationDocumentsDirectory();
    _musicDirectories.add(_musicDirectory);
    _settings.setStringList(
        "musicDirectories", _musicDirectories.map((e) => e.path).toList());
    notifyListeners();
  }

  void updateSongList() async {
    List<Map<String, dynamic>> _songList = [];
    //  = songs
    //     .map((e) => <String, dynamic>{
    //           'id': e.id,
    //           'title': e.title,
    //           'artist': e.artist,
    //           'album': e.album,
    //           'duration': e.duration?.inMilliseconds.toString(),
    //           'path': e.extras!['path'].toString()
    //         })
    //     .toList();
    List<Map<String, dynamic>> _dirSongSubList = [];
    for (Directory dir in _musicDirectories) {
      List<Map<String, dynamic>> a = await depthSearchFolder(dir);
      _songList.addAll(a);
    }

    userData.songs = _songList;

    userData.saveData();
  }

  Future<List<Map<String, dynamic>>> depthSearchFolder(
    Directory dir,
  ) async {
    List<Map<String, dynamic>> outputList = [];
    log("Searching folder: ${dir.path}");
    await for (FileSystemEntity entity
        in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        String ext = entity.path.split('.').last;
        if (ext == 'mp3' || ext == 'm4a' || ext == 'flac' || ext == 'mp4') {
          if (!userData.songExistsPath(entity.path)) {
            try {
              Tag? metadata = await AudioTags.read(entity.path);
              outputList.add({
                'id': const Uuid().v4(),
                'title': metadata?.title ??
                    basenameWithoutExtension(entity.path)
                        .split("-")
                        .first
                        .trim(),
                'artist': metadata?.trackArtist ??
                    basenameWithoutExtension(entity.path)
                        .split("-")
                        .last
                        .trim(),
                'album': metadata?.album,
                'duration': metadata?.duration?.toString(),
                'path': entity.path,
              });
            } catch (e) {
              log("CANNOT LOAD METADATA $e");
              continue;
            }
          } else {
            log("file Already on record ${entity.path}");
          }
        } else if (entity is Directory) {
          // Optional: Uncomment if you want to recurse into directories as they are found
          // await depthSearchFolder(entity);
        }
      }
    }
    return outputList;
  }

  void addDirectory(Directory dir) {
    _musicDirectories.add(dir);
    _settings.setStringList(
        "musicDirectories", _musicDirectories.map((e) => e.path).toList());
    notifyListeners();
  }

  bool directoryInListOfDirectories(Directory dir) {
    for (Directory d in _musicDirectories) {
      if (d.path == dir.path) {
        return true;
      }
    }
    return false;
  }
}

Future<Directory?> selectMusicFolder() async {
  Directory? dir;
  Permission.manageExternalStorage.request();

  String? dirPath = await FilePicker.platform
      .getDirectoryPath(dialogTitle: "Select Music folder");

  dirPath != null ? dir = Directory(dirPath).absolute : dir = null;
  return dir;
}
