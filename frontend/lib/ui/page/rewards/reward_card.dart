import 'package:flutter/material.dart';
import 'rewards_viewmodel.dart';

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
              'Are you sure you want to redeem ${reward.title} for ${reward.cost} points?',
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

  Widget _buildRedeemButton(BuildContext context) {
    return ElevatedButton(
      onPressed:
          viewModel.isLoading ? null : () => _showRedemptionDialog(context),
      child:
          viewModel.isLoading
              ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
              : const Text('Redeem'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(reward.title),
        subtitle: Text('${reward.description}\nCost: ${reward.cost} Points'),
        trailing: AnimatedBuilder(
          animation: viewModel,
          builder: (context, _) => _buildRedeemButton(context),
        ),
      ),
    );
  }
}
