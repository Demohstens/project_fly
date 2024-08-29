import 'package:flutter/material.dart';
import 'package:project_fly/components/progress_slider.dart';
import 'package:project_fly/main.dart';
import 'package:project_fly/models/song.dart';
import 'package:project_fly/providers/song_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:aura_box/aura_box.dart';
import 'package:provider/provider.dart';

class SongPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RenderedSong? song =
        context.select((SongProvier songProvier) => songProvier.currentSong);
    if (song == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(song.title),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ButtonRow(),
      ),
      body: Container(
        constraints: BoxConstraints.tightFor(width: 100.w, height: 100.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.black,
        ),
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
          child: Column(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ClipRect(
                  child: SizedBox(
                    width: 75.sp,
                    height: 75.sp,
                    child: song.albumArt,
                  ),
                ),
              ),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonRow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ButtonRowState();
}

class _ButtonRowState extends State<ButtonRow> {
  _ButtonRowState();

  final FocusNode childFocusNode = FocusNode();
  final MenuController menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    RenderedSong? tempSong =
        context.select((SongProvier songProvier) => songProvier.currentSong);
    bool isPlaying =
        context.select((SongProvier songProvier) => songProvier.isPlaying);
    RenderedSong song = tempSong!;
    return Column(
      children: [
        const Expanded(
          child: ProgressSlider(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                setState(() {});
                // userData.toggleLikeId(song.id);
              },
              icon: userData.likedSongs.contains(song.id)
                  ? const Icon(Icons.favorite, color: Colors.redAccent)
                  : const Icon(Icons.favorite_border),
            ),
            IconButton(
              onPressed: () {
                audioHandler.skipToPrevious();
              },
              icon: const Icon(Icons.skip_previous),
            ),
            MenuAnchor(
              childFocusNode: childFocusNode,
              controller: menuController,
              menuChildren: [
                MenuItemButton(
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Slider(
                      value: audioHandler.player.volume,
                      onChanged: (newVolumte) {
                        setState(() {
                          audioHandler.setVolume(newVolumte);
                        });
                      },
                    ),
                  ),
                  onPressed: () {
                    menuController.close();
                  },
                ),
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
                icon: getVolumeIcon(audioHandler.player.volume),
              ),
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
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (song.artist != null)
                      Text(
                        song.artist!,
                        style: TextStyle(fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                    // TODO fix aligment.
                  ],
                ),
              ),
            ),
            // Play button
            IconButton(
              onPressed: () {
                audioHandler.togglePlaying();
              },
              icon: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
            ),
            IconButton(
              onPressed: () {
                audioHandler.skipToNext();
              },
              icon: Icon(Icons.skip_next),
            ),
            const Icon(Icons.playlist_add),
          ],
        ),
      ],
    );
  }

  Icon getVolumeIcon(double volume) {
    // audioHandler.;
    if (volume == 0) {
      return Icon(Icons.volume_off);
    } else if (volume < 0.5) {
      return Icon(Icons.volume_down);
    } else {
      return Icon(Icons.volume_up);
    }
  }
}
