import 'package:flutter/material.dart';
import 'package:frontend/data/model/pickup.dart';
import 'package:frontend/ui/page/confirm_pickup/confirm_pickup_viewmodel.dart';

class ConfirmPickupView extends StatelessWidget {
  final Pickup pickup;
  final ConfirmPickupViewModel viewModel;

  const ConfirmPickupView({
    super.key,
    required this.pickup,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Pickup')),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Pickup Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text('Location: ${pickup.address.toString()}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: Text('Time: ${pickup.time}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text('Driver: ${pickup.ride.driver.name}'),
                    ),
                    if (viewModel.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          viewModel.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.check),
                          label: const Text('Accept'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () async {
                            final result = await viewModel.acceptPickup();
                            if (result && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Pickup confirmed!'),
                                ),
                              );
                              await Future.delayed(
                                const Duration(milliseconds: 500),
                              );
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.close),
                          label: const Text('Reject'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () async {
                            final result = await viewModel.rejectPickup();
                            if (!result && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Pickup rejected!'),
                                ),
                              );
                              await Future.delayed(
                                const Duration(milliseconds: 500),
                              );
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
