import 'package:flutter/material.dart';
import 'package:project_fly/components/song_component.dart';
import 'package:project_fly/models/player.dart';
import 'package:project_fly/models/song.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

class CurrentlyPlayingIsland extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Song? currentSong =
        context.select<FlyAudioHandler, Song?>((value) => value.currentSong);
    // TODO: implement build
    if (currentSong == null) {
      return Container();
    } else {
      return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(141, 127, 174, 217),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: BoxConstraints(
            maxWidth: 100.w,
            maxHeight: 10.h,
          ),
          child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SongComponent(song: currentSong)));
              },
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ClipRect(
                      child: SizedBox(
                        width: 10.h,
                        height: 10.h,
                        child: currentSong.albumArt,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(currentSong.title),
                      Text(currentSong.artist ?? ""),
                    ],
                  ),
                  IconButton(
                    icon: context.watch<FlyAudioHandler>().isPlaying
                        ? const Icon(Icons.pause)
                        : const Icon(Icons.play_arrow),
                    onPressed: () {
                      context.read<FlyAudioHandler>().togglePlaying();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    onPressed: () {},
                  ),
                ],
              )));
    }
  }
}
