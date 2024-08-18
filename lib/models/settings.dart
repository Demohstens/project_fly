import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Settings extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  Directory? _musicDirectory;

  Directory? get musicDirectory => _musicDirectory;

  void setMusicDirectory(Directory? directory) async {
    _musicDirectory = directory ?? await getApplicationDocumentsDirectory();
    print("Music dir set to: $directory");
    notifyListeners();
  }
}

Future<Directory?> selectMusicFolder() async {
  Directory? dir;
  String? dirPath =
      await FilePickerIO().getDirectoryPath(dialogTitle: "Select Music folder");
  dirPath != null ? dir = Directory(dirPath).absolute : dir = null;
  return dir;
}
