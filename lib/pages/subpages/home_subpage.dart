import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:project_fly/components/song_list_item.dart';
import 'package:project_fly/main.dart';
import 'package:project_fly/models/song.dart';
import 'package:project_fly/providers/database_provider.dart';
import 'package:project_fly/providers/settings.dart';
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
  const ListOfSongs({Key? super.key});

  @override
  Widget build(BuildContext context) {
    log("Building ListOfSongs");
    List<MediaItem> songs = userData.mediaItems;
    final favoriteCards = context.watch<Settings>().favoriteCards;

    return RefreshIndicator(
      onRefresh: () async {
        return context.read<Settings>().updateSongList();
      },
      child: PagedSongList(),

      // CustomScrollView(
      //   slivers: [
      //     if (favoriteCards.isNotEmpty)
      //       // TODO: Dynamic list of favorite cards
      //       SliverToBoxAdapter(
      //         child: Column(
      //           children: [
      //             Row(
      //               children: [
      //                 for (int i = 0; i < favoriteCards.length; i++)
      //                   if (i % 2 == 0) favoriteCards[i],
      //               ],
      //             ),
      //             Row(
      //               children: [
      //                 for (int i = 0; i < favoriteCards.length; i++)
      //                   if (i % 2 == 1) favoriteCards[i],
      //               ],
      //             ),
      //           ],
      //         ),
      //       ),
      //     SliverList.builder(
      //       itemCount: songs.isEmpty ? 1 : songs.length,
      //       itemBuilder: (context, index) {
      //         if (songs.isEmpty) {
      //           return Center(
      //             child: Column(
      //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //               children: [
      //                 SizedBox(
      //                   height: 40.h,
      //                   child: const Column(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     children: [
      //                       Text(
      //                         "No Files found.",
      //                         style: TextStyle(
      //                           fontWeight: FontWeight.bold,
      //                           fontSize: 30,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 TextButton(
      //                   onPressed: () {
      //                     selectMusicFolder().then((dir) {
      //                       if (dir != null) {
      //                         context.read<Settings>().addMusicDirectory(dir);
      //                       } else {
      //                         log("No valid dir selected.");
      //                       }
      //                     });
      //                   },
      //                   child: const Column(
      //                     children: [
      //                       Text(
      //                         "Select Music Folder ",
      //                         style: TextStyle(
      //                           fontWeight: FontWeight.bold,
      //                           fontSize: 20,
      //                         ),
      //                       ),
      //                       Icon(Icons.folder, size: 100),
      //                     ],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           );
      //         } else {
      //           return SongListitem(song: songs[index]);
      //         }
      //       },
      //     ),
      //   ],
      // ),
    );
  }
}

class PagedSongList extends StatefulWidget {
  _PagedSongListState createState() => _PagedSongListState();
}

class _PagedSongListState extends State<PagedSongList> {
  static const _pageSize = 20;

  final PagingController<int, RenderedSong> _pagingController =
      PagingController(firstPageKey: 0);
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await context.read<DatabaseProvider>().getSongsPaginated(
            pageKey,
            pageSize: _pageSize,
          );
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<RenderedSong>(
            itemBuilder: (context, item, index) {
          return SongListitem(song: item);
        }));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
