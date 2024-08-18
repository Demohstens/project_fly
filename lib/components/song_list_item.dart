import 'package:flutter/material.dart';
import 'package:project_fly/models/player.dart';
import 'package:project_fly/models/song.dart';
import 'package:provider/provider.dart';

class SongListitem extends StatelessWidget {
  final Song song;
  SongListitem({required this.song});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.read<FlyAudioHandler>().playSong(song);
      },
      title: Text(song.title),
      subtitle: Text(song.artist ?? ""),
      leading: song.albumArt,
      trailing: const Icon(Icons.more_vert),
    );
  }
}
