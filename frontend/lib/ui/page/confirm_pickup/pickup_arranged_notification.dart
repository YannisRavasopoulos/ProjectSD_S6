import 'package:flutter/material.dart';
import 'package:frontend/data/model/pickup.dart';
import 'package:frontend/ui/notification/notification_overlay.dart';

class PickupArrangedNotification extends StatelessWidget {
  final Pickup pickup;

  const PickupArrangedNotification({super.key, required this.pickup});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 16,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pickup Arranged',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Driver: ${pickup.ride.driver.name}',
                  style: const TextStyle(fontSize: 11),
                ),
                Text(
                  'Driver has arranged a pickup.',
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              NotificationOverlay.dismiss();
              Navigator.of(
                context,
              ).pushNamed('/confirm_pickup', arguments: pickup);
            },
            child: const Text('Proceed'),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
