import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:project_fly/main.dart';
import 'package:project_fly/models/player.dart';
import 'package:project_fly/models/song.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:aura_box/aura_box.dart';

class SongComponent extends StatefulWidget {
  final Song song;
  SongComponent({required this.song});

  @override
  State<StatefulWidget> createState() => _SongComponentState();
}

class _SongComponentState extends State<SongComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints.tightFor(width: 80.w, height: 90.h),
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: AuraBox(
          spots: [
            // Places one blue spot in the center
            AuraSpot(
              color: const Color.fromARGB(255, 1, 141, 255),
              radius: 500.0,
              alignment: Alignment.center,
              blurRadius: 100.0,
              stops: const [0.0, 0.5],
            ),
            // Places one red spot in the bottom right
            AuraSpot(
              color: const Color.fromARGB(255, 29, 110, 13),
              radius: 1500.0,
              alignment: Alignment.bottomRight,
              blurRadius: 250.0,
              stops: const [0.0, 0.7],
            ),
          ],
          decoration: BoxDecoration(
            color: const Color.fromARGB(141, 90, 152, 210),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ClipRect(
                  child: SizedBox(
                      width: 75.sp,
                      height: 75.sp,
                      child: SampleSong().albumArt),
                )),
            Container(
              color: Colors.lightBlue,
              height: 50,
              child: ButtonRow(song: widget.song),
            ),
          ]),
        ));
  }
}

class ButtonRow extends StatelessWidget {
  ButtonRow({required this.song});
  final Song song;
  final FocusNode childFocusNode = FocusNode();
  final MenuController menuController = MenuController();
  @override
  Widget build(BuildContext context) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        const Icon(Icons.favorite),
        const Icon(Icons.skip_previous),
        // IconButton(onPressed: () {}, ),
        MenuAnchor(
          childFocusNode: childFocusNode,
          controller: menuController,
          menuChildren: [
            MenuItemButton(
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Slider(
                      value: context.watch<FlyAudioHandler>().volume,
                      onChanged: (newVolumte) {
                        context
                            .read<FlyAudioHandler>()
                            .changeVolume(newVolumte);
                      }),
                ),
                onPressed: () {
                  menuController.close();
                }),
          ],
          // Volume control
          child: IconButton(
              onPressed: () {
                if (menuController.isOpen) {
                  menuController.close();
                } else {
                  menuController.open();
                }
              },
              icon: getVolumeIcon(context)),
        ),
        // Song info
        SelectableRegion(
            focusNode: FocusNode(),
            selectionControls: MaterialTextSelectionControls(),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                song.artist ?? '',
                style: TextStyle(fontSize: 20),
              ),
              Text(song.title)
            ])),
        // Play button
        IconButton(
            onPressed: () {
              context
                  .read<FlyAudioHandler>()
                  .setSource(song.source); // TODO: Fix this
              audioHandler.togglePlaying();
            },
            icon: context.watch<FlyAudioHandler>().isPlaying
                ? Icon(Icons.pause)
                : Icon(Icons.play_arrow)),
        IconButton(
            onPressed: () => context
                .read<FlyAudioHandler>()
                .setSource(AssetSource("error.mp3")),
            icon: Icon(Icons.skip_next)),
        const Icon(Icons.playlist_add),
      ]);
}

Icon getVolumeIcon(BuildContext context) {
  final volume = context.watch<FlyAudioHandler>().volume;
  if (volume == 0) {
    return Icon(Icons.volume_off);
  } else if (volume < 0.5) {
    return Icon(Icons.volume_down);
  } else {
    return Icon(Icons.volume_up);
  }
}
