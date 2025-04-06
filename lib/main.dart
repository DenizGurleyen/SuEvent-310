import 'package:flutter/material.dart';

void main() {
  runApp(const SuEventApp());
}

class SuEventApp extends StatelessWidget {
  const SuEventApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SuEvent',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Roboto', // Custom font (we'll add later)
      ),
      home: const HomeScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        // You’ll add more screens here later (like /login, /features, etc.)
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SuEvent Home')),
      body: const Center(child: Text('Welcome to SuEvent!')),
    );
  }
}
