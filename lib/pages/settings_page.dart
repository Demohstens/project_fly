import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_fly/providers/settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
      body: Consumer(
        builder: (context, Settings settings, child) {
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
                title: DirectoryList(
                  directories: context.watch<Settings>().musicDirectories,
                ),
              ),
              ListTile(
                leading: Text("Delete Data"),
                title: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        SharedPreferences.getInstance().then((value) {
                          value.clear();
                        });
                      },
                      child: const Text("Delete local data"),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<Settings>().clearData();
                      },
                      child: const Text("Delete all data"),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class DirectoryList extends StatelessWidget {
  final List<Directory> directories;
  DirectoryList({required this.directories, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blueGrey,
          width: 1,
        ),
      ),
      height: 400,
      width: 100.h,
      child: Column(
        children: [
          TextButton(
            onPressed: () async {
              Directory? dir = await selectMusicFolder();
              if (dir != null) {
                if (!context
                    .read<Settings>()
                    .directoryInListOfDirectories(dir)) {
                  context.read<Settings>().addDirectory(dir);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Directory already added"),
                    ),
                  );
                }
              }
            },
            child: const Column(
              children: [Icon(Icons.add), Text("Add Directory")],
            ),
          ),
          Flexible(
            flex: 3,
            child: ListTile(
              title: ListView.builder(
                itemCount: directories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("Directory: ${directories[index].path}"),
                    trailing: IconButton(
                      onPressed: () {
                        context
                            .read<Settings>()
                            .removeDirectory(directories[index]);
                      },
                      icon: Icon(Icons.delete),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
