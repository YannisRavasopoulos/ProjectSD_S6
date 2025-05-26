import 'package:flutter/material.dart';
import 'package:frontend/ui/page/offer_ride/offer_ride_viewmodel.dart';

class CreatedRidesList extends StatelessWidget {
  final OfferRideViewModel viewModel;

  const CreatedRidesList({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        final rides = viewModel.createdRides;
        if (rides.isEmpty) {
          return const Center(
            child: Text(
              'No rides found.',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: rides.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final ride = rides[index];
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
                  '${ride.route.start.name}'
                  ' → '
                  '${ride.route.end.name}',
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
                  final carpoolers = await viewModel.findNearbyCarpoolers(
                    ride.id.toString(),
                  );
                  showDialog(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: const Text('Nearby Carpoolers'),
                          content:
                              carpoolers.isEmpty
                                  ? const Text('No carpoolers found.')
                                  : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children:
                                        carpoolers
                                            .map(
                                              (c) => ListTile(
                                                leading: const Icon(
                                                  Icons.person,
                                                ),
                                                title: Text(c),
                                              ),
                                            )
                                            .toList(),
                                  ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
