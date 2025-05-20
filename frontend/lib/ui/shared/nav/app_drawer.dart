import 'package:flutter/material.dart';
import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/pickup.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/service/pickup_service.dart';
import 'package:frontend/ui/arrange_pickup/components/pickup_request_notification.dart';
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
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
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
            leading: const Icon(Icons.notifications),
            title: const Text('Test Notification'),
            onTap: () {
              // Dummy data for testing
              final testRide = Ride.random();
              final testDriver = Driver.random();

              final pickup = Pickup(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                ride: testRide,
                driver: testDriver,
                carpoolerId: 'test_user_id',
                pickupTime: DateTime.now().add(const Duration(minutes: 30)),
                location: 'Test Location',
                status: 'requested',
              );
              //

              Navigator.pop(context); // Close drawer first

              NotificationOverlay.show(
                context,
                PickupRequestNotification(
                  pickup: pickup,
                  onArrange: () {
                    Navigator.pushNamed(
                      context,
                      '/arrange_pickup',
                      arguments: {
                        'carpoolerId': pickup.carpoolerId,
                        'driverId': pickup.driver.id,
                        'ride': pickup.ride,
                      },
                    );
                  },
                  onDecline: () async {
                    final pickupService = PickupService();
                    await pickupService.updatePickupStatus(
                      pickupId: pickup.id,
                      status: 'declined',
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
