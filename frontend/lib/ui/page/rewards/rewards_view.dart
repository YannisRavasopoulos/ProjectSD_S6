import 'package:flutter/material.dart';
import 'package:frontend/ui/page/profile/points_widget.dart';
import 'rewards_viewmodel.dart';
import 'reward_card.dart';

class RewardView extends StatelessWidget {
  final RewardViewModel viewModel;

  const RewardView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Redeem Reward')),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildContent(context);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Points:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          PointsWidget(points: viewModel.userPoints),
          const SizedBox(height: 24),
          const Text(
            'Available Rewards:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: AnimatedBuilder(
              animation: viewModel,
              builder: (context, _) {
                return ListView.builder(
                  itemCount: viewModel.availableRewards.length,
                  itemBuilder: (context, index) {
                    final reward = viewModel.availableRewards[index];
                    return RewardCard(
                      reward: reward,
                      userPoints: viewModel.userPoints,
                      isLoading: viewModel.isLoading,
                      onRedeem: viewModel.redeem,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
