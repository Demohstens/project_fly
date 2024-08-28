import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:project_fly/providers/android_audio_handler.dart';
import 'package:project_fly/providers/database_provider.dart';
import 'package:project_fly/providers/page_provider.dart';
import 'package:project_fly/providers/settings.dart' as settings;
import 'package:project_fly/pages/homepage.dart';
import 'package:project_fly/models/userdata.dart';
import 'package:project_fly/providers/song_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

late AndroidAudioHandler audioHandler;
UserData userData = UserData();
// late FirebaseFirestore db;
// late User? user;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure this is called
  audioHandler = await AudioService.init(
    builder: () => AndroidAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.demosoftworks.fly.fly.channel.audio',
      androidNotificationChannelName: 'Fly Music',
    ),
  );

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
        ChangeNotifierProvider(create: (_) => PageProvider()),
        ChangeNotifierProvider(create: (_) => SongProvier()),
        ChangeNotifierProvider(create: (_) => DatabaseProvider()),
      ],
      child: ResponsiveSizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            title: 'Fly - Music Player',
            theme: ThemeData(
              colorScheme: context.watch<settings.Settings>().isDarkMode
                  ? darkColorScheme
                  : colorScheme,
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
      ),
    );
  }
}

const textColor = Color(0xFF000000);
const backgroundColor = Color.fromARGB(255, 255, 255, 255);
const primaryColor = Color(0xFFa895fc);
const primaryFgColor = Color(0xFF000000);
const secondaryColor = Color(0xFF272644);
const secondaryFgColor = Color(0xFFe0e0e0);
const accentColor = Color(0xFFfd8b8b);
const accentFgColor = Color(0xFF000000);

const colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: primaryColor,
  onPrimary: primaryFgColor,
  secondary: secondaryColor,
  onSecondary: secondaryFgColor,
  tertiary: accentColor,
  onTertiary: accentFgColor,
  surface: backgroundColor,
  onSurface: textColor,
  error: Brightness.light == Brightness.light
      ? Color(0xffB3261E)
      : Color(0xffF2B8B5),
  onError: Brightness.light == Brightness.light
      ? Color(0xffFFFFFF)
      : Color(0xff601410),
);

const darkTextColor = Color(0xFFffffff);
const darkBackgroundColor = Color(0xFF1f1f1f);
const darkPrimaryColor = Color(0xFF160368);
const darkPrimaryFgColor = Color(0xFFffffff);
const darkSecondaryColor = Color(0xFFbbbad8);
const darkSecondaryFgColor = Color(0xFF1f1f1f);
const darkAccentColor = Color(0xFF740202);
const dakrAccentFgColor = Color(0xFFffffff);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: darkPrimaryColor,
  onPrimary: darkPrimaryFgColor,
  secondary: darkSecondaryColor,
  onSecondary: darkSecondaryFgColor,
  tertiary: darkAccentColor,
  onTertiary: dakrAccentFgColor,
  surface: darkBackgroundColor,
  onSurface: darkTextColor,
  error: Brightness.dark == Brightness.light
      ? Color(0xffB3261E)
      : Color(0xffF2B8B5),
  onError: Brightness.dark == Brightness.light
      ? Color(0xffFFFFFF)
      : Color(0xff601410),
);
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

