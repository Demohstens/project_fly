import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_fly/main.dart';
import 'package:project_fly/models/song.dart';

class ProgressSlider extends StatefulWidget {
  const ProgressSlider({Key? key}) : super(key: key);

  _ProgressSliderState createState() => _ProgressSliderState();
}

class _ProgressSliderState extends State<ProgressSlider> {
  bool isSeeking = false;
  double seekValue = 0;
  RenderedSong? currentSong = audioHandler.currentSong.value;
  double maxDuration = 0;
  double? currentDuration;

  StreamSubscription? _positionSubscription;
  StreamSubscription? _currentSongSubscription;

  @override
  void dispose() {
    _currentSongSubscription?.cancel();
    _positionSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _currentSongSubscription = audioHandler.currentSong.listen((song) {
      setState(() {
        if (song != null) {
          currentSong = song;
          maxDuration = song.duration.inMilliseconds.toDouble() ?? 0;
        }
      });
    });
    _positionSubscription = audioHandler.addPositionListener((position) {
      setState(() {
        currentDuration =
            position.inMilliseconds.clamp(0, maxDuration.toInt()).toDouble();
        ;
      });
    });
    super.initState();
    maxDuration = currentSong != null
        ? currentSong!.duration.inMilliseconds.toDouble()
        : 0;
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        thumbShape:
            RoundSliderThumbShape(enabledThumbRadius: 6.0), // Small thumb
        overlayShape: SliderComponentShape.noOverlay, // No overlay
        trackHeight: 3.0, // Thin track
        trackShape: RoundedRectSliderTrackShape(), // Rounded track
      ),
      child: Slider(
          min: 0,
          max: maxDuration > 0 ? maxDuration : 1, // Prevents max from being 0
          value: isSeeking ? seekValue : currentDuration ?? 0,
          onChangeStart: (value) {
            setState(() {
              isSeeking = true;
            });
          },
          onChanged: maxDuration > 0
              ? (v) {
                  if (isSeeking) {
                    setState(() {
                      seekValue = v;
                    });
                  }
                }
              : null, // Disables the slider if maxDuration is 0
          onChangeEnd: (value) {
            setState(() {
              isSeeking = false;
              audioHandler.seek(Duration(milliseconds: value.toInt()));
            });
          }),
    );
  }
}
