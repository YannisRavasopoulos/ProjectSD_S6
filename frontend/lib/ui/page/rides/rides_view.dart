import 'package:flutter/material.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/repository/ride_repository.dart';
import 'package:frontend/ui/page/ride/create/create_ride_viewmodel.dart';
import 'package:frontend/ui/page/rides/rides_viewmodel.dart';
import 'package:frontend/ui/page/rides/ride_list_card.dart';
import 'package:frontend/ui/page/rides/ride_deletion_dialog.dart';
import 'package:frontend/ui/page/ride/create/create_ride_view.dart';

class RidesView extends StatelessWidget {
  final RidesViewModel viewModel;

  final CreateRideViewModel createRideViewModel;

  RidesView({
    super.key,
    required this.viewModel,
    required this.createRideViewModel,
  });

  void _onRemoveRidePressed(BuildContext context, Ride ride) {
    showDialog(
      context: context,
      builder:
          (context) => RideDeletionDialog(
            onDelete: () {
              viewModel.removeRide(ride);
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
          if (viewModel.allRides.isEmpty) {
            return const Center(child: Text('No rides created.'));
          }
          return ListView.builder(
            itemCount: viewModel.allRides.length,
            itemBuilder: (context, index) {
              final ride = viewModel.allRides[index];
              return RideListCard(
                ride: ride,
                onEdit: () async {
                  final editedRide = await Navigator.push<Ride>(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => CreateRideView(
                            viewModel: CreateRideViewModel(
                              rideRepository: viewModel.rideRepository,
                              initialRide: ride,
                            ),
                            ridesViewModel: viewModel,
                          ),
                    ),
                  );
                  if (editedRide != null) {
                    await viewModel.updateRide(editedRide);
                  }
                },
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
                  (context) => CreateRideView(
                    viewModel: CreateRideViewModel(
                      rideRepository: createRideViewModel.rideRepository,
                    ),
                    ridesViewModel: viewModel,
                  ),
            ),
          );
        },
      ),
    );
  }
}
