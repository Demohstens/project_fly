import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:project_fly/models/song.dart';
import 'package:project_fly/components/song_component.dart';
import 'package:project_fly/providers/current_song.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Fly'),
      ),
      body: Center(
        child: SongComponent(),
      ),
    );
  }
}
