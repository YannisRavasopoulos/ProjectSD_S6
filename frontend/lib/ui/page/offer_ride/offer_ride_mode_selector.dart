import 'package:flutter/material.dart';
import 'package:frontend/ui/page/offer_ride/offer_ride_view.dart';

class OfferRideModeSelector extends StatelessWidget {
  final ValueNotifier<OfferRideMode> modeNotifier;

  const OfferRideModeSelector({required this.modeNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<OfferRideMode>(
      valueListenable: modeNotifier,
      builder: (context, mode, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text('Created Rides'),
                selected: mode == OfferRideMode.createdRides,
                onSelected: (selected) {
                  if (selected) modeNotifier.value = OfferRideMode.createdRides;
                },
                selectedColor: Colors.teal,
                labelStyle: TextStyle(
                  color:
                      mode == OfferRideMode.createdRides
                          ? Colors.white
                          : Colors.teal,
                ),
              ),
              const SizedBox(width: 16),
              ChoiceChip(
                label: const Text('Activities'),
                selected: mode == OfferRideMode.activities,
                onSelected: (selected) {
                  if (selected) modeNotifier.value = OfferRideMode.activities;
                },
                selectedColor: Colors.teal,
                labelStyle: TextStyle(
                  color:
                      mode == OfferRideMode.activities
                          ? Colors.white
                          : Colors.teal,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
