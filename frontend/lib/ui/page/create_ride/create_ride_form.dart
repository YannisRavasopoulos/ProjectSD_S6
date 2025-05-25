import 'package:flutter/material.dart';
import 'package:frontend/ui/page/create_ride/create_ride_viewmodel.dart';
import 'package:frontend/ui/page/find_ride/ride_location_selectors.dart';
import 'package:frontend/ui/page/rides/rides_viewmodel.dart';

class CreateRideForm extends StatelessWidget {
  final CreateRideViewModel viewModel;
  final RidesViewModel ridesViewModel;

  const CreateRideForm({
    super.key,
    required this.viewModel,
    required this.ridesViewModel,
  });

  Future<void> _pickDepartureTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      viewModel.setDepartureTime(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              RideLocationSelectors(
                onFromLocationChanged: (String value) {
                  viewModel.setFrom(value);
                },
                onToLocationChanged: (String value) {
                  viewModel.setTo(value);
                },
              ),
              const SizedBox(height: 16),
              _buildTimePicker(context),
              const SizedBox(height: 16),
              _buildSeatsRow(),
              const SizedBox(height: 20),
              if (viewModel.errorMessage != null)
                Text(
                  viewModel.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              _buildCreateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.access_time),
        const SizedBox(width: 8),
        Text(
          viewModel.departureTime == null
              ? "Departure Time"
              : viewModel.departureTime!.format(context),
          style: const TextStyle(fontSize: 16),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => _pickDepartureTime(context),
          child: const Text("Select Time"),
        ),
      ],
    );
  }

  Widget _buildSeatsRow() {
    return Row(
      children: [
        const Icon(Icons.event_seat),
        const SizedBox(width: 8),
        const Text("Seats:", style: TextStyle(fontSize: 16)),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () {
            if (viewModel.seats > 1) {
              viewModel.setSeats(viewModel.seats - 1);
            }
          },
        ),
        Text('${viewModel.seats}', style: const TextStyle(fontSize: 18)),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () {
            viewModel.setSeats(viewModel.seats + 1);
          },
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          final ride = await viewModel.createRide();
          if (ride != null) {
            await ridesViewModel.addRide(ride); // <-- προσθήκη
          }
        },
        icon: const Icon(Icons.check),
        label: const Text("Create a Ride"),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
