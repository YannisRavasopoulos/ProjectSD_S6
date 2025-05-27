import 'package:flutter/material.dart';
import 'package:frontend/data/impl/impl_activity_repository.dart';

class ActivityListCard extends StatelessWidget {
  final ImplActivity activity;
  final VoidCallback onCarpoolTap;

  const ActivityListCard({
    super.key,
    required this.activity,
    required this.onCarpoolTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Add shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Rounded corners like created rides
      ),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange,
          radius: 22,
          child: const Icon(Icons.directions_car, color: Colors.white, size: 26),
        ),
        title: Text(
          '${activity.startLocation.name} → ${activity.endLocation.name}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(activity.name),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.orange),
        onTap: onCarpoolTap,
      ),
    );
  }
}