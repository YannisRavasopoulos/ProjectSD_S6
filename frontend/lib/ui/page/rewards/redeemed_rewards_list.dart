import 'package:flutter/material.dart';
import 'package:frontend/data/model/redeemed_reward.dart';

class RedeemedRewardsList extends StatelessWidget {
  final List<RedeemedReward> redeemedRewards;

  const RedeemedRewardsList({super.key, required this.redeemedRewards});

  @override
  Widget build(BuildContext context) {
    if (redeemedRewards.isEmpty) {
      return const Center(child: Text('No redeemed rewards yet.'));
    }

    return ListView.builder(
      itemCount: redeemedRewards.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        final reward = redeemedRewards[index];
        return Card(
          child: ListTile(
            title: Text(reward.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reward.description),
                const SizedBox(height: 4),
                Text(
                  'Redemption code: ${reward.redemptionCode}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
