import 'package:flutter/material.dart';

class CreateRideSuccess extends StatelessWidget {
  final String message;
  final VoidCallback onSavePressed;
  final VoidCallback? onOfferPressed;

  const CreateRideSuccess({
    super.key,
    required this.message,
    required this.onSavePressed,
    this.onOfferPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(color: Colors.green, fontSize: 16),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onSavePressed,
            child: const Text("Save and Close"),
          ),
          if (onOfferPressed != null) ...[
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: onOfferPressed,
              icon: const Icon(Icons.local_offer),
              label: const Text("Offer this Ride"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
          ],
        ],
      ),
    );
  }
}
