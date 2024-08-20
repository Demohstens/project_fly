import 'package:flutter/material.dart';
import 'package:project_fly/components/progress_slider.dart';
import 'package:project_fly/models/player.dart';
import 'package:project_fly/models/song.dart';
import 'package:project_fly/pages/song_page.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

class CurrentlyPlayingIsland extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Icon playingIcon =
        context.select<FlyAudioHandler, bool>((value) => value.isPlaying)
            ? Icon(Icons.pause)
            : Icon(Icons.play_arrow);

    RenderedSong? currentSong = context
        .select<FlyAudioHandler, RenderedSong?>((value) => value.currentSong);

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
          minWidth: 100.w,
          maxWidth: 100.w,
          maxHeight: 15.h,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SongPage(song: currentSong)));
          },
          child: Column(children: [
            ProgressSlider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ClipRect(
                    child: SizedBox(
                      width: 10.w,
                      height: 10.h,
                      child: currentSong.albumArt,
                    ),
                  ),
                ),
              ),
              Spacer(),
              Expanded(
                flex: 4,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 50.w,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Text(
                        currentSong.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (currentSong.artist != null)
                        Text(
                          currentSong.artist!,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Row(
                children: [
                  IconButton(
                    icon: playingIcon,
                    onPressed: () {
                      context.read<FlyAudioHandler>().togglePlaying();
                    },
                  ),
                  IconButton(
                      icon: const Icon(Icons.skip_next),
                      onPressed: () {
                        context.read<FlyAudioHandler>().skipToNext();
                      }),
                ],
              ),
            ]),
          ]),
        ),
      );
    }
  }
}
