import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:project_fly/models/player.dart';
import 'package:project_fly/models/settings.dart';
import 'package:project_fly/models/songs.dart';
import 'package:project_fly/pages/homepage.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

late FlyAudioHandler audioHandler;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure this is called
  audioHandler = await AudioService.init(
      builder: () => FlyAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.demosoftworks.fly.channel.audio',
        androidNotificationChannelName: 'Fly Music',
      ));
  runApp(const Fly());
}

class Fly extends StatelessWidget {
  const Fly({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Settings()),
          ChangeNotifierProvider(create: (_) => Songs()),
          ChangeNotifierProvider(create: (_) => audioHandler),
        ],
        child: ResponsiveSizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
              title: 'Fly - Music Player',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: HomePage(),
            );
          },
        ));
  }
}
