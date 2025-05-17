import 'package:flutter/material.dart';
import 'rewards_viewmodel.dart'; // Make sure this is correctly imported

class RewardView extends StatelessWidget {
  final RewardViewModel viewModel;

  RewardView({required this.viewModel});

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
                      return Card(
                        child: ListTile(
                          title: Text(reward.title),
                          subtitle: Text(
                            '${reward.description}\nCost: ${reward.cost} Points',
                          ),
                          trailing: ValueListenableBuilder<bool>(
                            valueListenable: viewModel.isLoading,
                            builder: (context, isLoading, _) {
                              return ElevatedButton(
                                onPressed:
                                    isLoading
                                        ? null
                                        : () {
                                          final dialogContext = context;

                                          showDialog(
                                            context: dialogContext,
                                            builder: (BuildContext alertCtx) {
                                              return AlertDialog(
                                                title: Text('Redeem Reward'),
                                                content: Text(
                                                  'Are you sure you want to redeem ${reward.title} for ${reward.cost} points?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(
                                                        alertCtx,
                                                      ).pop();
                                                    },
                                                    child: Text('Cancel'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      Navigator.of(
                                                        alertCtx,
                                                      ).pop();

                                                      // ✅ Use dialogContext captured earlier
                                                      await viewModel
                                                          .redeemReward(reward);

                                                      final error =
                                                          viewModel
                                                              .errorMessage
                                                              .value;
                                                      final code =
                                                          viewModel
                                                              .redemptionCode
                                                              .value;

                                                      if (error.isNotEmpty) {
                                                        ScaffoldMessenger.of(
                                                          dialogContext,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              error,
                                                            ),
                                                          ),
                                                        );
                                                      }

                                                      if (code.isNotEmpty) {
                                                        // Show code dialog with safe context
                                                        showDialog(
                                                          context:
                                                              dialogContext,
                                                          builder:
                                                              (
                                                                ctx,
                                                              ) => AlertDialog(
                                                                title: Text(
                                                                  'Redemption Code',
                                                                ),
                                                                content: Text(
                                                                  code,
                                                                ),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () {
                                                                      Navigator.of(
                                                                        ctx,
                                                                      ).pop();
                                                                      viewModel
                                                                          .clearRedemptionCode();
                                                                    },
                                                                    child: Text(
                                                                      'OK',
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                        );
                                                      }
                                                    },
                                                    child:
                                                        isLoading
                                                            ? SizedBox(
                                                              width: 20,
                                                              height: 20,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2,
                                                                  ),
                                                            )
                                                            : Text('Redeem'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                child: Text('Redeem'),
                              );
                            },
                          ),
                        ),
                      );
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
