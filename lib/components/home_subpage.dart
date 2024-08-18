import 'package:flutter/material.dart';
import 'package:project_fly/components/song_list_item.dart';
import 'package:project_fly/models/player.dart';
import 'package:project_fly/models/settings.dart';
import 'package:project_fly/models/song.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HomeSubPage extends StatelessWidget {
  const HomeSubPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ListOfSongs();
  }
}

class ListOfSongs extends StatelessWidget {
  final List<Song>? songs;
  const ListOfSongs({this.songs, Key? super.key});

  @override
  Widget build(BuildContext context) {
    List<Song> songs = context.watch<FlyAudioHandler>().songs;
    return RefreshIndicator(
        onRefresh: () async {
          return context
              .read<FlyAudioHandler>()
              .updateSongList(context.read<Settings>().musicDirectory);
        },
        child: Row(children: [
          Flexible(
            child: ListView.builder(
              itemCount: songs.isEmpty ? 1 : songs.length,
              itemBuilder: (context, index) {
                if (songs.isEmpty) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          height: 40.h,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No Files found.",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                            ],
                          )),
                      TextButton(
                          onPressed: () {
                            selectMusicFolder().then((dir) {
                              if (dir != null) {
                                context.read<Settings>().setMusicDirectory(dir);
                              } else {
                                print("No valid dir selected.");
                              }
                            });
                          },
                          child: const Column(
                            children: [
                              Text(
                                "Select Music Folder ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Icon(Icons.folder, size: 100),
                            ],
                          ))
                    ],
                  ));
                } else {
                  Song song = songs[index];
                  return SongListitem(song: song);
                }
              },
            ),
          )
        ]));
  }
}
