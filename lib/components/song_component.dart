import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:project_fly/main.dart';
import 'package:project_fly/models/song.dart';
import 'package:sizer/sizer.dart';

class SongComponent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SongComponentState();
}

class _SongComponentState extends State<SongComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tightFor(width: 80.w, height: 90.h),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ClipRect(
              child: SizedBox(
                  width: 75.sp, height: 75.sp, child: SampleSong().albumArt),
            )),
        SizedBox(
          height: 25.sp,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            const Icon(Icons.favorite),
            const Icon(Icons.skip_previous),
            SelectableRegion(
                focusNode: FocusNode(),
                selectionControls: MaterialTextSelectionControls(),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(SampleSong().artist),
                      Text(SampleSong().title)
                    ])),
            IconButton(
                onPressed: () {
                  audioHandler.play();
                },
                icon: Icon(Icons.play_arrow)),
            const Icon(Icons.skip_next),
            const Icon(Icons.playlist_add),
          ]),
        ),
      ]),
    );
  }
}
