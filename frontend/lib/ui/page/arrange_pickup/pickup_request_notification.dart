import 'package:flutter/material.dart';
import 'package:frontend/data/model/pickup.dart';
import 'package:frontend/ui/page/arrange_pickup/arrange_pickup_view.dart';
import 'package:frontend/ui/page/arrange_pickup/arrange_pickup_viewmodel.dart';
import 'package:frontend/data/repository/pickup_repository.dart';
import 'package:frontend/data/service/pickup_service.dart';
import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/model/vehicle.dart';
import 'dart:math';
import 'package:frontend/ui/notification/notification_overlay.dart';

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
                      pickup.time.toString(),
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Pickup request from ${pickup.driver.id}',
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red, size: 20),
                tooltip: 'Decline',
                onPressed: () {
                  NotificationOverlay.dismiss();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pickup request declined'),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      backgroundColor: Color.fromARGB(255, 156, 119, 117),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.check, color: Colors.green, size: 20),
                tooltip: 'Accept',
                onPressed: () {
                  NotificationOverlay.dismiss();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => ArrangePickupView(
                            viewModel: ArrangePickupViewModel(
                              repository: PickupRepository(
                                pickupService: PickupService(),
                              ),
                              driver: Driver.random(),
                              // TODO
                              rideId: 5,
                            ),
                            carpoolerId: "TODO",
                            driver: Driver.random(),
                            selectedRide: Ride.random(),
                          ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
