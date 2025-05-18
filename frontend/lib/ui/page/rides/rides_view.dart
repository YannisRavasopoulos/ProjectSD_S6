import 'package:flutter/material.dart';
import 'package:frontend/ui/shared_layout.dart';

class RidesView extends StatelessWidget {
  const RidesView({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedLayout(
      body: Center(child: const Text('This is the Rides Page')),
      currentIndex: 2,
      isIndexed: true,
    );
  }
}
