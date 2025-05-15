import 'package:flutter/material.dart';
import 'package:frontend/data/repository/ride_repository.dart';
import 'package:frontend/ui/find_ride/ride_card.dart';
import 'package:frontend/ui/find_ride/ride_location_selectors.dart';
import 'package:frontend/ui/find_ride/ride_time_selectors.dart';
import 'package:frontend/ui/find_ride/find_ride_viewmodel.dart';
// import 'package:provider/provider.dart';

class FindRideView extends StatelessWidget {
  FindRideView({super.key});

  final viewModel = FindRideViewModel(rideRepository: RideRepository());

  @override
  Widget build(BuildContext context) {
    // Provider.of<FindRideViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Find a Ride')),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    RideLocationSelectors(
                      onFromLocationChanged: viewModel.setSource,
                      onToLocationChanged: viewModel.setDestination,
                    ),
                    const SizedBox(height: 16.0),
                    RideTimeSelectors(
                      onArrivalTimeChanged: viewModel.setArrivalTime,
                      onDepartureTimeChanged: viewModel.setDepartureTime,
                    ),
                  ],
                ),
              ),
              if (viewModel.isLoading)
                Expanded(
                  child: Center(child: const CircularProgressIndicator()),
                )
              else if (viewModel.errorMessage != null)
                Center(
                  child: Text(
                    viewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: viewModel.rides.length,
                    itemBuilder: (context, index) {
                      return RideCard(ride: viewModel.rides[index]);
                    },
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.fetchRides,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
