import 'package:flutter/material.dart';
import 'package:frontend/ui/arrange_pickup/components/pickup_map_view.dart';

class PickupForm extends StatefulWidget {
  final DateTime? selectedTime;
  final String location;
  final Function(DateTime) onTimeSelected;
  final Function(String) onLocationChanged;
  final Function() onSubmit;

  const PickupForm({
    super.key,
    required this.selectedTime,
    required this.location,
    required this.onTimeSelected,
    required this.onLocationChanged,
    required this.onSubmit,
  });

  @override
  State<PickupForm> createState() => _PickupFormState();
}

class _PickupFormState extends State<PickupForm> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(widget.selectedTime?.toString() ?? 'Select Time'),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  final now = DateTime.now();
                  final selectedDateTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    time.hour,
                    time.minute,
                  );
                  widget.onTimeSelected(selectedDateTime);
                }
              },
            ),
            const SizedBox(height: 16),
            PickupMapView(onLocationChanged: widget.onLocationChanged),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: widget.onSubmit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Confirm Pickup Arrangement'),
            ),
          ],
        ),
      ),
    );
  }
}
