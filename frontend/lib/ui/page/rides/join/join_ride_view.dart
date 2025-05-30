import 'package:flutter/material.dart' hide Route;
import 'package:frontend/ui/notification/notification_overlay.dart';
import 'package:frontend/ui/page/pickups/confirm/pickup_arranged_notification.dart';
import 'package:frontend/ui/page/rides/join/join_ride_viewmodel.dart';
import 'package:frontend/ui/shared/route_view.dart';

class JoinRideView extends StatelessWidget {
  final JoinRideViewModel viewModel;

  const JoinRideView({super.key, required this.viewModel});

  void _onProceedPressed(BuildContext context) async {
    Navigator.of(
      context,
    ).pushNamed('/pickup/confirm', arguments: viewModel.pickup);
  }

  void _onJoinRidePressed() async {
    final pickupRequest = await viewModel.joinRide();
    if (pickupRequest != null) {
      // Handle successful join ride
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Joining Ride'), elevation: 0),
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, _) {
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

          if (viewModel.hasJoinedRide && !viewModel.isArrangingPickup) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              NotificationOverlay.show(
                context,
                PickupArrangedNotification(pickup: viewModel.pickup!),
              );
            });
          }

          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  child: RouteView(route: viewModel.ride.route),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.directions_car, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            'Ride Details',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'From: ${viewModel.ride.route.start.toString()}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.flag, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'To: ${viewModel.ride.route.end.toString()}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(
                            'Departure: ${viewModel.ride.departureTime}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.timer, color: Colors.purple),
                          const SizedBox(width: 8),
                          Text(
                            'Estimated Duration: ${viewModel.ride.estimatedDuration}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.person, color: Colors.blueGrey),
                          const SizedBox(width: 8),
                          Text(
                            'Driver: ${viewModel.ride.driver.name}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      if (viewModel.hasJoinedRide &&
                          !viewModel.isArrangingPickup) ...[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                'Driver arranged pickup!',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(color: Colors.green),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => _onProceedPressed(context),
                              child: const Text('Proceed'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ] else if (viewModel.hasJoinedRide &&
                          viewModel.isArrangingPickup) ...[
                        Column(
                          children: [
                            const Center(child: CircularProgressIndicator()),
                            const SizedBox(height: 16),
                            Text(
                              'Waiting for driver to arrange pickup...',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ] else ...[
                        Center(
                          child: ElevatedButton(
                            onPressed: _onJoinRidePressed,
                            child: const Text('Join Ride'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
