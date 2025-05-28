import 'package:flutter/material.dart';

class RideLocationSelectors extends StatelessWidget {
  final TextEditingController fromController;
  final TextEditingController toController;
  final ValueChanged<String> onFromLocationChanged;
  final ValueChanged<String> onToLocationChanged;

  const RideLocationSelectors({
    super.key,
    required this.fromController,
    required this.toController,
    required this.onFromLocationChanged,
    required this.onToLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
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
