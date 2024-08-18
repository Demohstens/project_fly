import 'package:flutter/material.dart';
import 'package:project_fly/components/song_component.dart';
import 'package:project_fly/models/song.dart';

class SongListitem extends StatelessWidget {
  final Song song;
  SongListitem({required this.song});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SongComponent(song: song)));
      },
      title: Text(song.title),
      subtitle: Text(song.artist ?? ""),
      leading: const Icon(Icons.music_note),
      trailing: const Icon(Icons.more_vert),
    );
  }
}
