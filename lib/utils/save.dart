import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

// ...
class UserData {
  Directory? savePath;
  String userId = '';
  List<MediaItem> songs = [];
  Map<String, List<String>> playlistData = {};
  List<String> likedSongs = [];
  List<Map<String, dynamic>> history = [];

  Map<String, dynamic>? userData;

  UserData() {
    loadData();
  }

  void addSong(MediaItem song) {
    songs.add(song);
  }

  MediaItem findSongById(String id) {
    return songs.firstWhere((element) => element.id == id);
  }

  // createSongPaths(List<MediaItem> songs) {
  //   for (var song in songs) {
  //     songData[song.id] = song.extras!['path']!;
  //   }
  // }

  Future<void> saveData() async {
    log("Saving data");
    final directory = await getApplicationDocumentsDirectory();
    final saveFile = File('${directory.path}/flyuserdata.json');
    List<Map<String, dynamic>> _songList = songs
        .map((e) => <String, dynamic>{
              'id': e.id,
              'title': e.title,
              'artist': e.artist,
              'album': e.album,
              'duration': e.duration?.inMilliseconds.toString(),
              'path': e.extras!['path'].toString()
            })
        .toList();
    String jsonString = jsonEncode(
      <String, dynamic>{
        'userId': userId,
        'songs': _songList,
        'playlists': playlistData,
        'likedSongs': likedSongs,
        'history': history,
      },
    );
    await saveFile.writeAsString(jsonString);
    log('Data saved to ${saveFile.path}');
  }

  Future<Map<String, String>?> loadData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file =
        File('${directory.path}/flyuserdata.json'); // Use correct file path
    if (await file.exists()) {
      String jsonString = await file.readAsString();
      userData = jsonDecode(jsonString);
      _parseDataIntoSepeateData(userData!);
    }
    return null;
  }

  void _parseDataIntoSepeateData(Map<String, dynamic> data) {
    userId = data['userId'] ?? Uuid().v4();
    var songData = data['songs'];
    for (var song in songData) {
      MediaItem newSong = MediaItem(
        id: song['id'],
        title: song['title'],
        artist: song['artist'],
        album: song['album'],
        duration: Duration(seconds: int.tryParse(song['duration']) ?? 0),
        extras: <String, dynamic>{
          'path': song['path'],
        },
      );
      songs.add(newSong);
    }
    playlistData =
        Map<String, List<String>>.from(data['playlists']); // Type casting
    likedSongs = List<String>.from(data['likedSongs']); // Type casting
    history = List<Map<String, dynamic>>.from(data['history']);
  }
}

/* 
{
  "songs" : [
    {
      "id": "1",
      "title": "Song 1",
      "artist": "Artist 1",
      duration: 123,
      "path": "path/to/song1.mp3"
    }, ],
  "playlists": [
    {
      "name": "Playlist 1",
      "songs": ["id1", "2", "3"]
      "picture": "path/to/picture.jpg", } ],
  "userId": "1234567890",
  "likedSongs": ["id1", "2", "3"],
  hisyory : [{"song" : "id", time: "20230502142240"}, "2", "3"],
  }

  */