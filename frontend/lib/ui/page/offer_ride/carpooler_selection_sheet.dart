import 'package:flutter/material.dart';
import 'package:frontend/data/impl/impl_activity_repository.dart';
import 'package:frontend/data/impl/impl_driver.dart';
import 'package:frontend/data/impl/impl_pickup_repository.dart';
import 'package:frontend/data/impl/impl_ride_repository.dart';
import 'package:frontend/data/impl/impl_route.dart';
import 'package:frontend/data/impl/impl_vehicle.dart';
import 'package:frontend/data/model/passenger.dart';
import 'package:frontend/data/model/ride.dart';

class CarpoolerSelectionSheet extends StatelessWidget {
  final List<Passenger> carpoolers;
  final Ride? ride;
  final ImplActivity? activity;

  const CarpoolerSelectionSheet({
    super.key,
    required this.carpoolers,
    this.ride,
    this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: carpoolers.length,
      itemBuilder: (context, index) {
        final carpooler = carpoolers[index];
        return ListTile(
          leading: const Icon(Icons.person),
          title: Text('${carpooler.firstName} ${carpooler.lastName}'),
          subtitle: Text('Points: ${carpooler.points}'),
          trailing: ElevatedButton(
            child: const Text('Info & Select'),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text(
                        '${carpooler.firstName} ${carpooler.lastName}',
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: ${carpooler.id}'),
                          Text('Points: ${carpooler.points}'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            if (ride != null) {
                              // Normal ride flow
                              final pickupRequest = ImplPickupRequest(
                                id: DateTime.now().millisecondsSinceEpoch,
                                ride: ride!,
                                passenger: carpooler,
                                location: ride!.route.start,
                                time: DateTime.now().add(
                                  const Duration(minutes: 10),
                                ),
                              );
                              Navigator.pop(context); // Close dialog
                              Navigator.pop(context); // Close bottom sheet
                              Navigator.pushNamed(
                                context,
                                '/arrange_pickup',
                                arguments: {
                                  'pickupRequest': pickupRequest,
                                  'driver': ride!.driver,
                                  'rideId': ride!.id,
                                },
                              );
                            } else if (activity != null) {
                              // Activity flow: create a pickup request using activity info
                              // Use the first hardcoded ride as a template
                              final testRide = ImplRide(
                                id: 9999, // Unique id for this pseudo-ride
                                driver: ImplDriver(
                                  id: 1,
                                  firstName: 'Activity',
                                  lastName: 'Driver',
                                  vehicle: ImplVehicle.test(),
                                  points: 0,
                                ),
                                passengers: [],
                                route: ImplRoute(
                                  id: 9999,
                                  start: activity!.startLocation,
                                  end: activity!.endLocation,
                                ),
                                // TODO: FIX
                                departureTime: DateTime.now(),
                                estimatedArrivalTime: DateTime.now().add(
                                  const Duration(minutes: 30),
                                ),
                                estimatedDuration: const Duration(minutes: 30),
                                totalSeats: 5,
                              );

                              final pickupRequest = ImplPickupRequest(
                                id: DateTime.now().millisecondsSinceEpoch,
                                ride: testRide,
                                passenger: carpooler,
                                location: activity!.startLocation,
                                time: DateTime.now(),
                              );

                              Navigator.pop(context); // Close dialog
                              Navigator.pop(context); // Close bottom sheet
                              Navigator.pushNamed(
                                context,
                                '/arrange_pickup',
                                arguments: {
                                  'pickupRequest': pickupRequest,
                                  'driver': testRide.driver,
                                  'rideId': testRide.id,
                                },
                              );
                            }
                          },
                          child: const Text('Arrange Pickup'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
              );
            },
          ),
        );
      },
    );
  }
}
