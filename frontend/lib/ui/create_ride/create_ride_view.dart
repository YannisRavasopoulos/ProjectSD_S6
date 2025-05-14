import 'package:flutter/material.dart';
import 'package:frontend/ui/shared_layout.dart';

class CreateRideView extends StatelessWidget {
  const CreateRideView({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedLayout(
      body: Center(child: const Text('This is the Create Ride Page')),
      currentIndex: 0,
      isIndexed: false,
    );
  }
}
