import 'package:flutter/material.dart';
import 'package:frontend/ui/shared_layout.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedLayout(
      body: Center(child: const Text('This is the Profile Page')),
      currentIndex: 2,
    );
  }
}
