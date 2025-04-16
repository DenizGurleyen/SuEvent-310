import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/map_page.dart';
import 'screens/club_page.dart';
import 'screens/explore_page.dart';
import 'screens/profile_page.dart';

void main() {
  runApp(const SuEventApp());
}

class SuEventApp extends StatelessWidget {
  const SuEventApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SuEvent',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      initialRoute: '/home',
      routes: {
        '/map': (context) => const MapPage(),
        '/clubs': (context) => const ClubPage(),
        '/home': (context) => HomePage(),
        '/explore': (context) => const ExplorePage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
