import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:project_fly/main.dart';
import 'package:project_fly/models/song.dart';

class SongListitem extends StatefulWidget {
  final RenderedSong song;
  const SongListitem({super.key, required this.song});

  @override
  _SongListitemState createState() => _SongListitemState();
}

class _SongListitemState extends State<SongListitem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        audioHandler.playRenderedSong(widget.song);
      },
      title: Text(widget.song.title),
      subtitle: Text(widget.song.artist ?? ""),
      leading: widget.song.albumArt,
      trailing: const Icon(Icons.more_vert),
    );
  }
}
