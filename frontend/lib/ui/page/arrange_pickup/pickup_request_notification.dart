import 'package:flutter/material.dart';
import 'package:frontend/data/model/pickup_request.dart';
import 'package:frontend/ui/notification/notification_overlay.dart';

class PickupRequestNotification extends StatelessWidget {
  final PickupRequest pickupRequest;

  const PickupRequestNotification({super.key, required this.pickupRequest});

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
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 13,
                          color:
                              Colors
                                  .black, // or Theme.of(context).colorScheme.onSurface
                        ),
                        children: [
                          const TextSpan(
                            text: 'New Pickup Request ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                '${pickupRequest.passenger.firstName} ${pickupRequest.passenger.lastName}',
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
                Text(
                  'Pickup request for ride: ${pickupRequest.ride.route.toString()}',
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
                  Navigator.of(context).pushNamed(
                    '/arrange_pickup',
                    arguments: {
                      'pickupRequest': pickupRequest,
                      'driver': pickupRequest.ride.driver,
                    },
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
