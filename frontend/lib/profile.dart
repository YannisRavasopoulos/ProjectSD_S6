import 'package:flutter/material.dart';
import 'shared.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedLayout(
      body: Center(child: const Text('This is the Profile Page')),
      currentIndex: 2,
    );
  }
}
