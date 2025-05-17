import 'package:flutter/material.dart';

class RewardView extends StatelessWidget {
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
              '12345 Points', // Replace with actual points data
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
                itemCount: 3, // Replace with actual reward list length
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        'Reward ${index + 1}',
                      ), // Replace with actual reward title
                      subtitle: Text(
                        'Cost: 1000 Points',
                      ), // Replace with actual reward cost
                      trailing: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement redeem reward logic
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Redeem Reward'),
                                content: Text(
                                  'Are you sure you want to redeem this reward?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      // TODO: Show redemption code
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Redemption Code'),
                                            content: Text(
                                              'YOUR_REDEMPTION_CODE',
                                            ), // Replace with actual code
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text('Redeem'),
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
