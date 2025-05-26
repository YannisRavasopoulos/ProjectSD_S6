import 'package:flutter/material.dart';

class RewardsRedemptionCodeDialog extends StatelessWidget {
  final String code;

  const RewardsRedemptionCodeDialog({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Redemption Code'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Use the code below to claim your reward:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          SelectableText(
            code,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
