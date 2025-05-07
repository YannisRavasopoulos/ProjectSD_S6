import 'package:flutter/material.dart';
import 'package:frontend/ui/shared_layout.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedLayout(
      body: Center(child: const Text('This is the Settings Page')),
      currentIndex: 0,
      isIndexed: false,
    );
  }
}
