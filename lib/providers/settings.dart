import 'dart:developer' as dev;
import 'dart:io';

import 'package:audiotags/audiotags.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_fly/components/favorite_cards.dart';
import 'package:project_fly/main.dart';
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
    const FavoriteCard(typeOfCard: FavoriteCards.history),
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
    DateTime _perf1 = DateTime.now();
    List<Map<String, dynamic>> _songList = [];
    for (Directory dir in _musicDirectories) {
      List<Map<String, dynamic>> a = await depthSearchFolder(dir);
      _songList.addAll(a);
    }

    userData.songs = _songList;

    userData.saveData();
    DateTime _perf2 = DateTime.now();
    dev.log('Data updated in ${_perf2.difference(_perf1).inMilliseconds}ms');
  }

  Future<List<Map<String, dynamic>>> depthSearchFolder(
    Directory dir,
  ) async {
    List<Map<String, dynamic>> outputList = [];
    dev.log("Searching folder: ${dir.path}");
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
                'title': metadata?.title ?? parseFileNameIntiTitle(entity.path),
                'artist': metadata?.trackArtist ??
                    parseFileNameIntoArtist(entity.path),
                'album': metadata?.album,
                'duration': (metadata?.duration != null
                        ? metadata!.duration! * 1000
                        : 0)
                    .toString(),
                'path': entity.path,
              });
            } catch (e) {
              dev.log("CANNOT LOAD METADATA $e");
              continue;
            }
          }
          // File already exists in the song list
          else {
            Map<String, dynamic> songData =
                userData.getSongDataFromPath(entity.path);
            // Ensure that the file still exists AND that the file is the same
            File f = File(songData['path']);
            Map<String, dynamic> newSongData = songData;
            if (f.existsSync()) {
              try {
                Tag? metadata = await AudioTags.read(entity.path);
                newSongData = {
                  'id': songData['id'],
                  'title': metadata?.title ?? songData['title'],
                  'artist': metadata?.trackArtist ?? songData['artist'],
                  'album': metadata?.album ?? songData['album'],
                  'duration': (metadata?.duration != null
                          ? metadata!.duration! * 1000
                          : songData['duration'])
                      .toString(),
                  'path': entity.path,
                };
              } catch (e) {
                dev.log("CANNOT LOAD METADATA ", error: e);
                continue;
              }

              outputList.add(newSongData);
            }
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

  void clearData() {
    _settings.clear();
    _musicDirectories = [];
    userData.clearData();
    notifyListeners();
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

String parseFileNameIntiTitle(String path) {
  RegExp regExp = RegExp(r"(?: - | by )");
  String fileName = basenameWithoutExtension(path);
  return fileName.split(regExp).first;
}

String parseFileNameIntoArtist(String path) {
  RegExp regExp = RegExp(r"(?: - | by )");
  String fileName = basenameWithoutExtension(path);
  List<String> results = fileName.split(regExp);
  return results.length > 1 ? results[1] : "";
}
