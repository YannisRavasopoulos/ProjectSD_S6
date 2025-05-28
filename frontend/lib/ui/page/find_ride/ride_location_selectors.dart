import 'package:flutter/material.dart';

class RideLocationSelectors extends StatelessWidget {
  final ValueChanged<String> onFromLocationChanged;
  final ValueChanged<String> onToLocationChanged;
  final String fromLocation;
  final String toLocation;

  const RideLocationSelectors({
    super.key,
    required this.fromLocation,
    required this.toLocation,
    required this.onFromLocationChanged,
    required this.onToLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final fromController = TextEditingController(text: fromLocation);
    final toController = TextEditingController(text: toLocation);

    return Column(
      children: [
        TextField(
          controller: fromController,
          decoration: const InputDecoration(
            labelText: 'From',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_pin),
          ),
          onChanged: onFromLocationChanged,
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            const Divider(thickness: 2),
            Positioned(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceBright,
                ),
                child: IconButton(
                  icon: const Icon(Icons.swap_vert),
                  onPressed: () {
                    // Call parent with swapped values
                    onFromLocationChanged(toController.text);
                    onToLocationChanged(fromController.text);
                  },
                ),
              ),
            ),
          ],
        ),
        TextField(
          controller: toController,
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
