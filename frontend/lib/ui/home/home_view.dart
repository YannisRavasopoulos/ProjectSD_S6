import 'package:flutter/material.dart';
import 'package:frontend/ui/shared_layout.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedLayout(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Loop App!'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/next');
              },
              child: const Text('Start Looping'),
            ),
          ],
        ),
      ),
      currentIndex: 0,
      isIndexed: true,
    );
  }
}
