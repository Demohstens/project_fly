import 'dart:developer';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:project_fly/main.dart';
import 'package:project_fly/models/song.dart';

void updateSongList(Directory? dir) {
  print("Updating song list");
  List<MediaItem> _songsTemp = [];
  if (dir == null) {
    log("Cant update song list, dir is null");
    return;
  }
  depthSearchFolder(dir, outputList: _songsTemp);
  userData.songs = _songsTemp;
  userData.saveData();
}

Future<void> depthSearchFolder(Directory dir,
    {List<MediaItem>? outputList}) async {
  log("Searching folder: ${dir.path}");
  await for (FileSystemEntity entity
      in dir.list(recursive: true, followLinks: false)) {
    if (entity is File) {
      String ext = entity.path.split('.').last;
      if (ext == 'mp3' || ext == 'm4a' || ext == 'flac' || ext == 'mp4') {
        MediaItem? song = await songFromFile(entity);
        if (song != null) {
          userData.addSong(song);

          outputList?.add(song);
        }
      } else {}
    } else if (entity is Directory) {
      // Optional: Uncomment if you want to recurse into directories as they are found
      // await depthSearchFolder(entity);
    }
  }
}
