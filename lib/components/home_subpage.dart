import 'package:flutter/material.dart';
import 'package:project_fly/models/song.dart';

class ListOfSongs extends StatelessWidget {
  final List<Song> songs;
  const ListOfSongs({required this.songs, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Song $index'),
          subtitle: Text('Artist $index'),
          leading: const Icon(Icons.music_note),
          trailing: const Icon(Icons.more_vert),
        );
      },
    );
  }
}
