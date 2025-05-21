import 'package:flutter/material.dart';

class FloatingMenuButton extends StatelessWidget {
  const FloatingMenuButton({super.key});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    padding: const EdgeInsets.all(4),
    child: IconButton(
      icon: const Icon(Icons.menu, color: Colors.black87),
      onPressed: () => Scaffold.of(context).openDrawer(),
      tooltip: 'Open menu',
    ),
  );
}
