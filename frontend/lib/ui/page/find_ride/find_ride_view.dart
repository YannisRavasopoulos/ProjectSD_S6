import 'package:flutter/material.dart';
import 'package:frontend/ui/page/find_ride/ride_card.dart';
import 'package:frontend/ui/page/find_ride/ride_location_selectors.dart';
import 'package:frontend/ui/page/find_ride/ride_time_selectors.dart';
import 'package:frontend/ui/page/find_ride/find_ride_viewmodel.dart';

class FindRideView extends StatelessWidget {
  FindRideView({super.key, required this.viewModel});

  final FindRideViewModel viewModel;

  Future<void> _showDepartureTimePicker(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    viewModel.selectDepartureTime(pickedTime?.format(context));
  }

  Future<void> _showArrivalTimePicker(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    viewModel.selectArrivalTime(pickedTime?.format(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find a Ride')),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          // Show the time picker if the user is selecting a departure time
          if (viewModel.selectingDepartureTime) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => _showDepartureTimePicker(context),
            );
          }

          if (viewModel.selectingArrivalTime) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => _showArrivalTimePicker(context),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  child: Column(
                    children: [
                      RideLocationSelectors(
                        onFromLocationChanged: viewModel.setSource,
                        onToLocationChanged: viewModel.setDestination,
                      ),
                      const SizedBox(height: 16.0),
                      RideTimeSelectors(
                        key: ValueKey(viewModel.departureTime),
                        departureTime: viewModel.departureTime,
                        arrivalTime: viewModel.arrivalTime,
                        departureTimes: viewModel.departureTimes,
                        arrivalTimes: viewModel.arrivalTimes,
                        onArrivalTimeChanged: viewModel.setArrivalTime,
                        onDepartureTimeChanged: viewModel.setDepartureTime,
                      ),
                    ],
                  ),
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
                      final ride = viewModel.rides[index];
                      return RideCard(
                        ride: ride,
                        onJoinRide: () => viewModel.rideRepository.join(ride),
                      );
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
