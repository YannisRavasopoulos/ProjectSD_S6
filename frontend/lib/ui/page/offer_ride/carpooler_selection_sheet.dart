import 'package:flutter/material.dart' hide Route;
import 'package:frontend/data/model/activity.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/passenger.dart';
import 'package:frontend/data/model/pickup_request.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/model/route.dart';
import 'package:frontend/data/repository/address_repository.dart';

class CarpoolerSelectionSheet extends StatelessWidget {
  final Address currentAddress;
  final List<Passenger> carpoolers;
  final Ride? ride;
  final Activity? activity;

  const CarpoolerSelectionSheet({
    super.key,
    required this.currentAddress,
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
                              final pickupRequest = PickupRequest(
                                ride: ride!,
                                passenger: carpooler,
                                address: ride!.route.start,
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
                                },
                              );
                            } else if (activity != null) {
                              // Activity flow: create a pickup request using activity info
                              // Use the first hardcoded ride as a template
                              final testRide = Ride(
                                // Unique id for this pseudo-ride
                                driver: ImplDriver(
                                  id: 1,
                                  firstName: 'Activity',
                                  lastName: 'Driver',
                                  vehicle: ImplVehicle.test(),
                                  points: 0,
                                ),
                                passengers: [],
                                route: Route(
                                  start: currentAddress,
                                  end: activity!.address,
                                ),
                                // TODO: FIX
                                departureTime: DateTime.now(),
                                estimatedArrivalTime: DateTime.now().add(
                                  const Duration(minutes: 30),
                                ),
                                estimatedDuration: const Duration(minutes: 30),
                                totalSeats: 5,
                              );

                              final pickupRequest = PickupRequest(
                                ride: testRide,
                                passenger: carpooler,
                                address: activity!.address,
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
