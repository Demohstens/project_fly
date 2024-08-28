import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:project_fly/main.dart';
import 'package:project_fly/models/song.dart';

/// DOES NOT WORK
class HistorySubpage extends StatelessWidget {
  const HistorySubpage({super.key});

  Widget build(BuildContext context) {
    // List<MediaItem> queue = context.watch<FlyAudioHandler>().queue.value;

    return ListView(
      children: <Widget>[
        const Text(
          "History",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        Divider(),
        if (userData.history.isNotEmpty)
          for (HistorySongObject hso in userData.history.reversed.map(
            (e) => HistorySongObject(
              song: RenderedSong.fromSongData(e['song']),
              time: DateTime.parse(e['time']),
            ),
          ))
            HistoryListItem(history: hso),
      ],
    );
  }
}

class HistorySongObject {
  final RenderedSong song;
  final DateTime time;
  HistorySongObject({required this.song, required this.time});

  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        audioHandler.playMediaItem(song.toMediaItem());
      },
      title: Text(song.title),
      subtitle: Text(song.artist ?? ""),
      leading: song.albumArt,
      trailing: Text(time.toString()),
    );
  }

  MediaItem toMediaItem() {
    return song.toMediaItem();
  }
}

class HistoryListItem extends StatelessWidget {
  final HistorySongObject history;
  const HistoryListItem({required this.history, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        // audioHandler.playMediaItem(history.toMediaItem());
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Not implemented yet")));
      },
      title: Text(history.song.title),
      subtitle: Text(history.song.artist ?? ""),
      leading: history.song.albumArt,
      trailing: Text(history.time.toString()),
    );
  }
}
