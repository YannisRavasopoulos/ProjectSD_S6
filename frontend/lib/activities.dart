import 'package:flutter/material.dart';
import 'shared.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedLayout(
      body: Center(child: const Text('This is the Activities Page')),
      currentIndex: 1,
    );
  }
}
