import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Settings extends ChangeNotifier {
  bool _isDarkMode = false;
  List<Widget> _favoriteCards = [
    FavoriteCard(),
    FavoriteCard(),
    FavoriteCard(),
  ];
  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  Directory? _musicDirectory;

  List get favoriteCards => _favoriteCards;
  Directory? get musicDirectory => _musicDirectory;

  void setMusicDirectory(Directory? directory) async {
    _musicDirectory = directory ?? await getApplicationDocumentsDirectory();
    print("Music dir set to: $directory");
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
