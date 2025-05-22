import 'package:flutter/material.dart';
import 'package:frontend/data/model/ride.dart';

class RideListCard extends StatelessWidget {
  final Ride ride;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const RideListCard({
    super.key,
    required this.ride,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          title: Text('${ride.id} → ${ride.id}'),
          subtitle: Text(
            'Capacity: ${ride.driver.vehicle.capacity}, Departure: ${ride.departureTime.hour.toString().padLeft(2, '0')}:${ride.departureTime?.minute.toString().padLeft(2, '0')}',
          ),
          leading: Icon(Icons.directions_car),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
