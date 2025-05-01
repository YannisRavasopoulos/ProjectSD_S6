import 'package:flutter/material.dart';
import 'shared.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
    );
  }
}
