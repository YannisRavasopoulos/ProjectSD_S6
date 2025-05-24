import 'package:flutter/material.dart';
import 'package:frontend/data/model/reward.dart';

class RewardCard extends StatelessWidget {
  final Reward reward;
  final int userPoints;
  final bool isLoading;
  final ValueChanged<Reward> onRedeem;

  const RewardCard({
    super.key,
    required this.reward,
    required this.userPoints,
    required this.isLoading,
    required this.onRedeem,
  });

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
              hasEnoughPoints && !isLoading ? () => onRedeem(reward) : null,
          child:
              isLoading
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Text('Redeem'),
        ),
      ),
    );
  }
}
