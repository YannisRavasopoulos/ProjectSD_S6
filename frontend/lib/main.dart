import 'package:flutter/material.dart';
import 'home.dart';
import 'profile.dart';
import 'activities.dart';

void main() {
  runApp(const LoopApp());
}

class LoopApp extends StatelessWidget {
  const LoopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loop App',
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/activities': (context) => const ActivitiesPage(),
      },
    );
  }
}
