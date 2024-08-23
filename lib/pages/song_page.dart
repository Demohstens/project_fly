import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_fly/components/progress_slider.dart';
import 'package:project_fly/main.dart';
import 'package:project_fly/models/song.dart';
import 'package:sizer/sizer.dart';
import 'package:aura_box/aura_box.dart';

class SongPage extends StatefulWidget {
  final RenderedSong song;
  SongPage({required this.song});

  @override
  State<StatefulWidget> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  StreamSubscription? stateListener;
  @override
  void initState() {
    stateListener = audioHandler.playbackState.listen((state) {
      setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    stateListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          title: Text(widget.song.title),
        ),
        bottomNavigationBar: BottomAppBar(
          child: ButtonRow(song: widget.song),
        ),
        body: Container(
            constraints: BoxConstraints.tightFor(width: 100.w, height: 100.h),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black), color: Colors.black),
            child: AuraBox(
              // Background aura
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
                // Image
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ClipRect(
                      child: SizedBox(
                          width: 75.sp,
                          height: 75.sp,
                          child: widget.song.albumArt),
                    )),
                Container()
              ]),
            )));
  }
}

class ButtonRow extends StatelessWidget {
  ButtonRow({required this.song});
  final RenderedSong song;
  final FocusNode childFocusNode = FocusNode();
  final MenuController menuController = MenuController();
  @override
  Widget build(BuildContext context) => Column(
        children: [
          const Expanded(
            child: ProgressSlider(),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            IconButton(
                onPressed: () {
                  userData.likedSongs.add(song.id);
                },
                icon: const Icon(Icons.favorite)),
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
                          value: 00,
                          onChanged: (newVolumte) {
                            audioHandler.setVolume(newVolumte);
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
            Expanded(
              flex: 2,
              child: SelectableRegion(
                  focusNode: FocusNode(),
                  selectionControls: MaterialTextSelectionControls(),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          song.title,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (song.artist != null)
                          Text(song.artist!,
                              style: TextStyle(fontSize: 15),
                              overflow: TextOverflow.ellipsis),
                        // TODO fix aligment.
                      ])),
            ),
            // Play button
            IconButton(
              onPressed: () {
                audioHandler.togglePlaying();
              },
              icon: audioHandler.playbackState.value.playing
                  ? Icon(Icons.pause)
                  : Icon(Icons.play_arrow),
            ),
            IconButton(
                onPressed: () {},
                // context.read<FlyAudioHandler>().playErrorSound(),
                icon: Icon(Icons.skip_next)),
            const Icon(Icons.playlist_add),
          ]),
        ],
      );
}

Icon getVolumeIcon(BuildContext context) {
  final volume = 0.0;
  // audioHandler.;
  if (volume == 0) {
    return Icon(Icons.volume_off);
  } else if (volume < 0.5) {
    return Icon(Icons.volume_down);
  } else {
    return Icon(Icons.volume_up);
  }
}
