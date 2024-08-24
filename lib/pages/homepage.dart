import 'package:flutter/material.dart';
import 'package:project_fly/components/currently_playing_island.dart';
import 'package:project_fly/components/fly_drawer.dart';
import 'package:project_fly/main.dart';
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
  void initState() {
    super.initState();
    // context
    // .read<MusicLibrary>()
    // .updateSongList(context.read<Settings>().musicDirectory);
  }

  Widget? homeScaffoldBody;

  void updatePage() {
    context.read<PageProvider>().rebuildPages();
    setState(() {
      homeScaffoldBody = context.read<PageProvider>().pages[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget? homeScaffoldBody = context.watch<PageProvider>().currentPage ??
        context.read<PageProvider>().pages[0];

    return Scaffold(
      drawer: FlyDrawer(),
      persistentFooterAlignment: AlignmentDirectional.centerStart,
      persistentFooterButtons: const [CurrentlyPlayingIsland()],
      appBar: AppBar(
        centerTitle: true,
        title: TextButton(
          onPressed: () {
            updatePage();
            context.read<Settings>().updateSongList();
          },
          child: const Text("Project Fly"),
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
