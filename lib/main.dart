import 'package:bf_tracker/pages/home.dart';
import 'package:bf_tracker/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  final profileName = prefs.getString(Strings.profileNameKey) ?? '';
  final MyApp myApp = MyApp(
    initialRoute: profileName.isEmpty ? Strings.profilePage : Strings.homePage,
  );
  runApp(myApp);
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: GoogleFonts.poppins().fontFamily),
      initialRoute: initialRoute,
      routes: {
        Strings.homePage: (context) => const HomePage(),
        Strings.profilePage: (context) => const ProfilePage(),
      },
    );
  }
}
