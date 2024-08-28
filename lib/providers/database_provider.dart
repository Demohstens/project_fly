import 'package:flutter/material.dart';
import 'package:project_fly/models/song.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DatabaseProvider extends ChangeNotifier {
  DatabaseProvider() {
    _initDatabase();
  }

  late Database _db;
  int _songCount = 0;

  // * Getters * //
  int get songCount => _songCount;

  // * Database Initialization * //

  void _initDatabase() async {
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
          path TEXT NOT NULL, 
        )
      ''');
        // Create a table to store playlists
        await _db.execute('''
        CREATE TABLE Playlists (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT
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
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          song_id INTEGER NOT NULL,
          timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
          action TEXT, 
          duration INTEGER,
          FOREIGN KEY(song_id) REFERENCES Songs(id) ON DELETE CASCADE 
        )
      ''');
        // Use Action to store how the user interacted with the song
      },
    );
  }

  // * CRUD Operations * //

  // Create

  /// Insert a song into the database and returns the id of the inserted song
  Future<int> insertSong(RenderedSong song) async {
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

  // Update
  void updateSong(RenderedSong song) async {
    await _db.update(
      'Songs',
      song.toMap(),
      where: 'id = ?',
      whereArgs: [song.id],
    );
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

  Future<int> getTotalSongCount() async {
    final result = await _db.rawQuery("SELEECT COUNT(*) FROM Songs");
    int songCount = Sqflite.firstIntValue(result) ?? 0;
    _songCount = songCount;
    notifyListeners();
    return songCount;
  }
}
