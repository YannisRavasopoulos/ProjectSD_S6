import 'package:flutter/material.dart';
import 'package:frontend/data/model/reward.dart';
import 'reward_confirmation_dialog.dart';

class RewardCard extends StatelessWidget {
  final Reward reward;
  final int userPoints;
  final ValueChanged<Reward> onRedeem;

  const RewardCard({
    Key? key,
    required this.reward,
    required this.userPoints,
    required this.onRedeem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasEnoughPoints = userPoints >= reward.points;

    return Card(
      color: hasEnoughPoints ? Colors.green.shade50 : Colors.red.shade50,
      child: ListTile(
        title: Text(reward.title),
        subtitle: Text('${reward.description}\nCost: ${reward.points} Points'),
        trailing: ElevatedButton(
          onPressed:
              hasEnoughPoints
                  ? () {
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return RewardConfirmationDialog(
                          reward: reward,
                          onConfirm: () {
                            onRedeem(reward);
                            Navigator.of(context).pop();
                          },
                          onCancel: () {
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                  }
                  : null,
          child: const Text('Redeem'),
        ),
      ),
    );
  }
}
