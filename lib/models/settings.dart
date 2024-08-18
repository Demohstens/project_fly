import 'dart:io';

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
    notifyListeners();
  }
}
