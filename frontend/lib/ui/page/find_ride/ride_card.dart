import 'package:flutter/material.dart';
import 'package:frontend/data/model/ride.dart';

class RideCard extends StatelessWidget {
  final Ride ride;

  const RideCard({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        // TODO
        // leading: const Icon(Icons.directions_car),
        leading: CircleAvatar(),
        title: Text(ride.driver.name),
        subtitle: Text("TODO"),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Distance: TODO'),
                      const SizedBox(height: 8.0),
                      Text('Estimated Duration: TODO'),
                      const SizedBox(height: 8.0),
                      Text(
                        'Additional Details: ${ride.availableSeats}/${ride.totalSeats}',
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed:
                      ride.availableSeats > 0
                          ? () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Not Implemented'),
                                  content: const Text(
                                    'This feature is not implemented yet.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          : null,
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text('Join'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
