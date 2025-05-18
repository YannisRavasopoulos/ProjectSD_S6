import 'package:flutter/material.dart';

class RideLocationSelectors extends StatefulWidget {
  final ValueChanged<String> onFromLocationChanged;
  final ValueChanged<String> onToLocationChanged;

  const RideLocationSelectors({
    super.key,
    required this.onFromLocationChanged,
    required this.onToLocationChanged,
  });

  @override
  _RideLocationSelectorsState createState() => _RideLocationSelectorsState();
}

class _RideLocationSelectorsState extends State<RideLocationSelectors> {
  late TextEditingController fromLocationController;
  late TextEditingController toLocationController;

  @override
  void initState() {
    super.initState();
    fromLocationController = TextEditingController();
    toLocationController = TextEditingController();

    fromLocationController.addListener(() {
      widget.onFromLocationChanged(fromLocationController.text);
    });

    toLocationController.addListener(() {
      widget.onToLocationChanged(toLocationController.text);
    });
  }

  @override
  void dispose() {
    fromLocationController.dispose();
    toLocationController.dispose();
    super.dispose();
  }

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
                    // Swap the two fields
                    final temp = fromLocationController.text;
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
        ),
      ],
    );
  }
}
