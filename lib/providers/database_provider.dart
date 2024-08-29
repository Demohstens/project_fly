import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_fly/models/song.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseProvider extends ChangeNotifier {
  DatabaseProvider() {
    _initDatabase();
  }

  late Database _db;
  int _songCount = 0;

  // * Getters * //
  int get songCount => _songCount;

  // * Database Initialization * //

  Future<bool> _initDatabase() async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    _db = await openDatabase(
      path.join(
        await getDatabasesPath(),
        'fly_userdata._db',
      ),
      onCreate: (_db, version) async {
        // Create a table to store songs
        await _db.execute('''
        CREATE TABLE Songs (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          artist TEXT,
          album TEXT,
          genre TEXT,
          year INTEGER,
          duration INTEGER,
          path TEXT NOT NULL
        )
      ''');
        // Create a table to store playlists
        await _db.execute('''
        CREATE TABLE Playlists (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT
        )
      ''');
        // Create a table to store songs in playlists
        await _db.execute('''
        CREATE TABLE PlaylistSongs (
          playlist_id INTEGER NOT NULL,
          song_id INTEGER NOT NULL,
          FOREIGN KEY(playlist_id) REFERENCES Playlists(id) ON DELETE CASCADE,
          FOREIGN KEY(song_id) REFERENCES Songs(id) ON DELETE CASCADE, 

          PRIMARY KEY(playlist_id, song_id)
        )
      ''');
        // Create a table to store history
        await _db.execute('''
        CREATE TABLE History (
          song_id INTEGER NOT NULL,
          timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
          action TEXT, 
          duration INTEGER,
          FOREIGN KEY(song_id) REFERENCES Songs(id) ON DELETE CASCADE 
        )
      ''');
        // Use Action to store how the user interacted with the song

        // Create a table to store liked songs
        await _db.execute('''
          CREATE TABLE LikedSongs (
          song_id INTEGER NOT NULL,
          FOREIGN KEY(song_id) REFERENCES Songs(id) ON DELETE CASCADE,
          PRIMARY KEY(song_id)
      )
    ''');
      },
      version: 1,
    );
    return true;
  }

  // * CRUD Operations * //

  // Create

  /// Insert a song into the database and returns the id of the inserted song
  Future<int> insertSong(RenderedSong song) async {
    await _initDatabase(); // Ensure the database is initialized

    var songID = await _db.insert('Songs', song.toMap());
    getTotalSongCount();
    return songID;
  }

  Future<int> createPlaylist(String title) async {
    return await _db.insert('Playlists', {'title': title});
  }

  Future<void> addSongToPlaylist(int playlistId, int songId) async {
    await _db.insert('PlaylistSongs', {
      'playlist_id': playlistId,
      'song_id': songId,
    });
  }

  void addSongToHistory(int songId, String action, int duration) async {
    await _initDatabase(); // Ensure the database is initialized

    await _db.insert('History', {
      'song_id': songId,
      'action': action,
      'duration': duration,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // Update
  void updateSong(RenderedSong song) async {
    await _db.update(
      'Songs',
      song.toMap(),
      where: 'id = ?',
      whereArgs: [song.id],
    );
  }

  Future<void> updateOrCreateSong(Map<String, dynamic> songData) async {
    if (File(songData["path"]).existsSync() == false) {
      log("Song file does not exist, ${songData['path']}");
      return;
    }

    await _initDatabase(); // Ensure the database is initialized
    log("Updating song in database");

    final affectedRows = await _db.update(
      'Songs',
      songData,
      where: 'id = ?',
      whereArgs: [songData['id']],
    );

    if (affectedRows == 0) {
      log("adding song to database");
      // No existing song found, so insert
      await _db.insert('Songs', songData);
    }
  }

  // Delete
  void deleteSong(int songId) async {
    await _db.delete(
      'Songs',
      where: 'id = ?',
      whereArgs: [songId],
    );
  }

  // Read
  Future<List<Map<String, dynamic>>> getSongsInPlaylist(int playlistId) async {
    return await _db.rawQuery(
      '''
    SELECT s.* 
    FROM Songs s
    JOIN PlaylistSongs ps ON s.id = ps.song_id
    WHERE ps.playlist_id = ?; 
  ''',
      [playlistId],
    );
  }

  Future<List<RenderedSong>> getSongsPaginated(int page,
      // ignore: require_trailing_commas
      {int pageSize = 20}) async {
    await _initDatabase(); // Ensure the database is initialized

    final offset = page * pageSize;
    List listOfSongData = await _db.query(
      'Songs',
      limit: pageSize,
      offset: offset,
    );
    return listOfSongData.map((songData) {
      return RenderedSong.fromSongData(songData);
    }).toList();
  }

  Future<int> getTotalSongCount() async {
    final result = await _db.rawQuery("SELEECT COUNT(*) FROM Songs");
    int songCount = Sqflite.firstIntValue(result) ?? 0;
    _songCount = songCount;
    notifyListeners();
    return songCount;
  }

  Future<String?> getSongPath(int songId) async {
    final result = await _db.query(
      'Songs',
      columns: ['path'],
      where: 'id = ?',
      whereArgs: [songId],
    );
    return result.isNotEmpty ? result.first['path'].toString() : null;
  }

  Future<void> clearDatabase() async {
    await _db.execute('DELETE FROM Songs');
    await _db.execute('DELETE FROM Playlists');
    await _db.execute('DELETE FROM PlaylistSongs');
    await _db.execute('DELETE FROM History');
    await _db.execute(
        'DELETE FROM LikedSongs'); // If you implemented the liked songs table
    log('Database cleared');
  }
}
