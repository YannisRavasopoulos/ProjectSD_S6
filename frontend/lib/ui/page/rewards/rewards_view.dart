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
            AnimatedBuilder(
              animation: viewModel,
              builder: (context, _) {
                return Text(
                  '${viewModel.userPoints} Points',
                  style: TextStyle(fontSize: 16),
                );
              },
            ),
            SizedBox(height: 24),
            Text(
              'Available Rewards:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: AnimatedBuilder(
                animation: viewModel,
                builder: (context, _) {
                  return ListView.builder(
                    itemCount: viewModel.availableRewards.length,
                    itemBuilder: (context, index) {
                      final reward = viewModel.availableRewards[index];
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
