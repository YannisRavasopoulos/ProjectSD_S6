import 'package:flutter/material.dart';
import 'package:frontend/data/model/ride.dart';

// Card(
//           );

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
        subtitle: Text(ride.description),
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
                      Text('Distance: ${ride.distance}'),
                      const SizedBox(height: 8.0),
                      Text('Estimated Duration: ${ride.estimatedDuration}'),
                      const SizedBox(height: 8.0),
                      Text(
                        'Additional Details: ${ride.passengers}/${ride.capacity}',
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed:
                      ride.passengers.length < ride.capacity
                          ? () {
                            // Add your join ride logic here
                            print('Join ride button pressed');
                          }
                          : null,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: const Text('Join'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget build(BuildContext context) {
  //   return Card(
  //     margin: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: ListTile(
  //       leading: const Icon(Icons.directions_car),
  //       title: Text(ride.driver.name),
  //       subtitle: Text(ride.description),
  //       trailing: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Text(ride.distance),
  //           const SizedBox(height: 4.0),
  //           Text(ride.estimatedDuration),
  //         ],
  //       ),
  //     ),
  //     // child: ListTile(
  //     // ),
  //   );
  // }
}
