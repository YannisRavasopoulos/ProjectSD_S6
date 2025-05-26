import 'package:flutter/material.dart';
import 'package:frontend/ui/page/create_ride/create_ride_form.dart';
import 'package:frontend/ui/page/create_ride/create_ride_success.dart';
import 'package:frontend/ui/page/create_ride/create_ride_viewmodel.dart';
import 'package:frontend/ui/page/rides/rides_viewmodel.dart';

class CreateRideView extends StatelessWidget {
  final CreateRideViewModel viewModel;
  final RidesViewModel ridesViewModel;

  CreateRideView({
    super.key,
    required this.viewModel,
    required this.ridesViewModel,
  });

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
              onSavePressed: () async {
                Navigator.pop(context, viewModel.createdRide);
                viewModel.clearMessages();
              },
              onOfferPressed: () async {
                viewModel.clearMessages();
                final ride = viewModel.createdRide;
                if (ride != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ride offer successfully!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ride not found!')),
                  );
                }
              },
            );
          }
          return CreateRideForm(
            viewModel: viewModel,
            ridesViewModel: ridesViewModel,
          );
        },
      ),
    );
  }
}
