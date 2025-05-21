import 'package:flutter/material.dart';

class FloatingProfileButton extends StatelessWidget {
  const FloatingProfileButton({super.key});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    padding: const EdgeInsets.all(4),
    child: IconButton(
      icon: const Icon(Icons.person, color: Colors.black87),
      onPressed: () => Navigator.pushNamed(context, '/profile'),
      tooltip: 'Open profile',
    ),
  );
}
