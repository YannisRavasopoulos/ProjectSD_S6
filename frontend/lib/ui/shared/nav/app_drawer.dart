import 'package:flutter/material.dart' hide Route;
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/passenger.dart';
import 'package:frontend/data/model/pickup_request.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/model/route.dart';
import 'package:frontend/ui/notification/notification_overlay.dart';
import 'package:frontend/ui/page/pickups/pickup_request_notification.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color.fromARGB(255, 23, 143, 117)),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.card_giftcard), // Added rewards icon
            title: const Text('Rewards'), // Added rewards title
            onTap: () {
              Navigator.pushNamed(
                context,
                '/rewards',
              ); // Navigate to rewards view
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Find Ride'),
            onTap: () {
              Navigator.pushNamed(context, '/rides/find');
            },
          ),
          ListTile(
            leading: const Icon(Icons.directions_car),
            title: const Text('My Rides'),
            onTap: () {
              Navigator.pushNamed(context, '/rides');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Create Ride'),
            onTap: () {
              Navigator.pushNamed(context, '/rides/create');
            },
          ),
          ListTile(
            leading: const Icon(Icons.directions_car),
            title: const Text('Offer Ride'),
            onTap: () {
              Navigator.pushNamed(context, '/rides/offer');
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_active),
            title: const Text('Pickup Request Notification'),
            onTap: () {
              final pickupRequest = PickupRequest(
                id: 0,
                passenger: Passenger.fake(),
                address: Address.fake(),
                time: DateTime.now(),
                ride: Ride(
                  id: 0,
                  driver: Driver.fake(),
                  passengers: [],
                  route: Route.fake(),
                  departureTime: DateTime.now(),
                  estimatedArrivalTime: DateTime.now().add(
                    Duration(minutes: 30),
                  ),
                  totalSeats: 4,
                  estimatedDuration: Duration(minutes: 30),
                ),
              );

              // Close the drawer
              Navigator.pop(context);

              // Show the notification
              NotificationOverlay.show(
                context,
                PickupRequestNotification(pickupRequest: pickupRequest),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.flag),
            title: const Text('Ride Ended'),
            onTap: () {
              Navigator.pushNamed(context, '/rides/end');
            },
          ),
        ],
      ),
    );
  }
}
