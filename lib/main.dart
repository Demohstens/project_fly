import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:project_fly/models/library.dart';

import 'package:project_fly/models/player.dart';
import 'package:project_fly/models/settings.dart' as settings;
import 'package:project_fly/pages/homepage.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

late FlyAudioHandler audioHandler;
MusicLibrary musicLibrary = MusicLibrary();
// late FirebaseFirestore db;
// late User? user;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure this is called
  audioHandler = await AudioService.init(
      builder: () => FlyAudioHandler(musicLibrary: musicLibrary),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.demosoftworks.fly.fly.channel.audio',
        androidNotificationChannelName: 'Fly Music',
      ));

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // db = FirebaseFirestore.instance;
  // user = await getUser();

  runApp(const Fly());
}

class Fly extends StatelessWidget {
  const Fly({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => settings.Settings()),
          ChangeNotifierProvider(create: (_) => musicLibrary),
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
              darkTheme: ThemeData.dark(
                useMaterial3: true,
              ),
              themeMode: context.watch<settings.Settings>().isDarkMode
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: HomePage(),
            );
          },
        ));
  }
}

// Future<User?> getUser() async {
//   return await SharedPreferences.getInstance().then((value) async {
//     var id = value.getString("user_id");
//     if (id != null) {
//       try {
//         User returnedUser = await getUserByID(db, id);
//         return returnedUser;
//       } catch (e) {
//         print(e);
//         value.remove("user_id");
//         id = await createDatabaseUser(db);
//         User returnedUser = await getUserByID(db, id);

//         return returnedUser;
//       }
//     } else {
//       String id2 = await createDatabaseUser(db);

//       value.setString("user_id", id2);
//       return getUserByID(db, id2);
//     }
//   });
// }
