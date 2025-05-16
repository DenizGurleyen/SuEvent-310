import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/home_page.dart';
import 'screens/club_page.dart';
import 'screens/explore_page.dart';
import 'screens/profile_page.dart';
import 'screens/profile_settings_page.dart';
import 'screens/settings_page.dart';
import 'widgets/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SuEventApp());
}

class SuEventApp extends StatelessWidget {
  const SuEventApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'SuEvent',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
        ),
        home: const AuthWrapper(),
        routes: {
          '/clubs': (context) => const ClubPage(),
          '/home': (context) => const HomePage(),
          '/explore': (context) => const ExplorePage(),
          '/profile': (context) => const ProfilePage(),
          '/profile/settings': (context) => const ProfileSettingsPage(),
          '/settings': (context) => const SettingsPage(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignUpPage(),
        },
      ),
    );
  }
}
