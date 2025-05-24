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
              hasEnoughPoints && !isLoading
                  ? () {
                    _showConfirmationDialog(context, reward, onRedeem);
                  }
                  : null,
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

  Future<void> _showConfirmationDialog(
    BuildContext context,
    Reward reward,
    ValueChanged<Reward> onRedeem,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
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
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Redeem'),
              onPressed: () {
                onRedeem(reward);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
