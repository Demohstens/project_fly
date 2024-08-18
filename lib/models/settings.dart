import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends ChangeNotifier {
  // * SHARED PREFERENCES * //
  late SharedPreferences _settings;
  Settings() {
    SharedPreferences.getInstance().then((value) {
      _settings = value;
      _isDarkMode = _settings.getBool("isDarkMode") ?? false;
      var _musicDirStr = _settings.getString("musicDirectory");
      _musicDirectory = _musicDirStr != null ? Directory(_musicDirStr) : null;
      _favoriteCards = [
        FavoriteCard(),
        FavoriteCard(),
        FavoriteCard(),
      ];
      notifyListeners();
    });
  }

  bool _isDarkMode = false;
  List<Widget> _favoriteCards = [
    FavoriteCard(),
    FavoriteCard(),
    FavoriteCard(),
  ];
  bool get isDarkMode => _isDarkMode;
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

  Directory? _musicDirectory;

  List get favoriteCards => _favoriteCards;
  Directory? get musicDirectory => _musicDirectory;

  void setMusicDirectory(Directory? directory) async {
    _musicDirectory = directory ?? await getApplicationDocumentsDirectory();
    print("Music dir set to: $directory");
    _settings.setString("musicDirectory", _musicDirectory!.path);
    notifyListeners();
  }
}

Future<Directory?> selectMusicFolder() async {
  Directory? dir;
  if (Permission.manageExternalStorage.isGranted == false) {
    Permission.manageExternalStorage.request();
  }
  String? dirPath = await FilePicker.platform
      .getDirectoryPath(dialogTitle: "Select Music folder");

  dirPath != null ? dir = Directory(dirPath).absolute : dir = null;
  return dir;
}

class FavoriteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(
        child: Card(
            child: Container(
                color: Colors.redAccent,
                constraints: BoxConstraints(minHeight: 50),
                child: Row(
                    children: [Icon(Icons.favorite), Text("Favorite Song")]))));
  }
}
