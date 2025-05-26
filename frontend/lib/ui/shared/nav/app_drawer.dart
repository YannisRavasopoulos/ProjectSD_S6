import 'package:flutter/material.dart';
import 'package:frontend/data/impl/impl_driver_repository';
import 'package:frontend/data/impl/impl_pickup_repository.dart';
import 'package:frontend/data/impl/impl_ride_repository.dart';
import 'package:frontend/data/mocks/mock_location_repository.dart';
import 'package:frontend/data/model/location.dart';
import 'package:frontend/data/mocks/mock_passenger_repo.dart';
import 'package:frontend/ui/page/arrange_pickup/pickup_request_notification.dart';
import 'package:frontend/ui/notification/notification_overlay.dart';

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
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
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
              Navigator.pushNamed(context, '/find_ride');
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
              Navigator.pushNamed(context, '/create_ride');
            },
          ),
          ListTile(
            leading: const Icon(Icons.directions_car),
            title: const Text('Offer Ride'),
            onTap: () {
              Navigator.pushNamed(context, '/offer_ride');
            },
          ),
          ListTile(
            //VGALTO EINAI GIA TEST
            leading: const Icon(Icons.report),
            title: const Text('Report User (Test)'),
            onTap: () {
              Navigator.pushNamed(context, '/report');
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Test Notification'),
            onTap: () {
              final testPickup = ImplPickup(
                id: 12345,
                passenger: MockPassenger.test(),
                location: MockLocation.random(),
                time: DateTime.now(),
                ride: ImplRide(
                  id: 1,
                  driver: ,
                  passengers: [],
                  route:  ,
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
                PickupRequestNotification(testPickup),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.star_rate),
            title: const Text('Rate (Test)'),
            onTap: () {
              Navigator.pushNamed(context, '/rate');
            },
          ),
        ],
      ),
    );
  }
}
