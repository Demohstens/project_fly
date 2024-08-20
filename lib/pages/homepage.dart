import 'package:flutter/material.dart';
import 'package:project_fly/components/currently_playing_island.dart';
import 'package:project_fly/components/fly_drawer.dart';
import 'package:project_fly/components/home_subpage.dart';
import 'package:project_fly/providers/library.dart';
import 'package:project_fly/providers/page_provider.dart';
import 'package:project_fly/providers/settings.dart';
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
      context
          .read<MusicLibrary>()
          .updateSongList(context.read<Settings>().musicDirectory);
    }

    return FlyNavBar();
  }
}

//  SongComponent(song: SampleSong())

class FlyNavBar extends StatelessWidget {
  FlyNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    int currentPageIndex = context.watch<PageProvider>().currentPageIndex;

    Widget? homeScaffoldBody = context.watch<PageProvider>().currentPage;

    return Scaffold(
      drawer: FlyDrawer(),
      persistentFooterAlignment: AlignmentDirectional.centerStart,
      persistentFooterButtons: [CurrentlyPlayingIsland()],
      appBar: AppBar(
        centerTitle: true,
        title: TextButton(
          onPressed: () {
            context
                .read<MusicLibrary>()
                .updateSongList(context.read<Settings>().musicDirectory);
          },
          child: Text("Project Fly"),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: context.watch<PageProvider>().currentPageIndex,
        onDestinationSelected: (int index) {
          context.read<PageProvider>().setToOriginalIndex(index);
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
      body: homeScaffoldBody,
    );
  }
}
