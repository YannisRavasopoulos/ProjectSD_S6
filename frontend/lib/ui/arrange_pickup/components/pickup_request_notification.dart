import 'package:flutter/material.dart';
import 'package:frontend/data/model/pickup.dart';

class PickupRequestNotification extends StatelessWidget {
  final Pickup pickup;

  const PickupRequestNotification({super.key, required this.pickup});

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
            color: Colors.black,
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
              Icons.directions_car,
              color: Color.fromARGB(255, 255, 255, 255),
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'New Pickup Request',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '• ${pickup.pickupTime.hour}:${pickup.pickupTime.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
                // Text(
                //   'From ${//TODO driver getter name by id}',
                //   style: const TextStyle(fontSize: 11),
                // ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => Navigator.pop(context, false),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              IconButton(
                icon: const Icon(Icons.check, size: 18),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
