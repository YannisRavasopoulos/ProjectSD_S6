import 'package:frontend/data/model/reward.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final Reward reward;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmationDialog({
    Key? key,
    required this.reward,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Redemption'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'Are you sure you want to redeem ${reward.title} for ${reward.points} points?',
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(child: const Text('Cancel'), onPressed: onCancel),
        TextButton(child: const Text('Redeem'), onPressed: onConfirm),
      ],
    );
  }
}
