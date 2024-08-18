import 'package:flutter/material.dart';
import 'package:project_fly/components/song_component.dart';
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

    Song? currentSong =
        context.select<FlyAudioHandler, Song?>((value) => value.currentSong);

    if (currentSong == null) {
      return Container();
    } else {
      double maxDuration = currentSong.duration?.inMilliseconds.toDouble() ?? 0;
      double currentDuration = context
              .watch<FlyAudioHandler>()
              .currentDuration
              ?.inMilliseconds
              .toDouble() ??
          0;

      return Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(141, 127, 174, 217),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0),
        ),
        constraints: BoxConstraints(
          minWidth: 100.w,
          maxWidth: 100.w,
          maxHeight: 10.h,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SongPage(song: currentSong)));
          },
          child: Column(children: [
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 1.0,
                trackShape: RoundedRectSliderTrackShape(),
              ),
              child: Slider(
                min: 0,
                max: maxDuration > 0
                    ? maxDuration
                    : 1, // Prevents max from being 0
                value: currentDuration.clamp(0, maxDuration),
                onChanged: maxDuration > 0
                    ? (v) {
                        context
                            .read<FlyAudioHandler>()
                            .seekTo(Duration(milliseconds: v.toInt()));
                      }
                    : null, // Disables the slider if maxDuration is 0
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ClipRect(
                  child: SizedBox(
                    width: 30.sp,
                    height: 30.sp,
                    child: currentSong.albumArt,
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
