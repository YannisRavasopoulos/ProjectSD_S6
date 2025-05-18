import 'package:flutter/material.dart';
import 'package:frontend/data/model/ride.dart';

class RideDetailsPanel extends StatelessWidget {
  final Ride ride;

  const RideDetailsPanel({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        // Reduce padding
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Make column as small as possible
          children: [
            Text(
              'Ride Details',
              style: Theme.of(context).textTheme.titleMedium, // Smaller title
            ),
            const SizedBox(height: 8), // Reduced spacing
            Row(
              // First row with driver and vehicle
              children: [
                Expanded(
                  child: _buildDetailRow(
                    icon: Icons.person,
                    label: 'Driver',
                    value: ride.driver.name,
                  ),
                ),
                Expanded(
                  child: _buildDetailRow(
                    icon: Icons.directions_car,
                    label: 'Vehicle',
                    value: ride.vehicle.description,
                  ),
                ),
              ],
            ),
            Row(
              // Second row with seats and departure
              children: [
                Expanded(
                  child: _buildDetailRow(
                    icon: Icons.group,
                    label: 'Seats',
                    value:
                        '${ride.capacity - ride.passengers}/${ride.capacity}',
                  ),
                ),
                Expanded(
                  child: _buildDetailRow(
                    icon: Icons.schedule,
                    label: 'Time',
                    value: ride.estimatedDuration,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Reduced padding
      child: Row(
        mainAxisSize: MainAxisSize.min, // Make row as small as possible
        children: [
          Icon(icon, size: 16), // Smaller icons
          const SizedBox(width: 4), // Reduced spacing
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12, // Smaller text
            ),
          ),
          const SizedBox(width: 4), // Reduced spacing
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12), // Smaller text
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
