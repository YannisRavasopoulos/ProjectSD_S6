import 'package:flutter/material.dart';

class Points extends StatelessWidget {
  final int points;
  final Color? themeColor;

  const Points({
    super.key,
    required this.points,
    this.themeColor = const Color.fromARGB(255, 23, 143, 117),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: themeColor?.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeColor ?? Theme.of(context).primaryColor,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.monetization_on_rounded, color: themeColor, size: 24),
          const SizedBox(width: 8),
          Text(
            '$points',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: themeColor,
            ),
          ),
          const SizedBox(width: 4),
          Text('Points', style: TextStyle(fontSize: 16, color: themeColor)),
        ],
      ),
    );
  }
}
