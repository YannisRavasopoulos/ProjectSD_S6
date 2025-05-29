import 'package:flutter/material.dart';
import 'package:frontend/ui/page/arrange_pickup/arrange_pickup_viewmodel.dart';
import 'package:frontend/ui/page/arrange_pickup/pickup_form.dart';
import 'package:frontend/ui/page/arrange_pickup/ride_details_panel.dart';

class ArrangePickupView extends StatelessWidget {
  final ArrangePickupViewModel viewModel;

  const ArrangePickupView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Arrange Pickup Details')),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  RideDetailsPanel(ride: viewModel.ride),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Set Pickup Details',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          if (viewModel.isLoading)
                            const Center(child: CircularProgressIndicator())
                          else
                            PickupForm(
                              selectedTime: viewModel.selectedTime,
                              location: viewModel.address,
                              onTimeSelected: viewModel.setPickupTime,
                              onLocationChanged: viewModel.setLocation,
                              onSubmit: () => _handleSubmit(context),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: viewModel.ride.availableSeats == 0
                        ? null
                        : () => _handleSubmit(context),
                    child: const Text('Send Pickup Proposal'),
                  ),
                  if (viewModel.ride.availableSeats == 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'This ride is full. No more seats available.',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      // Optionally, add your navigation drawer here:
      // drawer: AppDrawer(),
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (!viewModel.isValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage ?? 'Invalid pickup details'),
        ),
      );
      return;
    }

    final success = await viewModel.arrangePickup();

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pickup proposal sent successfully')),
      );
      Navigator.pop(context);
    } else if (viewModel.errorMessage != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(viewModel.errorMessage!),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
