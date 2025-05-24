import 'package:frontend/data/model/reward.dart';
import 'package:flutter/material.dart';

class RewardConfirmationDialog extends StatelessWidget {
  final Reward reward;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const RewardConfirmationDialog({
    super.key,
    required this.reward,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Redemption'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text(
              'Are you sure you want to redeem ${reward.title} for ${reward.points} points?',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: onCancel, child: const Text('Cancel')),
        TextButton(onPressed: onConfirm, child: const Text('Redeem')),
      ],
    );
  }
}
