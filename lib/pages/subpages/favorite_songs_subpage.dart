import 'package:flutter/material.dart';
import 'package:project_fly/main.dart';
import 'package:project_fly/models/song.dart';

/// DOES NOT WORK
class FavoriteSongsSubpage extends StatelessWidget {
  const FavoriteSongsSubpage({super.key});

  @override
  Widget build(BuildContext context) {
    // List<MediaItem> queue = context.watch<FlyAudioHandler>().queue.value;

    return Placeholder(); // TODO
    // ListView(
    //   children: <Widget>[
    //     const Text(
    //       "Favorite Songs",
    //       textAlign: TextAlign.center,
    //       style: TextStyle(
    //         fontSize: 25,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //     Divider(),
    //     if (userData.likedSongs.isNotEmpty)
    //       for (FavoriteSongListitem? listTile in userData.likedSongs.map((e) {
    //         var songData = userData.findSongById(e);
    //         return songData == null
    //             ? null
    //             : FavoriteSongListitem(
    //                 song: RenderedSong.fromSongData(songData));
    //       }))
    //         listTile ?? Placeholder(),
    //   ],
    // );
  }
}

// class FavoriteSongListitem extends StatelessWidget {
//   final RenderedSong song;
//   const FavoriteSongListitem({required this.song, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: () => audioHandler.playRenderedSong(song),
//       leading: IconButton(
//           onPressed: () {
//             userData.toggleLikeId(song.id);
//           },
//           icon: Icon(Icons.favorite)),
//       title: Text(song.title),
//     );
//   }
// }
