import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_fly/components/home_subpage.dart';
import 'package:project_fly/components/song_component.dart';
import 'package:project_fly/models/song.dart';
import 'package:project_fly/models/songs.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
      context.read<Songs>().addSong(SampleSong());
      songFromFile(File(
              "C:\\Users\\demoh\\Documents\\Code\\Dart\\project_fly\\assets\\posivite_thinking.wav"))
          .then((Song song) {
        context.read<Songs>().addSong(song);
      });
    }

    return FlyNavBar();
  }
}

//  SongComponent(song: SampleSong())

class FlyNavBar extends StatefulWidget {
  const FlyNavBar({super.key});

  @override
  State<FlyNavBar> createState() => _FlyNavBarState();
}

class _FlyNavBarState extends State<FlyNavBar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Project Fly'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_music),
            label: 'Library',
          ),
        ],
      ),
      body: pages[currentPageIndex],
    );
  }
}

List<Widget> pages = <Widget>[
  Container(
    child: HomeSubPage(),
  ),
  Container(
    child: const Text('Search'),
  ),
  Container(
    child: const Text('Library'),
  ),
];
