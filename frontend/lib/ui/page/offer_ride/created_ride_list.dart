import 'package:flutter/material.dart';
import 'package:frontend/data/model/passenger.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/ui/page/offer_ride/carpooler_selection_sheet.dart';

class CreatedRidesList extends StatelessWidget {
  final bool isLoading;
  final List<Ride> createdRides;
  final List<Passenger> potentialPassengers;
  final Future<void> Function(Ride) onSelectRide;

  const CreatedRidesList({
    super.key,
    required this.isLoading,
    required this.createdRides,
    required this.potentialPassengers,
    required this.onSelectRide,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (createdRides.isEmpty) {
      return const Center(
        child: Text(
          'No rides found.',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: createdRides.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final ride = createdRides[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 20,
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.teal.shade200,
              child: const Icon(Icons.directions_car, color: Colors.white),
            ),
            title: Text(
              '${ride.route.start.name} → ${ride.route.end.name}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text('Ride ID: ${ride.id}'),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.teal,
            ),
            onTap: () async {
              await onSelectRide(ride);
              showModalBottomSheet(
                context: context,
                builder: (_) => CarpoolerSelectionSheet(
                  carpoolers: potentialPassengers,
                  ride: ride,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

