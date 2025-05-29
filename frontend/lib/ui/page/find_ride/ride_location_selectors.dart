import 'package:flutter/material.dart';

class RideLocationSelectors extends StatelessWidget {
  final TextEditingController fromLocationController;
  final TextEditingController toLocationController;
  final ValueChanged<String>? onFromLocationChanged;
  final ValueChanged<String>? onToLocationChanged;

  const RideLocationSelectors({
    super.key,
    required this.fromLocationController,
    required this.toLocationController,

    // TODO: these are hear because of shit code in create ride...
    this.onFromLocationChanged,
    this.onToLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: fromLocationController,
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
                    var temp = fromLocationController.text;
                    fromLocationController.text = toLocationController.text;
                    toLocationController.text = temp;
                  },
                ),
              ),
            ),
          ],
        ),
        TextField(
          controller: toLocationController,
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
