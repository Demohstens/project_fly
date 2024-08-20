import 'package:flutter/material.dart';
import 'package:project_fly/main.dart';
import 'package:project_fly/providers/player.dart';
import 'package:provider/provider.dart';

class ProgressSlider extends StatefulWidget {
  const ProgressSlider({Key? key}) : super(key: key);

  _ProgressSliderState createState() => _ProgressSliderState();
}

class _ProgressSliderState extends State<ProgressSlider> {
  bool isSeeking = false;
  double seekValue = 0;
  @override
  Widget build(BuildContext context) {
    var currentSong = context.watch<FlyAudioHandler>().currentSong;

    double maxDuration = currentSong?.duration.inMilliseconds.toDouble() ?? 0;
    double currentDuration = context
            .watch<FlyAudioHandler>()
            .currentDuration
            ?.inMilliseconds
            .toDouble() ??
        0;
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
          value: isSeeking ? seekValue : currentDuration.clamp(0, maxDuration),
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
              context
                  .read<FlyAudioHandler>()
                  .seekTo(Duration(milliseconds: seekValue.toInt()));
            });
          }),
    );
  }
}
