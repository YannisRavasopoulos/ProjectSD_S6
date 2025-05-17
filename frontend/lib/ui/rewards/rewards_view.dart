import 'package:flutter/material.dart';
import 'rewards_viewmodel.dart';
import 'reward_card.dart';

class RewardView extends StatelessWidget {
  final RewardViewModel viewModel;

  const RewardView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Redeem Reward')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Points:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ValueListenableBuilder<int>(
              valueListenable: viewModel.userPoints,
              builder: (context, points, _) {
                return Text('$points Points', style: TextStyle(fontSize: 16));
              },
            ),
            SizedBox(height: 24),
            Text(
              'Available Rewards:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ValueListenableBuilder<List<Reward>>(
                valueListenable: viewModel.availableRewards,
                builder: (context, rewards, _) {
                  return ListView.builder(
                    itemCount: rewards.length,
                    itemBuilder: (context, index) {
                      final reward = rewards[index];
                      return RewardCard(reward: reward, viewModel: viewModel);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
