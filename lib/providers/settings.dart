import 'dart:developer';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_fly/components/favorite_cards.dart';
import 'package:project_fly/main.dart';
import 'package:project_fly/models/song.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    List<List<MediaItem>> _dirsSongsTemp = [];
    for (Directory dir in _musicDirectories) {
      List<MediaItem> a = await depthSearchFolder(dir);
      _dirsSongsTemp.add(a);
    }

    userData.songs = _dirsSongsTemp.expand((element) => element).toList();
    print(userData.songs);

    userData.saveData();
  }

  Future<List<MediaItem>> depthSearchFolder(
    Directory dir,
  ) async {
    List<MediaItem> outputList = [];
    log("Searching folder: ${dir.path}");
    await for (FileSystemEntity entity
        in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        String ext = entity.path.split('.').last;
        if (ext == 'mp3' || ext == 'm4a' || ext == 'flac' || ext == 'mp4') {
          MediaItem? song = await songFromFile(entity);
          if (song != null) {
            outputList.add(song);
          }
        } else {}
      } else if (entity is Directory) {
        // Optional: Uncomment if you want to recurse into directories as they are found
        // await depthSearchFolder(entity);
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
