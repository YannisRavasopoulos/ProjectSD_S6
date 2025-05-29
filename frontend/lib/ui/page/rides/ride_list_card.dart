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
    return Card(
      child: ListTile(
        title: Text(
          '${ride.route.start.toString()} → ${ride.route.end.toString()}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}
