import 'package:flutter/material.dart';
import 'package:frontend/ui/page/profile/points_widget.dart';
import 'package:frontend/ui/page/rewards/available_rewards_list.dart';
import 'package:frontend/ui/page/rewards/redeemed_rewards_list.dart';
import 'package:frontend/ui/page/rewards/rewards_redemption_code_dialog.dart';
import 'rewards_viewmodel.dart';

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
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                PointsWidget(points: viewModel.userPoints),
                TabBar(tabs: [Tab(text: 'Available'), Tab(text: 'Redeemed')]),
                if (viewModel.isLoading)
                  Expanded(child: Center(child: CircularProgressIndicator()))
                else
                  Expanded(
                    child: TabBarView(
                      children: [
                        AvailableRewardsList(
                          availableRewards: viewModel.availableRewards,
                          userPoints: viewModel.userPoints,
                          onRedeem: (reward) async {
                            final code = await viewModel.redeem(reward);
                            if (code != null && context.mounted) {
                              showDialog(
                                context: context,
                                builder:
                                    (context) =>
                                        RewardsRedemptionCodeDialog(code: code),
                              );
                            }
                          },
                        ),
                        RedeemedRewardsList(
                          redeemedRewards: viewModel.redeemedRewards,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
