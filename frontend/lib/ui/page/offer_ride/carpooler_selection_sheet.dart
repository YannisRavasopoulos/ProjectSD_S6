import 'package:flutter/material.dart';
import 'package:frontend/data/impl/impl_activity_repository.dart';
import 'package:frontend/data/impl/impl_driver.dart';
import 'package:frontend/data/impl/impl_pickup_repository.dart';
import 'package:frontend/data/impl/impl_ride_repository.dart';
import 'package:frontend/data/impl/impl_route.dart';
import 'package:frontend/data/impl/impl_vehicle.dart';
import 'package:frontend/data/model/activity.dart';
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
                builder: (context) => AlertDialog(
                  title: Text('${carpooler.firstName} ${carpooler.lastName}'),
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
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Close bottom sheet
                        Navigator.pushNamed(
                          context,
                          '/arrange_pickup',
                          arguments: {
                            'carpooler': carpooler,
                            'ride': ride,
                            'activity': activity,
                          },
                        );
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