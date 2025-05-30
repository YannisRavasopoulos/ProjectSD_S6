import 'package:flutter/material.dart';
import 'package:frontend/data/model/pickup.dart';
import 'package:frontend/ui/shared/route_view.dart';

class PickupDetailsWidget extends StatelessWidget {
  final Pickup pickup;

  const PickupDetailsWidget({super.key, required this.pickup});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Pickup Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.location_on),
          title: Text('Location: ${pickup.address.toString()}'),
        ),
        ListTile(
          leading: const Icon(Icons.access_time),
          title: Text('Time: ${pickup.time}'),
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: Text('Driver: ${pickup.ride.driver.name}'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Route:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 300,
                child: RouteView(route: pickup.ride.route, pickups: [pickup]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
