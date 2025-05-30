import 'package:flutter/material.dart';
import 'package:frontend/data/model/reward.dart';
import 'package:frontend/ui/page/rewards/reward_card.dart';

class AvailableRewardsList extends StatelessWidget {
  final List availableRewards;
  final int userPoints;
  final ValueChanged<Reward> onRedeem;

  const AvailableRewardsList({
    super.key,
    required this.availableRewards,
    required this.userPoints,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    if (availableRewards.isEmpty) {
      return const Center(child: Text('No rewards available at the moment.'));
    }

    return ListView.builder(
      itemCount: availableRewards.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        final reward = availableRewards[index];
        return RewardCard(
          reward: reward,
          userPoints: userPoints,
          onRedeem: onRedeem,
        );
      },
    );
  }
}
