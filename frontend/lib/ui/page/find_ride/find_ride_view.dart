import 'package:flutter/material.dart';
import 'package:frontend/data/model/activity.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/ui/page/find_ride/activity_selection_panel.dart';
import 'package:frontend/ui/page/find_ride/ride_card.dart';
import 'package:frontend/ui/page/find_ride/ride_time_selectors.dart';
import 'package:frontend/ui/page/find_ride/find_ride_viewmodel.dart';
import 'package:frontend/ui/shared/map/text_address_selector.dart';

class FindRideView extends StatelessWidget {
  FindRideView({super.key, required this.viewModel});

  final FindRideViewModel viewModel;

  void _onActivitySelected(Activity activity, BuildContext context) {
    viewModel.selectActivity(activity);
    Navigator.pop(context, activity);
  }

  void _onDepartureTimeSelected(String value, BuildContext context) async {
    switch (value) {
      case "Now":
        await viewModel.selectArrivalTime(DateTime.now());
        return;
      case "in 15 minutes":
        await viewModel.selectArrivalTime(
          DateTime.now().add(const Duration(minutes: 30)),
        );
        return;
      case "in 30 minutes":
        await viewModel.selectArrivalTime(
          DateTime.now().add(const Duration(minutes: 30)),
        );
        return;
      default:
        break;
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

    await viewModel.selectDepartureTime(
      DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        pickedTime!.hour,
        pickedTime.minute,
      ),
    );
  }

  void _onArrivalTimeSelected(String value, BuildContext context) async {
    switch (value) {
      case "Soonest":
        await viewModel.selectArrivalTime(DateTime.now());
        return;
      case "in 15 minutes":
        await viewModel.selectArrivalTime(
          DateTime.now().add(const Duration(minutes: 30)),
        );
        return;
      case "in 30 minutes":
        await viewModel.selectArrivalTime(
          DateTime.now().add(const Duration(minutes: 30)),
        );
        return;
      default:
        break;
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

    await viewModel.selectDepartureTime(
      DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        pickedTime!.hour,
        pickedTime.minute,
      ),
    );
  }

  void _onJoinRidePressed(Ride ride, BuildContext context) {
    Navigator.pushReplacementNamed(context, '/join_ride', arguments: ride);
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
                      TextAddressSelector(
                        key: viewModel.fromAddressSelectorKey,
                        onAddressSelected: viewModel.selectFromAddress,
                        addressRepository: viewModel.addressRepository,
                        labelText: "From",
                      ),
                      const SizedBox(height: 16.0),
                      TextAddressSelector(
                        key: viewModel.toAddressSelectorKey,
                        onAddressSelected: viewModel.selectToAddress,
                        addressRepository: viewModel.addressRepository,
                        labelText: "To",
                      ),
                      const SizedBox(height: 16.0),
                      RideTimeSelectors(
                        departureTimeController:
                            viewModel.departureTimeController,
                        arrivalTimeController: viewModel.arrivalTimeController,
                        departureTimes: _departureTimes,
                        arrivalTimes: _arrivalTimes,
                        onDepartureTimeSelected:
                            (value) => _onDepartureTimeSelected(value, context),
                        onArrivalTimeSelected:
                            (value) => _onArrivalTimeSelected(value, context),
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
                        onJoinRidePressed:
                            () => _onJoinRidePressed(ride, context),
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
