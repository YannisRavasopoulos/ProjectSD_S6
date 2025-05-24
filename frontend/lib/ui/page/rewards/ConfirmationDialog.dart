import 'package:frontend/data/model/reward.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final Reward reward;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final int currentPoints;

  const ConfirmationDialog({
    Key? key,
    required this.reward,
    required this.onConfirm,
    required this.onCancel,
    required this.currentPoints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool canAfford = currentPoints >= reward.points;

    return AlertDialog(
      title: const Text('Confirm Redemption'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'Are you sure you want to redeem ${reward.title} for ${reward.points} points?',
            ),
            if (!canAfford) ...[
              const SizedBox(height: 8),
              Text(
                'You don\'t have enough points (${currentPoints}/${reward.points})',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: onCancel,
        ),
        TextButton(
          child: const Text('Redeem'),
          onPressed: canAfford ? onConfirm : null,
        ),
      ],
    );
  }
}