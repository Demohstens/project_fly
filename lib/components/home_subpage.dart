import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_fly/components/song_list_item.dart';
import 'package:project_fly/models/player.dart';
import 'package:project_fly/models/song.dart';
import 'package:project_fly/models/songs.dart';
import 'package:provider/provider.dart';

class HomeSubPage extends StatelessWidget {
  const HomeSubPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ListOfSongs();
  }
}

class ListOfSongs extends StatelessWidget {
  final List<Song>? songs;
  const ListOfSongs({this.songs, Key? super.key});

  @override
  Widget build(BuildContext context) {
    List<Song> songs = context.watch<Songs>().songs;
    return Stack(children: [
      ListView.builder(
        itemCount: songs.length == 0 ? 1 : songs.length,
        itemBuilder: (context, index) {
          if (songs.isEmpty) {
            return const Center(
              child: Text("No songs found"),
            );
          } else {
            Song song = songs[index];
            return SongListitem(song: song);
          }
        },
      ),
      FloatingActionButton(onPressed: () {
        context.read<Songs>().addSong(SampleSong());
        songFromFile(File(
                "C:\\Users\\demoh\\Documents\\Code\\Dart\\project_fly\\assets\\posivite_thinking.wav"))
            .then((Song song) {
          context.read<Songs>().addSong(song);
        });
      }),
    ]);
  }
}
