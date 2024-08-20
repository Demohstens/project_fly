import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:project_fly/components/song_list_item.dart';
import 'package:project_fly/providers/player.dart';
import 'package:provider/provider.dart';

class QueuePage extends StatelessWidget {
  const QueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<MediaItem> queue = context.watch<FlyAudioHandler>().queue.value;

    return ListView(
      children: <Widget>[
        Text(
          "Queue",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        Divider(),
        for (MediaItem song in queue) SongListitem(song: song)
      ],
    );
  }
}
