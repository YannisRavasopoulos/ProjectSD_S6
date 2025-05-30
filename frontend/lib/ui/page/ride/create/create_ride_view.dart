import 'package:flutter/material.dart';
import 'package:frontend/data/model/activity.dart';
// import 'package:frontend/ui/page/ride/create/create_ride_form.dart';
// import 'package:frontend/ui/page/ride/create/create_ride_success.dart';
import 'package:frontend/ui/page/ride/create/create_ride_viewmodel.dart';
import 'package:frontend/ui/page/ride/find/activity_selection_panel.dart';
import 'package:frontend/ui/shared/datetime_selector.dart';
import 'package:frontend/ui/shared/loading_button.dart';
import 'package:frontend/ui/shared/text_address_selector.dart';

class CreateRideView extends StatelessWidget {
  final CreateRideViewModel viewModel;

  const CreateRideView({super.key, required this.viewModel});

  void _onActivitySelected(Activity activity, BuildContext context) {
    viewModel.selectActivity(activity);
    Navigator.pop(context, activity);
  }

  DateTime _departureTimeOptionsToDateTime(String value) {
    switch (value) {
      case "Now":
        return DateTime.now();
      case "in 15 minutes":
        return DateTime.now().add(const Duration(minutes: 15));
      case "in 30 minutes":
        return DateTime.now().add(const Duration(minutes: 30));
      default:
        // Fallback to current time if no match
        return DateTime.now();
    }
  }

  DateTime _arrivalTimeOptionsToDateTime(String value) {
    switch (value) {
      case "Soonest":
        return DateTime.now();
      case "in 15 minutes":
        return DateTime.now().add(const Duration(minutes: 15));
      case "in 30 minutes":
        return DateTime.now().add(const Duration(minutes: 30));
      default:
        // Fallback to current time if no match
        return DateTime.now();
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

  void _onCreateRidePressed(BuildContext context) async {
    bool success = await viewModel.createRide();
    if (success) {
      // Navigate to success page or show success message
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ride created successfully!')),
      );
      // Navigator.pushReplacementNamed(context, '/ride/success');
    } else {
      // Show error message
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage ?? 'Failed to create ride'),
        ),
      );
    }
  }

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
                    const Icon(Icons.directions_car, color: Colors.lightGreen),
                    const SizedBox(width: 4),
                    const Text(
                      'Custom-Ride',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.lightGreen,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: DateTimeSelector(
                              key: viewModel.departureTimeSelectorKey,
                              labelText: 'Departure Time',
                              options: _departureTimes,
                              onDateTimeSelected: viewModel.selectDepartureTime,
                              optionsToDateTime:
                                  _departureTimeOptionsToDateTime,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: DateTimeSelector(
                              key: viewModel.arrivalTimeSelectorKey,
                              labelText: 'Arrival Time',
                              options: _arrivalTimes,
                              onDateTimeSelected: viewModel.selectArrivalTime,
                              optionsToDateTime: _arrivalTimeOptionsToDateTime,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16.0),
                  Text(
                    viewModel.isFormValid ? "" : "Please fill in all fields.",
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: 200, // Set a fixed width or adjust as needed
                    child: LoadingButton(
                      isLoading: viewModel.isCreatingRide,
                      onPressed:
                          viewModel.isFormValid
                              ? () => _onCreateRidePressed(context)
                              : null,
                      child: Text("Create Ride"),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
