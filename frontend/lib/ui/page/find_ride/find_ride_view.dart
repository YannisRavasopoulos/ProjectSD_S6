import 'package:flutter/material.dart';
import 'package:frontend/data/model/activity.dart';
import 'package:frontend/ui/page/find_ride/activity_selection_panel.dart';
import 'package:frontend/ui/page/find_ride/ride_card.dart';
import 'package:frontend/ui/page/find_ride/ride_location_selectors.dart';
import 'package:frontend/ui/page/find_ride/ride_time_selectors.dart';
import 'package:frontend/ui/page/find_ride/find_ride_viewmodel.dart';

class FindRideView extends StatelessWidget {
  FindRideView({super.key, required this.viewModel});

  final FindRideViewModel viewModel;

  void _onActivitySelected(Activity activity, BuildContext context) {
    viewModel.selectActivity(activity);
    Navigator.pop(context, activity);
  }

  void onDepartureTimeSelected(String value, BuildContext context) async {
    if (value != "Select") {
      return;
    }

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      viewModel.departureTimeController.text = pickedTime.format(context);
    } else {
      viewModel.departureTimeController.text = "Now";
    }
  }

  void onArrivalTimeSelected(String value, BuildContext context) async {
    if (value != "Select") {
      return;
    }

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      viewModel.arrivalTimeController.text = pickedTime.format(context);
    } else {
      viewModel.arrivalTimeController.text = "Soonest";
    }
  }

  static const List<String> _departureTimes = [
    'Now',
    'in 15 minutes',
    'in 30 minutes',
    'Select',
  ];
  static const List<String> _arrivalTimes = [
    'Soonest',
    'in 15 minutes',
    'in 30 minutes',
    'Select',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Ride'),
        backgroundColor: const Color.fromARGB(255, 23, 143, 117),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('Select from activities'),
                    onPressed: () async {
                      await showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        builder:
                            (context) => ActivitySelectionPanel(
                              onActivitySelected:
                                  (activity) =>
                                      _onActivitySelected(activity, context),
                              activities: viewModel.activities,
                            ),
                      );
                    },
                  ),
                ),
              ),
              // --- Separator with text and icon ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Expanded(child: Divider(thickness: 1)),
                    const SizedBox(width: 8),
                    const Icon(Icons.flash_on, color: Colors.amber),
                    const SizedBox(width: 4),
                    const Text(
                      'Insta-Ride',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(child: Divider(thickness: 1)),
                  ],
                ),
              ),
              // --- End separator ---
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  child: Column(
                    children: [
                      RideLocationSelectors(
                        fromLocationController:
                            viewModel.fromLocationController,
                        toLocationController: viewModel.toLocationController,
                      ),
                      const SizedBox(height: 16.0),
                      RideTimeSelectors(
                        departureTimeController:
                            viewModel.departureTimeController,
                        arrivalTimeController: viewModel.arrivalTimeController,
                        departureTimes: _departureTimes,
                        arrivalTimes: _arrivalTimes,
                        onDepartureTimeSelected:
                            (value) => onDepartureTimeSelected(value, context),
                        onArrivalTimeSelected:
                            (value) => onArrivalTimeSelected(value, context),
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
                        onJoinRide: () => viewModel.joinRide(ride),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'activitiesBtn',
              backgroundColor: const Color.fromARGB(255, 117, 202, 160),
              onPressed: () {
                Navigator.of(context).pushNamed('/activities');
              },
              tooltip: 'Manage Activities',
              child: const Icon(Icons.calendar_month),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              heroTag: 'refreshBtn',
              onPressed: viewModel.fetchRides,
              child: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),
    );
  }
}
