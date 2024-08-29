import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_fly/models/song.dart';
import 'package:uuid/uuid.dart';

// ...
class UserData {
  Directory? savePath;
  String userId = '';
  // List<Map<String, dynamic>> songs = [];
  Map<String, List<String>> playlistData = {};
  List<String> likedSongs = [];
  List<Map<String, dynamic>> history = [];

  Map<String, dynamic>? userData;

  UserData() {}

  MediaItem getMediaItemFromSongData(Map<String, dynamic> songData) {
    return MediaItem(
      id: songData['id'],
      title: songData['title'],
      artist: songData['artist'],
      album: songData['album'],
      duration: Duration(
          milliseconds: int.tryParse(songData['duration'] ?? "0") ?? 0),
      extras: <String, dynamic>{
        'path': songData['path'],
      },
    );
  }

  Map<String, dynamic> getSongDataFromMediaItem(MediaItem item) {
    return <String, dynamic>{
      'id': item.id,
      'title': item.title,
      'artist': item.artist,
      'album': item.album,
      'duration': item.duration?.inMilliseconds.toString(),
      'path': item.extras!['path'].toString()
    };
  }
  // }

  // Future<void> saveData() async {
  //   log("Saving data");
  //   final directory = await getApplicationDocumentsDirectory();
  //   final saveFile = File('${directory.path}/flyuserdata.json');

  //   String jsonString = jsonEncode(
  //     <String, dynamic>{
  //       'userId': userId,
  //       'songs': songs,
  //       'playlists': playlistData,
  //       'likedSongs': likedSongs,
  //       'history': history,
  //     },
  //   );
  //   await saveFile.writeAsString(jsonString);
  //   log('Data saved to ${saveFile.path}');
  // }

  // Future<Map<String, String>?> loadData() async {
  //   DateTime _perf1 = DateTime.now();
  //   final directory = await getApplicationDocumentsDirectory();
  //   final file =
  //       File('${directory.path}/flyuserdata.json'); // Use correct file path
  //   if (await file.exists()) {
  //     String jsonString = await file.readAsString();
  //     if (jsonString.isEmpty) {
  //       return null;
  //     }
  //     userData = jsonDecode(jsonString);
  //     _parseDataIntoSepeateData(userData!);
  //   }
  //   DateTime _perf2 = DateTime.now();
  //   log('Data loaded in ${_perf2.difference(_perf1).inMilliseconds}ms');
  //   return null;
  // }

  // void _parseDataIntoSepeateData(Map<String, dynamic> data) {
  //   userId = data['userId'] ?? Uuid().v4();
  //   songs = List<Map<String, dynamic>>.from(data['songs']); // Type casting
  //   playlistData =
  //       Map<String, List<String>>.from(data['playlists']); // Type casting
  //   likedSongs = List<String>.from(data['likedSongs']); // Type casting
  //   history = List<Map<String, dynamic>>.from(data['history']);
  // }
}

void clearData() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/flyuserdata.json');
  await file.delete();
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