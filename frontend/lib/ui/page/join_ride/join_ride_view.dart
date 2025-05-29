import 'package:flutter/material.dart';
import 'package:frontend/ui/notification/notification_overlay.dart';
import 'package:frontend/ui/page/confirm_pickup/pickup_acknowledgement_notification.dart';
import 'package:frontend/ui/page/join_ride/join_ride_viewmodel.dart';
import 'package:frontend/ui/page/join_ride/detail_row.dart';

class JoinRideView extends StatelessWidget {
  final JoinRideViewModel viewModel;

  const JoinRideView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final pickupRequest = viewModel.joinRide();

    return Scaffold(
      appBar: AppBar(title: const Text('Joining Ride'), elevation: 0),
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, _) {
          if (viewModel.pickup != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              NotificationOverlay.show(
                context,
                PickupAcknowledgementNotification(pickup: viewModel.pickup!),
              );
            });
          }

          if (viewModel.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Requesting to join ride...',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Color(0xFFF5F5F5)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ride Details',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 24),
                          DetailRow(
                            icon: Icons.person,
                            label: 'Driver',
                            value: viewModel.ride.driver.name,
                          ),
                          const SizedBox(height: 16),
                          DetailRow(
                            icon: Icons.directions_car,
                            label: 'Vehicle',
                            value: viewModel.ride.driver.vehicle.description,
                          ),
                          const SizedBox(height: 16),
                          DetailRow(
                            icon: Icons.location_on,
                            label: 'From',
                            value: viewModel.ride.route.start.toString(),
                          ),
                          const SizedBox(height: 16),
                          DetailRow(
                            icon: Icons.location_on,
                            label: 'To',
                            value: viewModel.ride.route.end.toString(),
                          ),
                          const SizedBox(height: 16),
                          DetailRow(
                            icon: Icons.access_time,
                            label: 'Departure',
                            value: viewModel.ride.departureTime.toString(),
                          ),
                          const SizedBox(height: 16),
                          DetailRow(
                            icon: Icons.event_seat,
                            label: 'Available Seats',
                            value:
                                '${viewModel.ride.availableSeats}/${viewModel.ride.totalSeats}',
                          ),
                          // Add the progress indicator here
                          const SizedBox(height: 32),
                          const Center(child: CircularProgressIndicator()),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (viewModel.errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              viewModel.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
