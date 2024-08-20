// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// void addUserToDatabase(FirebaseFirestore db, User user) {
// // Add a new document with a generated ID

//   db.collection("users").add(user.toMap()).then(
//       (DocumentReference doc) => SharedPreferences.getInstance().then((value) {
//             value.setString("user_id", doc.id);
//           }));
// }

// Future<User> getUserByID(FirebaseFirestore db, String id) async {
//   Completer<User> completer = Completer<User>();

//   db.collection("users").doc(id).get().then((value) {
//     User user = User(
//       id: id,
//       username: value.get("username"),
//       playlists: List<Map<String, dynamic>>.from(value.get("playlists")),
//       favoriteSongs: List<String>.from(value.get("favoriteSongs")),
//       history: List<String>.from(value.get("history")),
//       songs: List<Map<String, dynamic>>.from(value.get("songs")),
//     );
//     completer.complete(user);
//   }).catchError((error) {
//     completer.completeError(error);
//   });

//   return completer.future;
// }

// Future<String> createDatabaseUser(FirebaseFirestore db) {
//   return db.collection("users").add(UserTemplate).then((DocumentReference doc) {
//     return doc.id;
//   });
// }

// class User {
//   String id;
//   String username;
//   List<Map<String, dynamic>> playlists;
//   List<String> favoriteSongs;
//   List<String> history;
//   List<Map<String, dynamic>> songs;

//   User(
//       {required this.id,
//       required this.username,
//       required this.playlists,
//       required this.favoriteSongs,
//       required this.history,
//       required this.songs});

//   Map<String, dynamic> toMap() {
//     return {
//       'username': username,
//       'playlists': playlists,
//       'favoriteSongs': favoriteSongs,
//       'history': history,
//       'songs': songs,
//     };
//   }
// }

// const UserTemplate = {
//   'username': "Guest",
//   'playlists': [],
//   'favoriteSongs': [],
//   'history': [],
//   'songs': [],
// };
