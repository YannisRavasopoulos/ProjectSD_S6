import 'package:flutter/material.dart';
import 'package:frontend/ui/page/create_ride/create_ride_form.dart';
import 'package:frontend/ui/page/create_ride/create_ride_success.dart';
import 'package:frontend/ui/page/create_ride/create_ride_viewmodel.dart';

class CreateRideView extends StatelessWidget {
  final CreateRideViewModel viewModel;

  const CreateRideView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create a Ride")),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.successMessage != null) {
            return CreateRideSuccess(
              message: viewModel.successMessage!,
              onOkPressed: () async {
                Navigator.pop(context, viewModel.createdRide);
                viewModel.clearMessages();
              },
              onOfferPressed: () async {
                viewModel.clearMessages();
                final ride = viewModel.createdRide;
                if (ride != null) {
                  Navigator.of(
                    context,
                  ).pushNamed('/offer_ride', arguments: ride);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ride not found!')),
                  );
                }
              },
            );
          }
          // Pass only primitive values and callbacks, not the viewmodel itself
          return CreateRideForm(
            from: viewModel.startLocation,
            to: viewModel.endLocation,
            departureTime: viewModel.departureTime,
            seats: viewModel.seats,
            errorMessage: viewModel.errorMessage,
            onCreateRide: () async => await viewModel.saveRide(),
            onFromChanged: viewModel.setFrom,
            onToChanged: viewModel.setTo,
            onFromLocation: viewModel.fromLocationController,
            onToLocation: viewModel.toLocationController,
            onDepartureTimeChanged: viewModel.setDepartureTime,
            onSeatsChanged: viewModel.setSeats,
          );
        },
      ),
    );
  }
}
