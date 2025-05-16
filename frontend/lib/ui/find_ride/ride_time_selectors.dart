import 'package:flutter/material.dart';

class RideTimeSelectors extends StatelessWidget {
  final ValueChanged<String> onDepartureTimeChanged;
  final ValueChanged<String> onArrivalTimeChanged;

  final TextEditingController departureTimeController;
  final TextEditingController arrivalTimeController;

  final List<String> departureTimes;
  final List<String> arrivalTimes;

  RideTimeSelectors({
    super.key,
    required this.onDepartureTimeChanged,
    required this.onArrivalTimeChanged,
    required this.arrivalTimes,
    required this.departureTimes,
    required String departureTime,
    required String arrivalTime,
  }) : departureTimeController = TextEditingController(text: departureTime),
       arrivalTimeController = TextEditingController(text: arrivalTime);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: DropdownMenu<String>(
            label: Text('Departure Time'),
            expandedInsets: EdgeInsets.all(0),
            controller: departureTimeController,
            dropdownMenuEntries:
                departureTimes
                    .map((time) => DropdownMenuEntry(value: time, label: time))
                    .toList(),
            requestFocusOnTap: false,
            onSelected: (value) => onDepartureTimeChanged(value!),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: DropdownMenu<String>(
            label: Text('Arrival Time'),
            expandedInsets: EdgeInsets.all(0),
            controller: arrivalTimeController,
            dropdownMenuEntries:
                arrivalTimes
                    .map((time) => DropdownMenuEntry(value: time, label: time))
                    .toList(),
            requestFocusOnTap: false,
            onSelected: (value) => onArrivalTimeChanged(value!),
          ),
        ),
      ],
    );
  }
}
