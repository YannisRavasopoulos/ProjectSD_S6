import 'package:flutter/material.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/ui/page/arrange_pickup/pickup_map_view.dart';

class PickupForm extends StatelessWidget {
  final DateTime? selectedTime;
  final Address location;
  final Function(DateTime) onTimeSelected;
  final Function(Address) onLocationChanged;
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
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(selectedTime?.toString() ?? 'Select Time'),
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
                  onTimeSelected(selectedDateTime);
                }
              },
            ),
            const SizedBox(height: 16),
            PickupMapView(
              location: location,
              onLocationChanged: onLocationChanged,
            ),
            if (location.coordinates.latitude != 0.0 ||
                location.coordinates.longitude != 0.0)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Selected location: ${location.coordinates.latitude}, ${location.coordinates.longitude}',
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
