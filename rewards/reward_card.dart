import 'package:flutter/material.dart';
import 'rewards_viewmodel.dart';
import 'package:frontend/data/model/reward.dart';

class RewardCard extends StatelessWidget {
  final Reward reward;
  final RewardViewModel viewModel;

  const RewardCard({Key? key, required this.reward, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasEnoughPoints = viewModel.userPoints >= reward.points;

    return Card(
      color: hasEnoughPoints ? Colors.green.shade50 : Colors.red.shade50,
      child: ListTile(
        title: Text(reward.name),
        subtitle: Text('${reward.description}\nCost: ${reward.points} Points'),
        trailing: ElevatedButton(
          onPressed: hasEnoughPoints && !viewModel.isLoading
              ? () => _redeemReward(context)
              : null,
          child: viewModel.isLoading
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

  void _redeemReward(BuildContext context) async {
    await viewModel.redeemReward(reward);

    if (viewModel.errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.errorMessage)),
      );
    } else if (viewModel.redemptionCode.isNotEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Redemption Successful'),
          content: Text('Your redemption code: ${viewModel.redemptionCode}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                viewModel.clearRedemptionCode();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
