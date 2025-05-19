import 'package:flutter/material.dart';
import 'rewards_viewmodel.dart';
import 'package:frontend/data/model/reward.dart';

class RewardCard extends StatelessWidget {
  final Reward reward;
  final RewardViewModel viewModel;

  const RewardCard({Key? key, required this.reward, required this.viewModel})
    : super(key: key);

  void _showRedemptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (BuildContext alertCtx) => AlertDialog(
            title: const Text('Redeem Reward'),
            content: Text(
              'Are you sure you want to redeem ${reward.name} for ${reward.points} points?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(alertCtx).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => _handleRedemption(context, alertCtx),
                child: const Text('Redeem'),
              ),
            ],
          ),
    );
  }

  Future<void> _handleRedemption(
    BuildContext context,
    BuildContext alertCtx,
  ) async {
    Navigator.of(alertCtx).pop();
    await viewModel.redeemReward(reward);

    if (viewModel.errorMessage.isNotEmpty) {
      _showErrorMessage(context);
    }

    if (viewModel.redemptionCode.isNotEmpty) {
      _showRedemptionCode(context);
    }
  }

  void _showErrorMessage(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(viewModel.errorMessage)));
  }

  void _showRedemptionCode(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Redemption Code'),
            content: Text(viewModel.redemptionCode),
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        final bool hasEnoughPoints = viewModel.userPoints >= reward.points;

        return Card(
          color:
              hasEnoughPoints //color based on points
                  ? const Color.fromARGB(255, 220, 237, 223) // Light green
                  : const Color.fromARGB(255, 255, 220, 220), // Light red
          child: ListTile(
            title: Text(
              reward.name,
              style: TextStyle(
                color: hasEnoughPoints ? Colors.black87 : Colors.red[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${reward.description}\nCost: ${reward.points} Points',
              style: TextStyle(
                color: hasEnoughPoints ? Colors.black54 : Colors.red[400],
              ),
            ),
            trailing: AnimatedBuilder(
              animation: viewModel,
              builder: (context, _) => _buildRedeemButton(context),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRedeemButton(BuildContext context) {
    final bool hasEnoughPoints = viewModel.userPoints >= reward.points;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            hasEnoughPoints
                ? const Color.fromARGB(255, 23, 143, 117) // enavbled green
                : Colors.grey, // Disabled gray
      ),
      onPressed:
          (!hasEnoughPoints || viewModel.isLoading)
              ? null
              : () => _showRedemptionDialog(context),
      child:
          viewModel.isLoading
              ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
              : Text(
                'Redeem',
                style: TextStyle(
                  color: hasEnoughPoints ? Colors.white : Colors.grey[300],
                ),
              ),
    );
  }
}
