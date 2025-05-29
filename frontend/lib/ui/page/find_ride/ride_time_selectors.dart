import 'package:flutter/material.dart';

class RideTimeSelectors extends StatelessWidget {
  // final ValueChanged<String> onDepartureTimeChanged;
  // final ValueChanged<String> onArrivalTimeChanged;

  final TextEditingController departureTimeController;
  final TextEditingController arrivalTimeController;
  final List<String> departureTimes;
  final List<String> arrivalTimes;
  final ValueChanged<String> onDepartureTimeSelected;
  final ValueChanged<String> onArrivalTimeSelected;

  RideTimeSelectors({
    super.key,
    required this.departureTimeController,
    required this.arrivalTimeController,
    required this.departureTimes,
    required this.arrivalTimes,
    required this.onDepartureTimeSelected,
    required this.onArrivalTimeSelected,
  });

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
            onSelected: (value) => onDepartureTimeSelected(value!),
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
            onSelected: (value) => onArrivalTimeSelected(value!),
          ),
        ),
      ],
    );
  }
}
