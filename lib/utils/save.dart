import 'dart:convert';
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:path_provider/path_provider.dart';

// ...
class JSONSaveData {
  Map<String, dynamic> songData = {};
  JSONSaveData(this.songData);

  createSongPaths(List<MediaItem> songs) {
    for (var song in songs) {
      songData[song.id] = song.extras!['path']!;
    }
  }

  Future<void> saveData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/song_paths.json');
    String jsonString = jsonEncode(songData);
    await file.writeAsString(jsonString);
  }

  Future<Map<String, String>?> loadData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/song_paths.json');
    if (await file.exists()) {
      String jsonString = await file.readAsString();
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      songData = jsonMap.map((key, value) => MapEntry(key, value));
    }
    return null;
  }
}
