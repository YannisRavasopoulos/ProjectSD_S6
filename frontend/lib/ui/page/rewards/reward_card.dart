import 'package:flutter/material.dart';
import 'rewards_viewmodel.dart';

class RewardCard extends StatelessWidget {
  final Reward reward;
  final RewardViewModel viewModel;

  const RewardCard({Key? key, required this.reward, required this.viewModel})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(reward.title),
        subtitle: Text('${reward.description}\nCost: ${reward.cost} Points'),
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
                                    Navigator.of(alertCtx).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    Navigator.of(alertCtx).pop();

                                    await viewModel.redeemReward(reward);

                                    final error = viewModel.errorMessage.value;
                                    final code = viewModel.redemptionCode.value;

                                    if (error.isNotEmpty) {
                                      ScaffoldMessenger.of(
                                        dialogContext,
                                      ).showSnackBar(
                                        SnackBar(content: Text(error)),
                                      );
                                    }

                                    if (code.isNotEmpty) {
                                      showDialog(
                                        context: dialogContext,
                                        builder:
                                            (ctx) => AlertDialog(
                                              title: Text('Redemption Code'),
                                              content: Text(code),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop();
                                                    viewModel
                                                        .clearRedemptionCode();
                                                  },
                                                  child: Text('OK'),
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
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
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
  }
}
