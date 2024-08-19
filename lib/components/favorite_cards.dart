import 'package:flutter/material.dart';
import 'package:project_fly/models/player.dart';
import 'package:project_fly/pages/settings_page.dart';
import 'package:project_fly/pages/song_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

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
        return FavoriteSongsCard();
      case FavoriteCards.history:
        return HistoryCard();
      case FavoriteCards.albums:
        return AlbumsCard();
      case FavoriteCards.artists:
        return ArtistsCard();
      case FavoriteCards.playlists:
        return PlaylistsCard();
      case FavoriteCards.shufflePlayAll:
        return ShuffleCard();
      case FavoriteCards.currentSong:
        return CurrentSongCard();
      case FavoriteCards.queue:
        return QueueCard();
      case FavoriteCards.settings:
        return SettingsCard();
      case FavoriteCards.import:
        return ImportSongsCard();
      case FavoriteCards.cusomPlaylist:
        return CustomPlaylistCard();
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
  ShortcutCard(
      {required this.icon,
      required this.text,
      required this.onTap,
      required this.color,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: GestureDetector(
                onTap: onTap,
                child: Container(
                    margin: EdgeInsets.all(6),
                    padding: EdgeInsets.all(6),
                    color: color,
                    constraints: BoxConstraints(minHeight: 50),
                    child: Row(children: [
                      icon,
                      Text(
                        text,
                        overflow: TextOverflow.ellipsis,
                      ), // TODO
                    ])))));
  }
}

class FavoriteSongsCard extends StatelessWidget {
  const FavoriteSongsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShortcutCard(
        icon: Icon(Icons.favorite),
        text: "Favorites",
        onTap: () {},
        color: Colors.redAccent);
  }
}

class HistoryCard extends StatelessWidget {
  const HistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShortcutCard(
        icon: Icon(Icons.history),
        text: "History",
        onTap: () {},
        color: Colors.green);
  }
}

class AlbumsCard extends StatelessWidget {
  const AlbumsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShortcutCard(
        icon: Icon(Icons.album),
        text: "Albums",
        onTap: () {},
        color: Colors.orange);
  }
}

class ArtistsCard extends StatelessWidget {
  ArtistsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShortcutCard(
        icon: Icon(Icons.person),
        text: "Artists",
        onTap: () {},
        color: Colors.orange);
  }
}

class PlaylistsCard extends StatelessWidget {
  PlaylistsCard({super.key});
  @override
  Widget build(BuildContext context) {
    return ShortcutCard(
        icon: Icon(Icons.playlist_play),
        text: "Playlist",
        onTap: () {},
        color: const Color.fromARGB(255, 178, 19, 19));
  }
}

class ShuffleCard extends StatelessWidget {
  const ShuffleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShortcutCard(
        icon: Icon(Icons.shuffle),
        text: "Shuffle Play All",
        onTap: () {},
        color: const Color.fromARGB(255, 19, 178, 117));
  }
}

class QueueCard extends StatelessWidget {
  const QueueCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShortcutCard(
        icon: Icon(Icons.queue_music),
        text: "Queue",
        onTap: () {},
        color: const Color.fromARGB(255, 178, 19, 19));
  }
}

class ImportSongsCard extends StatelessWidget {
  const ImportSongsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShortcutCard(
        icon: Icon(Icons.label_important),
        text: "Import songs",
        onTap: () {},
        color: const Color.fromARGB(255, 22, 195, 218));
  }
}

class CustomPlaylistCard extends StatelessWidget {
  const CustomPlaylistCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShortcutCard(
        icon: Icon(Icons.label_important),
        text: "PLAYLIST TITLE", // TODO
        onTap: () {},
        color: const Color.fromARGB(255, 22, 195, 218));
  }
}

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShortcutCard(
        icon: Icon(Icons.music_note),
        text: "Settings",
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SettingsPage()));
        },
        color: Colors.grey);
  }
}

class CurrentSongCard extends StatelessWidget {
  const CurrentSongCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShortcutCard(
        icon: Icon(Icons.music_note),
        text: "Currently playing...",
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SongPage(
                      song: context.read<FlyAudioHandler>().currentSong)));
        },
        color: Colors.grey);
  }
}
