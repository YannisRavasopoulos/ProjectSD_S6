import 'package:flutter/material.dart';
import 'package:frontend/data/model/reward.dart';
import 'package:frontend/ui/page/profile/points_widget.dart';
import 'rewards_viewmodel.dart';
import 'reward_card.dart';

class RewardView extends StatelessWidget {
  final RewardViewModel viewModel;

  const RewardView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    Future<void> onRedeem(Reward reward) async {
      final code = await viewModel.redeem(reward);
      if (code != null) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Reward Redeemed'),
                content: Text('Your redemption code is:\n\n$code'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
      }
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Redeem Reward'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Available'), Tab(text: 'Redeemed')],
          ),
        ),
        body: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return _buildContent(
              context,
              availableRewards: viewModel.availableRewards,
              redeemedRewards: viewModel.redeemedRewards,
              userPoints: viewModel.userPoints,
              isLoading: viewModel.isLoading,
              onRedeem: onRedeem, // Pass the callback here
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context, {
    required List availableRewards,
    required List redeemedRewards,
    required int userPoints,
    required bool isLoading,
    required ValueChanged<Reward> onRedeem,
  }) {
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
          PointsWidget(points: userPoints),
          const SizedBox(height: 24),
          Expanded(
            child: TabBarView(
              children: [
                _buildAvailableRewardsList(
                  availableRewards: availableRewards,
                  userPoints: userPoints,
                  isLoading: isLoading,
                  onRedeem: onRedeem,
                ),
                _buildRedeemedRewardsList(redeemedRewards: redeemedRewards),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableRewardsList({
    required List availableRewards,
    required int userPoints,
    required bool isLoading,
    required ValueChanged<Reward> onRedeem,
  }) {
    return ListView.builder(
      itemCount: availableRewards.length,
      itemBuilder: (context, index) {
        final reward = availableRewards[index];
        return RewardCard(
          reward: reward,
          userPoints: userPoints,
          isLoading: isLoading,
          onRedeem: onRedeem,
        );
      },
    );
  }

  Widget _buildRedeemedRewardsList({required List redeemedRewards}) {
    if (redeemedRewards.isEmpty) {
      return const Center(child: Text('No redeemed rewards yet.'));
    }
    return ListView.builder(
      itemCount: redeemedRewards.length,
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
                  'Redemption code: ${(reward as dynamic).redemptionCode}',
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
