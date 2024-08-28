import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:project_fly/pages/subpages/favorite_songs_subpage.dart';
import 'package:project_fly/pages/subpages/history_subpage.dart';
import 'package:project_fly/pages/subpages/queue.dart';
import 'package:project_fly/providers/page_provider.dart';

import 'package:project_fly/pages/settings_page.dart';

import 'package:provider/provider.dart';

enum FavoriteCards {
  favoriteSongs,
  history,
  albums,
  artists,
  playlists,
  shufflePlayAll,
  currentSong,
  queue,
  settings,
  import,
  cusomPlaylist
}

class FavoriteCard extends StatelessWidget {
  final FavoriteCards typeOfCard;
  const FavoriteCard({required this.typeOfCard, super.key});
  @override
  Widget build(BuildContext context) {
    switch (typeOfCard) {
      case FavoriteCards.favoriteSongs:
        return const FavoriteSongsCard();
      case FavoriteCards.history:
        return const HistoryCard();
      case FavoriteCards.albums:
        return const AlbumsCard();
      case FavoriteCards.artists:
        return ArtistsCard();
      case FavoriteCards.playlists:
        return PlaylistsCard();
      case FavoriteCards.shufflePlayAll:
        return const ShuffleCard();
      case FavoriteCards.currentSong:
      // return CurrentSongCard();
      case FavoriteCards.queue:
        return const QueueCard();
      case FavoriteCards.settings:
        return const SettingsCard();
      case FavoriteCards.import:
        return const ImportSongsCard();
      case FavoriteCards.cusomPlaylist:
        return const CustomPlaylistCard();
      default:
        throw Exception('Invalid type of card');
    }
  }
}

class ShortcutCard extends StatelessWidget {
  final Icon icon;
  final String text;
  final GestureTapCallback onTap;
  final Color color;
  ShortcutCard({
    required this.icon,
    required this.text,
    required this.onTap,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(9),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color,
          ),
          constraints: const BoxConstraints(minHeight: 50),
          child: Row(
            children: [
              icon,
              Text(
                text,
                overflow: TextOverflow.ellipsis,
              ), // TODO
            ],
          ),
        ),
      ),
    );
  }
}

class FavoriteSongsCard extends StatelessWidget {
  const FavoriteSongsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShortcutCard(
      icon: const Icon(Icons.favorite),
      text: "Favorites",
      onTap: () {
        context
            .read<PageProvider>()
            .setToCustomPage(const FavoriteSongsSubpage()); // TODO: Fix this
      },
      color: Colors.redAccent,
    );
  }
}

class HistoryCard extends StatelessWidget {
  const HistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShortcutCard(
      icon: const Icon(Icons.history),
      text: "History",
      onTap: () {
        context.read<PageProvider>().setToCustomPage(const HistorySubpage());
      },
      color: Colors.green,
    );
  }
}

class AlbumsCard extends StatelessWidget {
  const AlbumsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShortcutCard(
      icon: const Icon(Icons.album),
      text: "Albums",
      onTap: () {},
      color: Colors.orange,
    );
  }
}

class ArtistsCard extends StatelessWidget {
  ArtistsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShortcutCard(
      icon: const Icon(Icons.person),
      text: "Artists",
      onTap: () {},
      color: Colors.orange,
    );
  }
}

class PlaylistsCard extends StatelessWidget {
  PlaylistsCard({super.key});
  @override
  Widget build(BuildContext context) {
    return ShortcutCard(
      icon: const Icon(Icons.playlist_play),
      text: "Playlist",
      onTap: () {},
      color: const Color.fromARGB(255, 178, 19, 19),
    );
  }
}

class ShuffleCard extends StatelessWidget {
  const ShuffleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShortcutCard(
      icon: const Icon(Icons.shuffle),
      text: "Shuffle Play All",
      onTap: () {},
      color: const Color.fromARGB(255, 19, 178, 117),
    );
  }
}

class QueueCard extends StatelessWidget {
  const QueueCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShortcutCard(
      icon: const Icon(Icons.queue_music),
      text: "Queue",
      onTap: () {
        log("Queue card pressed");
        context.read<PageProvider>().setToCustomPage(const QueuePage());
      },
      color: const Color.fromARGB(255, 178, 19, 19),
    );
  }
}

class ImportSongsCard extends StatelessWidget {
  const ImportSongsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShortcutCard(
      icon: const Icon(Icons.label_important),
      text: "Import songs",
      onTap: () {},
      color: const Color.fromARGB(255, 22, 195, 218),
    );
  }
}

class CustomPlaylistCard extends StatelessWidget {
  const CustomPlaylistCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShortcutCard(
      icon: const Icon(Icons.label_important),
      text: "PLAYLIST TITLE", // TODO
      onTap: () {},
      color: const Color.fromARGB(255, 22, 195, 218),
    );
  }
}

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShortcutCard(
      icon: const Icon(Icons.music_note),
      text: "Settings",
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );
      },
      color: Colors.grey,
    );
  }
}

// class CurrentSongCard extends StatelessWidget {
//   const CurrentSongCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     RenderedSong? song = audioHandler.mediaItem.value != null
//         ? RenderedSong.fromMediaItem(audioHandler.mediaItem.value!)
//         : null;
//     if (song == null) {
//       return ShortcutCard(
//           icon: Icon(Icons.music_note),
//           text: "Currently playing...",
//           onTap: () {},
//           color: Colors.grey);
//     } else {
//       return ShortcutCard(
//           icon: Icon(Icons.music_note),
//           text: "Currently playing...",
//           onTap: () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => SongPage(song: song)));
//           },
//           color: Colors.grey);
//     }
//   }
// }
