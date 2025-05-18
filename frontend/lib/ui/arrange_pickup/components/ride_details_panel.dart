import 'package:flutter/material.dart';
import 'package:frontend/data/model/ride.dart';

class RideDetailsPanel extends StatelessWidget {
  final Ride ride;

  const RideDetailsPanel({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ride Details', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.person,
              label: 'Driver',
              value: ride.driver.name,
            ),
            _buildDetailRow(
              icon: Icons.directions_car,
              label: 'Vehicle',
              value: ride.vehicle.description,
            ),
            _buildDetailRow(
              icon: Icons.group,
              label: 'Available Seats',
              value: '${ride.capacity - ride.passengers}/${ride.capacity}',
            ),
            _buildDetailRow(
              icon: Icons.schedule,
              label: 'Departure',
              value: ride.estimatedDuration,
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
