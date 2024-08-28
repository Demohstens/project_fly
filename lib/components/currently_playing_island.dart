import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:project_fly/components/progress_slider.dart';
import 'package:project_fly/main.dart';
import 'package:project_fly/models/song.dart';

import 'package:project_fly/pages/song_page.dart';
import 'package:sizer/sizer.dart';

class CurrentlyPlayingIsland extends StatefulWidget {
  const CurrentlyPlayingIsland({super.key});

  // Icon playingIcon = context.select<FlyAudioHandler, bool>(
  //         (value) => value.playbackState.value.playing)
  //     ? const Icon(Icons.pause)
  //     : const Icon(Icons.play_arrow);
  // LoopMode loopMode =
  //     context.select<FlyAudioHandler, LoopMode>((value) => value.loopMode);
  // Icon? repeadModeIcon = loopMode == LoopMode.all
  //     ? const Icon(Icons.repeat, color: Colors.blue)
  //     : loopMode == LoopMode.one
  //         ? const Icon(Icons.repeat_one, color: Colors.blue)
  //         : const Icon(Icons.repeat);

  @override
  State<StatefulWidget> createState() => _CurrentlyPlayingIslandState();
}

class _CurrentlyPlayingIslandState extends State<CurrentlyPlayingIsland> {
  Icon playingIcon = const Icon(Icons.play_arrow);
  Icon repeadModeIcon = const Icon(Icons.repeat);
  RenderedSong? currentSong;

  late StreamSubscription _mediaItemSubscription;
  late StreamSubscription _playbackStateSubscription;

  setLoopModeIcon(LoopMode lm) {
    setState(() {
      repeadModeIcon = lm == LoopMode.all
          ? const Icon(Icons.repeat, color: Colors.blue)
          : lm == LoopMode.one
              ? const Icon(Icons.repeat_one, color: Colors.blue)
              : const Icon(Icons.repeat);
    });
  }

  @override
  void initState() {
    _mediaItemSubscription = audioHandler.currentSong.listen((song) {
      setState(() {
        currentSong = song;
      });
    });

    _playbackStateSubscription = audioHandler.playbackState.listen((event) {
      setState(() {
        playingIcon = event.playing
            ? const Icon(Icons.pause)
            : const Icon(Icons.play_arrow);
        repeadModeIcon = event.repeatMode == AudioServiceRepeatMode.all
            ? const Icon(Icons.repeat, color: Colors.blue)
            : event.repeatMode == AudioServiceRepeatMode.one
                ? const Icon(Icons.repeat_one, color: Colors.blue)
                : const Icon(Icons.repeat);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _playbackStateSubscription.cancel();
    _mediaItemSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              MaterialPageRoute(builder: (context) => SongPage()),
            );
          },
          child: Column(children: [
            const ProgressSlider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ClipRect(
                    child: SizedBox(
                      width: 10.w,
                      height: 10.h,
                      child: currentSong!.albumArt,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 4,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 50.w,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Text(
                        currentSong!.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (currentSong!.artist != null)
                        Text(
                          currentSong!.artist!,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  IconButton(
                    icon: repeadModeIcon,
                    onPressed: () {
                      setLoopModeIcon(audioHandler.cycleRepeatMode()); // TODO
                    },
                  ),
                  IconButton(
                    icon: playingIcon,
                    onPressed: () {
                      audioHandler.togglePlaying();
                    },
                  ),
                  IconButton(
                      icon: const Icon(Icons.skip_next),
                      onPressed: () {
                        audioHandler.skipToNext();
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
