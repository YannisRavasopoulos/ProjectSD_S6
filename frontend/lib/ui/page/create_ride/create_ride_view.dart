import 'package:flutter/material.dart';
import 'package:frontend/ui/page/create_ride/create_ride_form.dart';
import 'package:frontend/ui/page/create_ride/create_ride_success.dart';
import 'package:frontend/ui/page/create_ride/create_ride_viewmodel.dart';

class CreateRideView extends StatelessWidget {
  final CreateRideViewModel viewModel;

  CreateRideView({super.key, required this.viewModel});

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
              onOkPressed: () {
                final ride = viewModel.updatedRide ?? viewModel.createdRide;
                Navigator.of(context).pop(ride); // returns ride
                viewModel.clearMessages();
              },
              onOfferPressed: () {
                viewModel.clearMessages();
                final ride = viewModel.createdRide;
                if (ride != null) {
                  Navigator.of(
                    context,
                  ).pushReplacementNamed('/offer-ride', arguments: ride);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ride not found!')),
                  );
                }
              },
            );
          }
          return CreateRideForm(viewModel: viewModel);
        },
      ),
    );
  }
}