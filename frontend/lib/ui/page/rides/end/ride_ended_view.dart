import 'package:flutter/material.dart';
import 'package:frontend/ui/page/rides/end/ride_ended_viewmodel.dart';

class RideEndedView extends StatelessWidget {
  final RideEndedViewModel viewModel;

  const RideEndedView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Ended'),
        backgroundColor: Color.fromARGB(255, 23, 143, 117),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.emoji_flags,
                    color: Color.fromARGB(255, 23, 143, 117),
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Thank you for riding',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(
                      '${viewModel.ride.driver.firstName} ${viewModel.ride.driver.lastName}',
                    ),
                    subtitle: const Text('Your Driver'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.directions_car),
                    title: Text(
                      '${viewModel.ride.route.start.street} → ${viewModel.ride.route.end.street}',
                    ),
                    subtitle: Text(
                      '${viewModel.ride.route.start.city} to ${viewModel.ride.route.end.city}',
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: Text(
                      'Departure: ${TimeOfDay.fromDateTime(viewModel.ride.departureTime).format(context)}',
                    ),
                    subtitle: Text(
                      'Arrival: ${TimeOfDay.fromDateTime(viewModel.ride.estimatedArrivalTime).format(context)}',
                    ),
                  ),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.star),
                          label: const Text('Rate Driver'),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              '/rate',
                              arguments:
                                  viewModel
                                      .ride
                                      .driver, // Pass the driver as argument
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.secondary,
                            foregroundColor: theme.colorScheme.onSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.report),
                          label: const Text('Report Driver'),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              '/report',
                              arguments:
                                  viewModel
                                      .ride
                                      .driver, // Pass the driver as argument
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade400,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
