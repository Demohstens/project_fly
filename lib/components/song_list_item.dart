import 'package:flutter/material.dart';
import 'package:project_fly/models/player.dart';
import 'package:project_fly/models/song.dart';
import 'package:provider/provider.dart';

class SongListitem extends StatefulWidget {
  final Song song;
  SongListitem({required this.song});

  @override
  _SongListitemState createState() => _SongListitemState();
}

class _SongListitemState extends State<SongListitem> {
  late Future<RenderedSong> _renderedSongFuture;

  @override
  void initState() {
    super.initState();
    _renderedSongFuture = widget.song.render();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RenderedSong>(
      future: _renderedSongFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading indicator while waiting
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Handle any errors
        } else if (!snapshot.hasData) {
          return const Text(
              'No data available'); // Handle the case where no data is returned
        } else {
          final RenderedSong renderedSong = snapshot.data!;
          return ListTile(
            onTap: () {
              context.read<FlyAudioHandler>().playSong(widget.song);
            },
            title: Text(renderedSong.title),
            subtitle: Text(renderedSong.artist ?? ""),
            leading: renderedSong.albumArt,
            trailing: const Icon(Icons.more_vert),
          );
        }
      },
    );
  }
}
