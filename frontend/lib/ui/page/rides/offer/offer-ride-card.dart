import 'package:flutter/material.dart';
import 'package:frontend/data/model/ride.dart';

class RideCard extends StatelessWidget {
  final Ride ride;
  final VoidCallback onOfferRidePressed;

  const RideCard({
    super.key,
    required this.ride,
    required this.onOfferRidePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        leading: CircleAvatar(),
        title: Text(ride.driver.name),
        subtitle: Text(ride.driver.vehicle.description),
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
                      Text('Arrival estimation: ${ride.estimatedArrivalTime}'),
                      const SizedBox(height: 8.0),
                      Text(
                        'Estimated Duration: ${ride.estimatedDuration.inMinutes} mins',
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Available seats: ${ride.availableSeats}/${ride.totalSeats}',
                      ),
                      Text('Route: ${ride.route.start} to ${ride.route.end}'),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed: onOfferRidePressed,
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text('Offer'),
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
