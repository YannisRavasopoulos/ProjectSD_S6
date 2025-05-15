import 'package:flutter/material.dart';

class RideTimeSelectors extends StatelessWidget {
  final ValueChanged<String?> onDepartureTimeChanged;
  final ValueChanged<String?> onArrivalTimeChanged;

  const RideTimeSelectors({
    super.key,
    required this.onArrivalTimeChanged,
    required this.onDepartureTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Departure Time',
              border: OutlineInputBorder(),
            ),
            items:
                ['Now', '15min', '30min', '1hr']
                    .map(
                      (time) =>
                          DropdownMenuItem(value: time, child: Text(time)),
                    )
                    .toList(),
            value: "Now",
            onChanged: onDepartureTimeChanged,
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Arrival Time',
              border: OutlineInputBorder(),
            ),
            items:
                ['Soonest', '30min', '1hr', '2hr']
                    .map(
                      (time) =>
                          DropdownMenuItem(value: time, child: Text(time)),
                    )
                    .toList(),
            value: "Soonest",
            onChanged: onArrivalTimeChanged,
          ),
        ),
      ],
    );
  }
}
