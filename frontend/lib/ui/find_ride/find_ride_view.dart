import 'package:flutter/material.dart';
import 'package:frontend/ui/shared_layout.dart';

class FindRideView extends StatelessWidget {
  const FindRideView({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedLayout(
      body: Center(child: const Text('This is the Find Ride Page')),
      currentIndex: 0,
      isIndexed: false,
    );
  }
}
