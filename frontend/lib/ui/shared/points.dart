import 'package:flutter/material.dart';

class Points extends StatelessWidget {
  final int points;
  final Color? themeColor;

  const Points({
    super.key,
    required this.points,
    this.themeColor = const Color(0xFFDAA520), // Changed to Golden color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8DC), // Light gold/cream background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeColor ?? const Color(0xFFDAA520), // Golden border
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDAA520).withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.toll_rounded,
            color: themeColor,
            size: 24,
          ), // Changed to coin icon
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
