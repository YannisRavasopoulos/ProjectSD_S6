import 'package:flutter/material.dart';
import 'package:frontend/ui/shared_layout.dart';

class ActivitiesView extends StatelessWidget {
  const ActivitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedLayout(
      body: Center(child: const Text('This is the Activities Page')),
      currentIndex: 1,
    );
  }
}
