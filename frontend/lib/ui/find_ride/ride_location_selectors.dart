import 'package:flutter/material.dart';

class RideLocationSelectors extends StatelessWidget {
  final ValueChanged<String> onFromLocationChanged;
  final ValueChanged<String> onToLocationChanged;

  const RideLocationSelectors({
    super.key,
    required this.onFromLocationChanged,
    required this.onToLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: 'From',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_pin),
          ),
          onChanged: onFromLocationChanged,
        ),
        const SizedBox(height: 16.0),
        TextField(
          decoration: const InputDecoration(
            labelText: 'To',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_searching),
          ),
          onChanged: onToLocationChanged,
        ),
      ],
    );
  }
}
