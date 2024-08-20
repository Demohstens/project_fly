import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:project_fly/providers/player.dart';
import 'package:project_fly/models/song.dart';
import 'package:provider/provider.dart';

class SongListitem extends StatefulWidget {
  final MediaItem song;
  SongListitem({required this.song});

  @override
  _SongListitemState createState() => _SongListitemState();
}

class _SongListitemState extends State<SongListitem> {
  late RenderedSong renderedSong = RenderedSong.fromMediaItem(widget.song);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.read<FlyAudioHandler>().playMediaItem(widget.song);
      },
      title: Text(renderedSong.title),
      subtitle: Text(renderedSong.artist ?? ""),
      leading: renderedSong.albumArt,
      trailing: const Icon(Icons.more_vert),
    );
  }
}
