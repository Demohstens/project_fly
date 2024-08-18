import 'package:flutter/material.dart';
import 'package:project_fly/models/settings.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String musicDirectory = context.watch<Settings>().musicDirectory != null
        ? context.watch<Settings>().musicDirectory!.path
        : 'Not set';

    return Scaffold(
        appBar: AppBar(
          leading: // Home button
              IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Settings'),
        ),
        body: Consumer(builder: (context, Settings settings, child) {
          return ListView(
            children: <Widget>[
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: settings.isDarkMode,
                onChanged: (bool value) {
                  settings.isDarkMode = value;
                },
              ),
              // Folder picker
              ListTile(
                title: const Text('Music Directory'),
                subtitle: Text(musicDirectory),
                onTap: () {
                  selectMusicFolder().then((value) {
                    settings.setMusicDirectory(value);
                  });
                },
              ),
            ],
          );
        }));
  }
}
