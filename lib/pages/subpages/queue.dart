import 'package:flutter/material.dart';

class QueuePage extends StatelessWidget {
  const QueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    // List<MediaItem> queue = context.watch<FlyAudioHandler>().queue.value;

    return ListView(
      children: const <Widget>[
        Text(
          "Queue",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        Divider(),
        // for (MediaItem song in queue) SongListitem(song: song)
      ],
    );
  }
}
