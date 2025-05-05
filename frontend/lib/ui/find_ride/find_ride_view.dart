import 'package:flutter/material.dart';
import 'package:frontend/ui/shared/shared_combined.dart';

class FindRideView extends StatelessWidget {
  const FindRideView({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedCombined(
      menuColor: Colors.grey,
      name: "Find Ride",
      body: Center(child: const Text('This is the Find Ride Page')),
      currentIndex: 0,
    );
  }
}
