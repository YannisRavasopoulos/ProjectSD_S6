import 'package:flutter/material.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/ui/page/find_ride/ride_location_selectors.dart';

class CreateRideForm extends StatelessWidget {
  final Address? from;
  final Address? to;
  final TimeOfDay? departureTime;
  final int seats;
  final String? errorMessage;
  final VoidCallback onCreateRide;
  final ValueChanged<Address> onFromChanged;
  final ValueChanged<Address> onToChanged;
  final TextEditingController onFromLocation;
  final TextEditingController onToLocation;
  final ValueChanged<TimeOfDay> onDepartureTimeChanged;
  final ValueChanged<int> onSeatsChanged;

  const CreateRideForm({
    super.key,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.seats,
    required this.errorMessage,
    required this.onCreateRide,
    required this.onFromChanged,
    required this.onToChanged,
    required this.onFromLocation,
    required this.onToLocation,
    required this.onDepartureTimeChanged,
    required this.onSeatsChanged,
  });

  Future<void> _pickDepartureTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: departureTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      onDepartureTimeChanged(picked);
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
                fromLocationController: onFromLocation,
                toLocationController: onToLocation,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.access_time),
                  const SizedBox(width: 8),
                  Text(
                    departureTime == null
                        ? "Departure Time"
                        : departureTime!.format(context),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _pickDepartureTime(context),
                    child: const Text("Select Time"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.event_seat),
                  const SizedBox(width: 8),
                  const Text("Seats:", style: TextStyle(fontSize: 16)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      if (seats > 1) {
                        onSeatsChanged(seats - 1);
                      }
                    },
                  ),
                  Text('$seats', style: const TextStyle(fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      onSeatsChanged(seats + 1);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (errorMessage != null)
                Text(errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onCreateRide,
                  icon: const Icon(Icons.check),
                  label: const Text("Create a Ride"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
