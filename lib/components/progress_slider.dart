import 'package:flutter/material.dart';
import 'package:project_fly/models/player.dart';
import 'package:provider/provider.dart';

class ProgressSlider extends StatelessWidget {
  const ProgressSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentSong = context.watch<FlyAudioHandler>().currentSong;

    double maxDuration = currentSong.duration?.inMilliseconds.toDouble() ?? 0;
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
        value: currentDuration.clamp(0, maxDuration),
        onChanged: maxDuration > 0
            ? (v) {
                context
                    .read<FlyAudioHandler>()
                    .seekTo(Duration(milliseconds: v.toInt()));
              }
            : null, // Disables the slider if maxDuration is 0
      ),
    );
  }
}
