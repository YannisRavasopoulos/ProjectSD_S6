import 'package:flutter/material.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/repository/ride_repository.dart';
import 'package:frontend/ui/page/create_ride/create_ride_viewmodel.dart';
import 'package:frontend/ui/page/create_ride/rides_list_viewmodel.dart';
import 'package:frontend/ui/page/create_ride/ride_list_card.dart';
import 'package:frontend/ui/page/create_ride/ride_deletion_dialog.dart';
import 'package:frontend/ui/page/create_ride/create_ride_view.dart';

class RidesListView extends StatelessWidget {
  final RidesListViewModel viewModel;

  final CreateRideViewModel createRideViewModel = CreateRideViewModel(
    rideRepository: RideRepository(),
  );

  RidesListView({super.key, required this.viewModel});

  void _onRemoveRidePressed(BuildContext context, Ride ride) {
    showDialog(
      context: context,
      builder:
          (context) => RideDeletionDialog(
            onDelete: () {
              viewModel.removeRide(ride.id);
              Navigator.of(context).pop();
            },
            onCancel: () => Navigator.of(context).pop(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Created Rides')),
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.createdRides.isEmpty) {
            return const Center(child: Text('No rides created.'));
          }
          return ListView.builder(
            itemCount: viewModel.createdRides.length,
            itemBuilder: (context, index) {
              final ride = viewModel.createdRides[index];
              return RideListCard(
                ride: ride,
                onEdit: () {}, // implement edit if needed
                onRemove: () => _onRemoveRidePressed(context, ride),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newRide = await Navigator.push<Ride>(
            context,
            MaterialPageRoute(
              builder:
                  (context) => CreateRideView(viewModel: createRideViewModel),
            ),
          );
          if (newRide != null) {
            // Μετά το create, ρώτα τον χρήστη αν θέλει να το κάνει offer ή να το κρατήσει στα created
            final action = await showDialog<String>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: const Text('Ride Created'),
                    content: const Text(
                      'Do you want to offer this ride or just save it?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'offer'),
                        child: const Text('Offer Ride'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'created'),
                        child: const Text('Save Only'),
                      ),
                    ],
                  ),
            );
            if (action == 'created') {
              await viewModel.addRide(newRide);
            }
            // TODO: Implement the logic to offer the ride
          }
        },
      ),
    );
  }
}
