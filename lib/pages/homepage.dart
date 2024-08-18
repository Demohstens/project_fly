import 'package:flutter/material.dart';
import 'package:project_fly/components/song_component.dart';
import 'package:project_fly/models/song.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
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
    child: const Text('Home'),
  ),
  Container(
    child: const Text('Search'),
  ),
  Container(
    child: const Text('Library'),
  ),
];
