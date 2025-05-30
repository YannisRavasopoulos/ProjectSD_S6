import 'package:flutter/material.dart';
import 'package:frontend/data/model/passenger.dart';

class SelectPassengerPopup extends StatelessWidget {
  final List<Passenger> passengers;
  final List<Passenger> initiallySelected;

  const SelectPassengerPopup({
    super.key,
    required this.passengers,
    this.initiallySelected = const [],
  });

  @override
  Widget build(BuildContext context) {
    // Use a local set to track selection in the bottom sheet
    final selected = Set<Passenger>.from(initiallySelected);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select Passengers',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (passengers.isEmpty) const Text('No passengers available.'),
          ...passengers.map(
            (passenger) => StatefulBuilder(
              builder:
                  (context, setState) => CheckboxListTile(
                    title: Text(passenger.name),
                    value: selected.contains(passenger),
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          selected.add(passenger);
                        } else {
                          selected.remove(passenger);
                        }
                      });
                    },
                  ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, selected.toList()),
                  child: const Text('Confirm'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
