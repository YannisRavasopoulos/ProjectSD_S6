import 'package:flutter/material.dart';
import 'package:frontend/ui/rewards/rewards_viewmodel.dart';

class RewardView extends StatefulWidget {
  final RewardViewModel viewModel;

  RewardView({required this.viewModel});

  @override
  _RewardViewState createState() => _RewardViewState();
}

class _RewardViewState extends State<RewardView> {
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
            Text(
              '${widget.viewModel.userPoints} Points',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Available Rewards:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: widget.viewModel.availableRewards.length,
                itemBuilder: (context, index) {
                  final reward = widget.viewModel.availableRewards[index];
                  return Card(
                    child: ListTile(
                      title: Text(reward.title),
                      subtitle: Text(
                        '${reward.description}\nCost: ${reward.cost} Points',
                      ),
                      trailing: ElevatedButton(
                        onPressed:
                            widget.viewModel.isLoading
                                ? null // Disable button while loading
                                : () {
                                  BuildContext currentContext = context;
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Redeem Reward'),
                                        content: Text(
                                          'Are you sure you want to redeem ${reward.title} for ${reward.cost} points?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              Navigator.of(context).pop();

                                              await widget.viewModel
                                                  .redeemReward(reward);

                                              // Capture the values before setState
                                              final errorMessage =
                                                  widget.viewModel.errorMessage;
                                              final redemptionCode =
                                                  widget
                                                      .viewModel
                                                      .redemptionCode;

                                              setState(() {
                                                // Update UI based on the captured values
                                                if (errorMessage.isNotEmpty) {
                                                  ScaffoldMessenger.of(
                                                    currentContext,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        errorMessage,
                                                      ),
                                                    ),
                                                  );
                                                }
                                                if (redemptionCode.isNotEmpty) {
                                                  showDialog(
                                                    context:
                                                        currentContext, // Use captured context
                                                    builder: (
                                                      BuildContext context,
                                                    ) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          'Redemption Code',
                                                        ),
                                                        content: Text(
                                                          redemptionCode,
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                context,
                                                              ).pop();
                                                              widget.viewModel
                                                                  .clearRedemptionCode();
                                                              setState(
                                                                () {},
                                                              ); // Update UI after clearing code
                                                            },
                                                            child: Text('OK'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                              });
                                            },
                                            child:
                                                widget.viewModel.isLoading
                                                    ? CircularProgressIndicator() // Show loading indicator
                                                    : Text('Redeem'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                        child: Text('Redeem'),
                      ),
                    ),
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
