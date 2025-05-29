import 'package:flutter/material.dart';
import 'package:frontend/data/model/ride.dart';

class RideDetailsPanel extends StatelessWidget {
  final Ride ride;

  const RideDetailsPanel({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ride Details',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            // Driver and Vehicle info
            Row(
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
                    value:
                        ride.driver.vehicle.description, // TODO: ride.vehicle
                  ),
                ),
              ],
            ),
            // Capacity and Duration
            Row(
              children: [
                Expanded(
                  child: _buildDetailRow(
                    icon: Icons.group,
                    label: 'Available Seats',
                    value: '${ride.availableSeats}/${ride.totalSeats}',
                  ),
                ),
                Expanded(
                  child: _buildDetailRow(
                    icon: Icons.schedule,
                    label: 'Duration',
                    value: "${ride.estimatedDuration.inMinutes} mins",
                  ),
                ),
              ],
            ),
            // Distance and Description
            Row(
              children: [
                Expanded(
                  child: _buildDetailRow(
                    icon: Icons.location_on,
                    label: 'Starting Point',
                    value: ride.route.start.toString(),
                    // value: ride.description,
                  ),
                ),
              ],
            ),
            // Departure Time and Pickup Location if available
            Row(
              children: [
                Expanded(
                  child: _buildDetailRow(
                    icon: Icons.access_time,
                    label: 'Departure',
                    value: _formatDateTime(ride.departureTime),
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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Make row as small as possible
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
