import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:project_fly/components/song_list_item.dart';
import 'package:project_fly/providers/player.dart';
import 'package:provider/provider.dart';

class QueuePage extends StatelessWidget {
  const QueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (MediaItem song in context.watch<FlyAudioHandler>().queue.value)
          SongListitem(song: song)
      ],
    );
  }
}
